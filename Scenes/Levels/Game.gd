extends Node2D

# Signals
signal lit_cells_updated(new_lit_cells: Dictionary)

# Consts
var light_group := "light"
var darkness_layer := 1

# Node references
@onready var tile_map: WorldTileMap = $WorldTileMap
@onready var player: CharacterBody2D = $Player

# Variables
var lit_cells: Dictionary = {}
var player_tile_coords: Vector2i

func _ready() -> void:
	player_tile_coords = calculate_tile_coords(player)
	player_tile_coords = calculate_tile_coords(player)
	prepare_new_turn()

func _process(_delta: float) -> void:	
	# Detect new turn (player moved to a new tile)
	var previous_player_tile_coords = player_tile_coords
	player_tile_coords = calculate_tile_coords(player)
	if previous_player_tile_coords != player_tile_coords:
		prepare_new_turn()
	
func prepare_new_turn() -> void:
	# TODO: remove extinguished light sources
	calculate_lit_cells()
	
func calculate_lit_cells() -> void:
	var light_sources: Array[Node] = get_tree().get_nodes_in_group("light")
	
	lit_cells.clear()
	for light_source in light_sources:
		if light_source is LightSource:
			var light_source_coords = calculate_tile_coords(light_source)
			for light_shift in light_source.LightMap:
				lit_cells[light_source_coords + light_shift] = true
	emit_signal("lit_cells_updated", lit_cells)

func calculate_tile_coords(object: Node2D) -> Vector2i:
	return tile_map.local_to_map(tile_map.to_local(object.global_position))
