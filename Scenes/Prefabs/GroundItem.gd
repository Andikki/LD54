extends Node2D

@export var grid_pos: Vector2i
@export var item: Resource

var tile_size = 32

#constructor
func _init(grid_position: Vector2i, item_type: Item):
	grid_pos = grid_position
	item = item_type


func _ready() -> void:
	$Sprite2D.texture = item.sprite
	#find position if item
	position = grid_pos * tile_size
