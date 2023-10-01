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
@export var has_collision: bool
#@export var ingredient_in

func _init(m_item_name: String = ""):
	item_name = m_item_name

func _ready():
	if location == Location.GROUND and has_collision:
		$StaticBody2D/CollisionShape2D.disabled = false
	else:
		$StaticBody2D/CollisionShape2D.disabled = true

func adjust_sprite_position() -> void:
	if location == Location.GROUND:
		$SpriteContainer.position = $TileCentreAnchor.position
	elif  location == Location.HAND:
		$SpriteContainer.position = $HandAnchor.position


func _on_click_target_area_input_event(viewport, event, shape_idx):
	print("Item clicked with name: " + item_name)
