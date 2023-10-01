extends Node2D

@export var grid_pos: Vector2i

var item: Item
var light_source: LightSource
var is_light_source: bool

var tile_size:int = 32


func _ready() -> void:
	item = null
	light_source = null
	
	for n_chld in get_children():
		if n_chld is Item:
			item = n_chld
		elif n_chld is LightSource:
			light_source = n_chld
	
	if item != null:
		$Sprite2D.texture = item.sprite
	
	is_light_source = light_source !=null
	
	#find position if item
	position = grid_pos * tile_size - Vector2i(tile_size/2, tile_size/2)
