extends Node2D

@export var grid_pos: Vector2i
@export var item: Item

var tile_size = 32


func _ready() -> void:
	$Sprite2D.texture = item.sprite
	#find position if item
	position = grid_pos * tile_size - Vector2i(tile_size/2, tile_size/2)
