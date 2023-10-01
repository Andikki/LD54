extends Node

class_name Item

var title: String
var sprite_path: String
var sprite: Texture2D
var ingredient_in

func _init(title_name: String, sprite_file_path: String):
	title = title_name
	sprite_path = sprite_file_path
	if sprite_path is String and sprite_path.is_valid_filename():
		sprite = load(sprite_path)
	else:
		push_error("Could not find sprite path for item: " + title)
