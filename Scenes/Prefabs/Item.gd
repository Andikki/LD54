class_name Item
extends Node2D

enum Location {GROUND, HAND}

@export_category("Item Properties")
@export var item_name: String
@export var location: Location = Location.GROUND:
	get:
		return location
	set(value): 
		location = value
		adjust_sprite_position()
		update_collision()
@export var has_collision: bool
#@export var ingredient_in

@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready():
	location = location
	
func update_collision() -> void:
	if collision_shape != null:
		collision_shape.disabled = location == Location.HAND or not has_collision

func adjust_sprite_position() -> void:
	if location == Location.GROUND:
		$SpriteContainer.position = $HandAnchor.position + ($HandAnchor.position - $TileCentreAnchor.position)
	elif  location == Location.HAND:
		$SpriteContainer.position = $HandAnchor.position

func drop_on_the_ground(tile_map: WorldTileMap, cell_coords: Vector2i) -> void:
	location = Location.GROUND
	position = tile_map.map_to_local(cell_coords)
	tile_map.add_child(self)

func take_in_hand(hand_node: Node2D) -> void:
	location = Location.HAND
	position = Vector2.ZERO
	hand_node.add_child(self)

func _on_click_target_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_hand_action"):
		print("Item clicked with name: " + item_name)
