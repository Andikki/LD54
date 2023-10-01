extends Node2D

signal cells_lit_status_updated(new_cells_lit_status: Dictionary)

@onready var tile_map: TileMap = $TileMap
@onready var player: CharacterBody2D = $Player
@onready var candle: Node2D = $Player/Candle

var darkness_layer := 1
var top_left_tile_coords := Vector2i(-1, -1)
var bottom_right_tile_coords := Vector2i(29, 16)

var cells_lit_status: Dictionary = {}
var player_tile_coords: Vector2i
var light_sources: Array[LightSource]

func _ready() -> void:
	player_tile_coords = tile_map.local_to_map(player.position)
	light_sources.append(candle)	


func _process(_delta: float) -> void:
	
	# Detect new turn (player moved to a new tile)
	var previous_player_tile_coords = player_tile_coords
	player_tile_coords = tile_map.local_to_map(player.position)
	if previous_player_tile_coords != player_tile_coords:
		prepare_new_turn()

func prepare_new_turn() -> void:
	# TODO: remove extinguished light sources
	calculate_lit_tiles()
	emit_signal("cells_lit_status_updated", cells_lit_status)
	
func calculate_lit_tiles() -> void:
	for x_index in range(top_left_tile_coords.x, bottom_right_tile_coords.x):
		for y_index in range(top_left_tile_coords.y, bottom_right_tile_coords.y):
			cells_lit_status[Vector2i(x_index, y_index)] = false

	for light_source in light_sources:
		var light_source_position = tile_map.local_to_map(light_source.global_position)
		for light_shift in light_source.LightMap:
			cells_lit_status[light_source_position + light_shift] = true
