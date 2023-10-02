class_name WorldTileMap
extends TileMap

@export var top_left_tile_coords := Vector2i(-1, -1)
@export var bottom_right_tile_coords := Vector2i(30, 17)

var darkness_layer := 1
var custom_data_lit_layer := "Lit"
var terrain_set_main := 0
var terrain_light := 0
var terrain_darkness := 1

var cells_lit_status: Dictionary = {}

func _on_cells_lit_status_updated(new_cells_lit_status: Dictionary) -> void:
	var cells_to_lit: Array[Vector2i] = []
	var cells_to_darken: Array[Vector2i] = []
	
	for cell_x in range(top_left_tile_coords.x, bottom_right_tile_coords.x):
		for cell_y in range(top_left_tile_coords.y, bottom_right_tile_coords.y):
			var cell_coords = Vector2i(cell_x, cell_y)
			if new_cells_lit_status.has(cell_coords):
				var should_be_lit = new_cells_lit_status[cell_coords]
				var tile_data = get_cell_tile_data(darkness_layer, cell_coords)
				
				var is_lit: bool = not should_be_lit
				if tile_data != null:
					is_lit = tile_data.get_custom_data(custom_data_lit_layer)
					
				if should_be_lit and not is_lit:
					cells_to_lit.append(cell_coords)
				elif not should_be_lit and is_lit:
					cells_to_darken.append(cell_coords)
	
	if cells_to_darken.size() > 0:
		set_cells_terrain_connect(darkness_layer, cells_to_darken, terrain_set_main, terrain_darkness, false)
	
	if cells_to_lit.size() > 0:
		set_cells_terrain_connect(darkness_layer, cells_to_lit, terrain_set_main, terrain_light, false)
