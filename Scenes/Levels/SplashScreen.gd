extends Node2D

@export var game_scene: PackedScene

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
