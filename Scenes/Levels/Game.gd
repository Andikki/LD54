class_name Game
extends Node2D

# Signals
signal lit_cells_updated(new_lit_cells: Dictionary, old_lit_cells: Dictionary)
signal ingredients_for_crafting_updated(ingredients: Array[Item])

# Consts
var light_group := "light"
var item_spawn_chance_in_turns := 30
var spawning_items: Array[Resource] = [
	preload("res://Scenes/Items/Grass.tscn"),
	preload("res://Scenes/Items/Log.tscn")
]
var rope_resource: Resource = preload("res://Scenes/Items/Rope.tscn")
var raft_resource: Resource = preload("res://Scenes/Items/Raft.tscn")

# Node references
@onready var tile_map: WorldTileMap = $WorldTileMap
@onready var items_container: Node2D = $WorldTileMap/Items
@onready var player: Player = $Player
@onready var crafting_hud: CanvasLayer = $Crafting

# Variables
var lit_cells: Dictionary = {}
var player_cell_coordinates := Vector2i.ZERO

func _ready() -> void:
	randomize()
	
	player_cell_coordinates = get_object_cell_coords(player)
	
	for item in items_container.get_children():
		item.cell_coordinates = get_object_cell_coords(item)
		item.position = tile_map.map_to_local(item.cell_coordinates)
		
	trigger_new_turn(true)

func _process(_delta: float) -> void:	
	# Detect new turn (player moved to a new tile)
	var previous_player_cell_coordinates = player_cell_coordinates
	player_cell_coordinates = get_object_cell_coords(player)
	if previous_player_cell_coordinates != player_cell_coordinates:
		trigger_new_turn()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var clicked_cell_coords = get_cell_coords_by_position(event.position)
		
		if event.is_action_pressed("left_hand_action"):
			pick_and_drop(clicked_cell_coords, Player.Hand.LEFT)
		elif event.is_action_pressed("right_hand_action"):
			pick_and_drop(clicked_cell_coords, Player.Hand.RIGHT)

func pick_and_drop(cell_coords: Vector2i, hand: Player.Hand) -> void:
	# Only allow action in cels adjascent to the player
	var distance_from_player = (cell_coords - player_cell_coordinates).abs()
	if distance_from_player > Vector2i.ONE:
		return
	
	# Only allow action if target cell can hold items
	if not tile_map.cell_can_hold_items(cell_coords):
		return
	
	var item_from_ground: Item = remove_item_from_ground(cell_coords)
	var item_from_hand: Item = player.remove_item_from_hand(hand)
	
	if item_from_ground != null:
		item_from_ground.take_in_hand(player, hand)
	
	if item_from_hand != null:
		item_from_hand.drop_on_the_ground(tile_map, cell_coords)
	
	if item_from_ground != null and item_from_ground.item_name == "Raft":
		get_tree().change_scene_to_file("res://Scenes/Levels/EndingEscape.tscn")
		return
	
	trigger_new_turn()

func remove_item_from_ground(cell_coords: Vector2i) -> Item:
	var item = get_ground_item(cell_coords)
	if item != null:
		items_container.remove_child(item)
	return item

func trigger_new_turn(is_first_turn: bool = false) -> void:
	# TODO: remove extinguished light sources
	var old_lit_cells = lit_cells.duplicate()
	calculate_lit_cells()
	if not is_first_turn:
		spawn_items(lit_cells, old_lit_cells)
		despawn_items(lit_cells)
	lit_cells_updated.emit(lit_cells, old_lit_cells)
	var ingredients_for_crafting = calculate_ingredients_for_crafting()
	ingredients_for_crafting_updated.emit(ingredients_for_crafting)

func calculate_lit_cells() -> void:
	var light_sources: Array[Node] = get_tree().get_nodes_in_group("light")
	
	lit_cells.clear()
	for light_source in light_sources:
		if light_source is LightSource:
			light_source.add_to_lit_cells(lit_cells)

func spawn_items(new_lit_cells: Dictionary, old_lit_cells: Dictionary) -> void:
	for cell_coords in new_lit_cells.keys():
		var was_lit = old_lit_cells.has(cell_coords)
		if not was_lit:
			if tile_map.cell_can_hold_items(cell_coords):
				var do_spawn = randi() % item_spawn_chance_in_turns == 0
				if do_spawn:
					var item_resource: Resource = spawning_items.pick_random()
					var item: Item = item_resource.instantiate()
					item.drop_on_the_ground(tile_map, cell_coords)

func despawn_items(new_lit_cells: Dictionary) -> void:
	for item in items_container.get_children():
		if not new_lit_cells.has(item.cell_coordinates):
			item.queue_free()

func _on_please_place_rope():
	var rope: Item = rope_resource.instantiate()
	rope.drop_on_the_ground(tile_map, player_cell_coordinates)

func _on_please_place_raft():
	var raft: Item = raft_resource.instantiate()
	raft.drop_on_the_ground(tile_map, player_cell_coordinates)

func calculate_ingredients_for_crafting() -> Array[Item]:
	var ingredients_for_crafting: Array[Item] = []
	
	var ground_items = items_container.get_children()
	for item in ground_items:
		if item is Item \
			and item.location == Item.Location.GROUND \
			and calculate_distance_from_player(item.cell_coordinates) <= Vector2i.ONE:
				ingredients_for_crafting.append(item)
	
	var left_hand_item = player.show_item(Player.Hand.LEFT)
	if left_hand_item != null:
		ingredients_for_crafting.append(left_hand_item)
	var right_hand_item = player.show_item(Player.Hand.RIGHT)
	if right_hand_item != null:
		ingredients_for_crafting.append(right_hand_item)

	return ingredients_for_crafting

func get_object_cell_coords(object: Node2D) -> Vector2i:
	return get_cell_coords_by_position(object.global_position)

func get_cell_coords_by_position(position_value: Vector2) -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(position_value))

func get_ground_item(cell_coords: Vector2i) -> Item:
	for item in items_container.get_children():
		if item is Item and item.cell_coordinates == cell_coords:
			return item
	return null

func calculate_distance_from_player(cell_coords: Vector2i) -> Vector2i:
	return (cell_coords - player_cell_coordinates).abs()
