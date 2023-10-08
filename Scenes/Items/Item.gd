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

@export var has_collision: bool = false:
	get:
		return has_collision
	set(value): 
		has_collision = value
		update_collision()

@export var cell_coordinates: Vector2i

@onready var collision_shape: CollisionShape2D = $SpriteContainer/StaticBody2D/CollisionShape2D

func _ready() -> void:
	location = location

func update_collision() -> void:
	if collision_shape != null:
		collision_shape.disabled = location == Location.HAND or not has_collision

func adjust_sprite_position() -> void:
	if location == Location.GROUND:
		$SpriteContainer.position = Vector2.ZERO
	elif  location == Location.HAND:
		$SpriteContainer.position = - $HandAnchor.position

func drop_on_the_ground(tile_map: WorldTileMap, cell_coords: Vector2i) -> void:
	cell_coordinates = cell_coords
	location = Location.GROUND
	
	var items_node = tile_map.get_node("Items")
	
	if get_parent() == null:
		items_node.add_child(self)
	else:
		self.reparent(items_node)
		
	position = tile_map.map_to_local(cell_coords)

func take_in_hand(player: Player, hand: Player.Hand) -> void:
	cell_coordinates = Vector2i.ZERO
	location = Location.HAND
	
	var hand_node = player.get_hand_node(hand)
	
	if get_parent() == null:
		hand_node.add_child(self)
	else:
		self.reparent(hand_node)
	
	position = Vector2.ZERO
