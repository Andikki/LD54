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

func _process(_delta: float) -> void:	
	# Detect new turn (player moved to a new tile)
	var previous_player_tile_coords = player_tile_coords
	player_tile_coords = calculate_tile_coords(player)
	if previous_player_tile_coords != player_tile_coords:
		prepare_new_turn(false)
	
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
					item.position = tile_map.map_to_local(cell_coords)
					item.location = item.Location.GROUND
					tile_map.add_child(item)

func calculate_tile_coords(object: Node2D) -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(object.global_position))
