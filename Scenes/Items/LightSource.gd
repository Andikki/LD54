extends Node2D
class_name LightSource

@export var light_map: Array[Vector2i]

func add_to_lit_cells(lit_cells: Dictionary) -> void:
	var item = get_parent() as Item
	var cell_coordinates: Vector2i
	
	if item == null:
		return
	
	if item.location == Item.Location.GROUND:
		cell_coordinates = item.cell_coordinates
	elif item.location == Item.Location.HAND:
		var game_node = get_tree().current_scene as Game
		if game_node == null:
			return
		cell_coordinates = game_node.player_cell_coordinates
		
	for light_shift in light_map:
		lit_cells[cell_coordinates + light_shift] = true
