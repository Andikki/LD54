@tool
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
@export var has_collision: bool = false
@export var ground_coordinates: Vector2i

@onready var collision_shape: CollisionShape2D = $SpriteContainer/StaticBody2D/CollisionShape2D

func _ready() -> void:
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
	ground_coordinates = cell_coords
	location = Location.GROUND
	var items_node = tile_map.get_node("Items")
	# TODO: maybe remove item from hand and thus always have it unparented?
	if get_parent() == null:
		items_node.add_child(self)
	else:
		self.reparent(items_node)
	position = tile_map.map_to_local(cell_coords)

func take_in_hand(hand_node: Node2D) -> void:
	ground_coordinates = Vector2i.ZERO
	location = Location.HAND
	self.reparent(hand_node)
	position = Vector2.ZERO
