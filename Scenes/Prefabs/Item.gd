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
@export var has_collision: bool
#@export var ingredient_in

@export_category("Scene Nodes")
@export var ground_tilemap: Node2D
@export var player_node: Node2D

func _init(m_item_name: String = ""):
	item_name = m_item_name

func _ready():
	
	if location == Location.GROUND and has_collision:
		$StaticBody2D/CollisionShape2D.disabled = false
	else:
		$StaticBody2D/CollisionShape2D.disabled = true
	
	adjust_sprite_position()

func adjust_sprite_position() -> void:
	if location == Location.GROUND:
		$SpriteContainer.position = $TileCentreAnchor.position
		if ground_tilemap != null:
			var current_tile_coord = ground_tilemap.local_to_map(self.position)
			var tilemap_tile_size = ground_tilemap.tile_set.tile_size.x
			var inter_tile_adjustment = Vector2(tilemap_tile_size/2.0,tilemap_tile_size/2.0)
		
			#print("current_tile - " + str(current_tile_coord))
			position = Vector2(current_tile_coord * tilemap_tile_size) + inter_tile_adjustment
	elif  location == Location.HAND:
		$SpriteContainer.position = $HandAnchor.position
		if player_node != null:
			global_position = player_node.global_position


func _on_click_target_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_hand_action"):
		print("Item clicked with name: " + item_name)
