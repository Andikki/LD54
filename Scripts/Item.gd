extends Node

class_name Item

var title: String
var sprite_path: String
var ingredient_in

func _init(title_name: String, sprite_file_path: String):
	title = title_name
	sprite_path = sprite_file_path
