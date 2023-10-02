class_name WorldTileMap
extends TileMap

@export var top_left_tile_coords := Vector2i(-1, -1)
@export var bottom_right_tile_coords := Vector2i(30, 17)
@export var ground_layer := 0
@export var darkness_layer := 1
@export var custom_data_lit := "Lit"
@export var custom_data_can_hold_items := "CanHoldItems"

var terrain_set_main := 0
var terrain_light := 0
var terrain_darkness := 1

func _on_lit_cells_updated(new_lit_cells: Dictionary, _old_lit_cells: Dictionary) -> void:
	var cells_to_lit: Array[Vector2i] = []
	var cells_to_darken: Array[Vector2i] = []
	
	for cell_x in range(top_left_tile_coords.x, bottom_right_tile_coords.x):
		for cell_y in range(top_left_tile_coords.y, bottom_right_tile_coords.y):
			var cell_coords = Vector2i(cell_x, cell_y)
			var should_be_lit = new_lit_cells.has(cell_coords)
			var is_lit: bool = get_custom_data(darkness_layer, cell_coords, custom_data_lit, not should_be_lit)
				
			if should_be_lit and not is_lit:
				cells_to_lit.append(cell_coords)
			elif not should_be_lit and is_lit:
				cells_to_darken.append(cell_coords)
		

	if cells_to_darken.size() > 0:
		set_cells_terrain_connect(darkness_layer, cells_to_darken, terrain_set_main, terrain_darkness, false)

	if cells_to_lit.size() > 0:
		set_cells_terrain_connect(darkness_layer, cells_to_lit, terrain_set_main, terrain_light, false)

func get_custom_data(layer: int, cell_coords: Vector2i, data_name: String, default_value: Variant) -> Variant:
	var tile_data = get_cell_tile_data(layer, cell_coords)
	if tile_data == null:
		return default_value
	else:
		var custom_data = tile_data.get_custom_data(data_name)
		if custom_data == null:
			return default_value
		else:
			return custom_data
