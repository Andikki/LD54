extends Node2D

class_name Item

@export var m_name: String
@export var sprite: Texture2D
#@export var ingredient_in

func _init(m_name: String = "", m_sprite: Texture2D = Texture2D.new()):
	name = m_name
	sprite = m_sprite
