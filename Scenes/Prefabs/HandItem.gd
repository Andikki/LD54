extends Node2D

var item: Item
var light_source: LightSource
var is_light_source: bool

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
