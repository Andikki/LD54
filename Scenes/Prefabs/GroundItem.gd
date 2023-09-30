extends Node2D

var grid_pos: Vector2i
var item: Item

#constructor
func _init(grid_position: Vector2i, item_type: Item):
	grid_pos = grid_position
	item = item_type
