class_name Item
extends Node2D

enum Location {GROUND, HAND}

@export var item_name: String
@export var location: Location = Location.GROUND:
	get:
		return location
	set(value): 
		location = value
		adjust_sprite_position()
#@export var ingredient_in

func _init(m_item_name: String = ""):
	item_name = m_item_name
	
func adjust_sprite_position() -> void:
	if location == Location.GROUND:
		$SpriteContainer.position = $HandAnchor.position + ($HandAnchor.position - $TileCentreAnchor.position)
	elif  location == Location.HAND:
		$SpriteContainer.position = $HandAnchor.position
