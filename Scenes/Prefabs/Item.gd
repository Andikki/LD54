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
#@export var ingredient_in

@export_category("Scene Nodes")
@export var game_node: Game

@onready var collision_shape: CollisionShape2D = \
		$SpriteContainer/StaticBody2D/CollisionShape2D
@onready var click_area_shape: CollisionShape2D = \
		$ClickTargetArea/CollisionShape2D
@onready var world_tile_coord = Vector2i(-1,-1)

signal pickup(event: InputEvent, item_node: Item)

func _init(m_item_name: String = ""):
	item_name = m_item_name

func _ready():
	location = location
	
	if game_node == null:
		game_node = get_tree().get_root().find_child("Game")
	
	adjust_sprite_position()

func update_collision() -> void:
	if collision_shape != null:
		collision_shape.disabled = location == Location.HAND or not has_collision


func adjust_sprite_position() -> void:
	if collision_shape != null and click_area_shape != null:
		if location == Location.GROUND:
			$SpriteContainer.position = $HandAnchor.position + ($HandAnchor.position - $TileCentreAnchor.position)
			#Enable collision shapes where necessary
			collision_shape.disabled = not has_collision
			click_area_shape.disabled = false
			$ClickTargetArea.monitoring = true
		elif  location == Location.HAND:
			$SpriteContainer.position = $HandAnchor.position
			#Disable collision shapes
			collision_shape.disabled = true
			click_area_shape.disabled = true
			$ClickTargetArea.monitoring = true

func drop_on_the_ground(tile_map: WorldTileMap, cell_coords: Vector2i) -> void:
	location = Location.GROUND
	self.reparent(tile_map)
	position = tile_map.map_to_local(cell_coords)
	world_tile_coord = cell_coords
	#Lambda function to disable / enable collision after everything else
	collision_shape.disabled = not has_collision
	click_area_shape.disabled = false
	

func take_in_hand(hand_node: Node2D) -> void:
	location = Location.HAND
	self.reparent(hand_node)
	position = Vector2.ZERO
	world_tile_coord = Vector2(-1,-1)
	#Lambda function to disable / enable collision after everything else
	collision_shape.disabled = not has_collision
	click_area_shape.disabled = false

func _on_click_target_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_hand_action") or\
			event.is_action_pressed("right_hand_action"):
		print("Test for item closeness to player")
		game_node._on_pickup(event, self)
