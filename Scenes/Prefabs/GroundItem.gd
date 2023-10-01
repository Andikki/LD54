extends Node2D

@export var grid_pos: Vector2i

var item: Item

var tile_size:int = 32


func _ready() -> void:
	item = null
	
	position = grid_pos * tile_size - Vector2i(tile_size/2, tile_size/2)
