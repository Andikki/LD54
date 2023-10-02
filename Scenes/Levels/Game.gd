extends Node2D

# Signals
signal lit_cells_updated(new_lit_cells: Dictionary, old_lit_cells: Dictionary)

# Consts
var light_group := "light"
var item_spawn_chance_in_turns := 30
var spawning_items: Array[Resource] = [
	preload("res://Scenes/Items/Grass.tscn"),
	preload("res://Scenes/Items/Log.tscn")
]

# Node references
@onready var tile_map: WorldTileMap = $WorldTileMap
@onready var player: CharacterBody2D = $Player

# Variables
var lit_cells: Dictionary = {}
var player_tile_coords: Vector2i

func _ready() -> void:
	randomize()
	player_tile_coords = calculate_tile_coords(player)
	player_tile_coords = calculate_tile_coords(player)
	prepare_new_turn(true)
	
	#manage player and tilemap references in item nodes
	#this is because references suck :)))
	var temp_player_node = $Player
	var temp_world_tiles = $WorldTileMap
	var world_items = temp_world_tiles.get_node("Items").get_children()
	var player_items = temp_player_node.get_children()
	world_items.append_array(player_items)
	if world_items.size() > 0:
		for m_item in world_items:
			if m_item is Item:
				m_item = m_item as Item
				m_item.player_node = temp_player_node
				m_item.ground_tilemap = temp_world_tiles
	

func _process(_delta: float) -> void:	
	# Detect new turn (player moved to a new tile)
	var previous_player_tile_coords = player_tile_coords
	player_tile_coords = calculate_tile_coords(player)
	if previous_player_tile_coords != player_tile_coords:
		prepare_new_turn(false)

func _input(event):
	if event.is_action_pressed("left_hand_action") and $Player.left_held_item != null:
		var temp_dropping_pos = mouse_pos_item_drop_global_position()
		var dropping_cell = tile_map.local_to_map(tile_map.to_local(temp_dropping_pos))
	elif event.is_action_pressed("right_hand_action") and $Player.right_held_item != null:
		var temp_dropping_pos = mouse_pos_item_drop_global_position()
		var dropping_cell = tile_map.local_to_map(tile_map.to_local(temp_dropping_pos))

func mouse_pos_item_drop_global_position() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_dir = (mouse_pos - global_position).normalized()
	
	var direction_to_mouse = mouse_dir.dot(Vector2.UP)
	
	var dropping_direction
	
	if direction_to_mouse > 0.5:
		dropping_direction =  Vector2.UP
	elif direction_to_mouse < -0.5:
		dropping_direction =  Vector2.DOWN
	else:
		var horizontal_dir_test = mouse_dir.dot(Vector2.RIGHT)
		if horizontal_dir_test > 0:
			dropping_direction =  Vector2.RIGHT
		else:
			dropping_direction =  Vector2.LEFT
	
	var dropping_pos =  (dropping_direction * tile_map.cell_quadrant_size)\
			 + player.global_position 
	
	return dropping_pos

func _on_pickup(event: InputEvent, item: Item) -> void:
	#This code can only be ran if an item on the ground has been clicked
	#  > on to be picked up.
	# Called from a signal in Item
	print("picking up: " + item.item_name)
	if event.is_action_pressed("left_hand_action"):
		if player.left_held_item == null:
			var item_cell = calculate_tile_coords(item)
			item.reparent(player.left_hand_placeholder)
			item.location = Item.Location.HAND
			item.take_in_hand(player.left_hand_placeholder)
	elif event.is_action_pressed("right_hand_action"):
		if player.right_held_item == null:
			var item_cell = calculate_tile_coords(item)
			item.reparent(player.right_hand_placeholder)
			item.location = Item.Location.HAND
			item.take_in_hand(player.right_hand_placeholder)
	#only connect to one item's pickup signal at a time
	disconnect("pick_up", self._on_pickup)

func prepare_new_turn(is_first_turn: bool) -> void:
	# TODO: remove extinguished light sources
	var old_lit_cells = lit_cells.duplicate()
	calculate_lit_cells()
	if not is_first_turn:
		spawn_items(lit_cells, old_lit_cells)
	emit_signal("lit_cells_updated", lit_cells, old_lit_cells)
	
func calculate_lit_cells() -> void:
	var light_sources: Array[Node] = get_tree().get_nodes_in_group("light")
	
	lit_cells.clear()
	for light_source in light_sources:
		if light_source is LightSource:
			var light_source_coords = calculate_tile_coords(light_source)
			for light_shift in light_source.LightMap:
				lit_cells[light_source_coords + light_shift] = true

func spawn_items(new_lit_cells: Dictionary, old_lit_cells: Dictionary) -> void:
	for cell_coords in new_lit_cells.keys():
		var was_lit = old_lit_cells.has(cell_coords)
		if not was_lit:
			var tile_can_hold_items = tile_map.get_custom_data(tile_map.ground_layer, cell_coords, tile_map.custom_data_can_hold_items, false)
			if tile_can_hold_items:
				var do_spawn = randi() % item_spawn_chance_in_turns == 0
				if do_spawn:
					var item_resource: Resource = spawning_items.pick_random()
					var item: Item = item_resource.instantiate()
					item.drop_on_the_ground(tile_map, cell_coords)

func calculate_tile_coords(object: Node2D) -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(object.global_position))
