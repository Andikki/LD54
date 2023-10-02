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

@export_category("Scene Nodes")
@export var ground_tilemap: Node2D
@export var player_node: Node2D
@onready var collision_shape: CollisionShape2D = \
		$SpriteContainer/StaticBody2D/CollisionShape2D/CollisionShape2D

signal pickup(event: InputEvent, item_node: Item)

func _init(m_item_name: String = ""):
	item_name = m_item_name

func _ready():
	location = location
	
	if player_node == null:
		player_node = get_tree().get_root().find_child("Player")
	if ground_tilemap == null:
		ground_tilemap = get_tree().get_root().find_child("WorldTileMap")
	
	adjust_sprite_position()

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
	self.reparent(tile_map)

func take_in_hand(hand_node: Node2D) -> void:
	location = Location.HAND
	position = Vector2.ZERO
	self.reparent(hand_node)

func _on_click_target_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_hand_action") or\
			event.is_action_pressed("right_hand_action"):
		print("Test for item closeness to player")
		if not player_node.get_parent().is_connected("pick_up", player_node.get_parent()._on_pickup):
			pickup.connect( player_node.get_parent()._on_pickup)
		pickup.emit(event as InputEvent, self)
