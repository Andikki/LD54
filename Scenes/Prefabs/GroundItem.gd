extends Node2D

var grid_pos: Vector2i
var item

#constructor
func _init(grid_position: Vector2i, item_type):
	grid_pos = grid_position
	item = item_type
