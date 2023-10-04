class_name Player
extends CharacterBody2D

enum Hand {LEFT, RIGHT}

@export var move_speed := 100.0
@export var starting_direction := Vector2.DOWN

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var footsteps_player: AudioStreamPlayer2D = $FootstepsPlayer
@onready var left_hand_node: Node2D = $LeftHand
@onready var right_hand_node: Node2D = $RightHand

func _ready() -> void:
	update_animation_parameters(starting_direction)

func _physics_process(_delta: float) -> void:
	var input_direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)	
	
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		
	velocity = input_direction * move_speed
	
	update_animation_parameters(input_direction)
	
	move_and_slide()

## If the player is currently holding anything in this hand, returns held item.
## The caller needs to move returned item elsewhere,
## otherwise the player will end up holding two items in one hand.
## Passed item can also be null, then this function will just return held item.
func take_item(item: Item, hand: Hand) -> Item:
	var held_item: Item = show_item(hand)

	if item != null:
		var hand_node: Node2D = left_hand_node if hand == Hand.LEFT else right_hand_node
		item.take_in_hand(hand_node)
	
	return held_item

func show_item(hand: Hand) -> Item:
	var hand_node: Node2D = left_hand_node if hand == Hand.LEFT else right_hand_node
	return null if hand_node.get_child_count() == 0 else hand_node.get_child(0)

func update_animation_parameters(move_direction: Vector2) -> void:
	if move_direction != Vector2.ZERO:
		animation_tree["parameters/Walk/blend_position"] = move_direction
		animation_tree["parameters/Idle/blend_position"] = move_direction

	if velocity == Vector2.ZERO:
		animation_state_machine.travel("Idle")
	else:
		animation_state_machine.travel("Walk")

func play_footsteps_audio() -> void:
	footsteps_player.pitch_scale = randf_range(0.9, 1.1)
	footsteps_player.play()
