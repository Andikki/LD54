extends Node2D

@export var grid_pos: Vector2i

var item: Item
var light_source: LightSource
var is_light_source: bool

var tile_size:int = 32


func _ready() -> void:
	#search for item and lightsource nodes
	for n_chld in get_children():
		if n_chld is Item:
			item = n_chld
		elif n_chld is LightSource:
			light_source = n_chld
	
	if item:
		$Sprite2D.texture = item.sprite
	
	if light_source:
		is_light_source = true
	else:
		is_light_source = false
	
	#find position if item
	position = grid_pos * tile_size - Vector2i(tile_size/2, tile_size/2)
