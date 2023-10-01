extends TileMap

var darkness_layer := 1

func _on_cells_lit_status_updated(cells_lit_status: Dictionary) -> void:
	for cell_coords in get_used_cells(darkness_layer):
		if cells_lit_status.has(cell_coords):
			var is_lit = cells_lit_status[cell_coords]
			if is_lit:
				pass
			else:
				pass
				
			
