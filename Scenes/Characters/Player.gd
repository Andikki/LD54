extends CharacterBody2D

@export var move_speed := 100.0
@export var starting_direction := Vector2.UP
@export var left_held_item: Item = null
@export var right_held_item: Item = null

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var footsteps_player: AudioStreamPlayer2D = $FootstepsPlayer
@onready var left_hand_placeholder: Node2D = $HandLPlaceholder
@onready var right_hand_placeholder: Node2D = $HandRPlaceholder

func _ready() -> void:
	update_animation_parameters(starting_direction)
	
	if left_held_item != null:
		left_held_item.reparent(left_hand_placeholder)

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

func _on_pickup(event: InputEvent, item: Item) -> void:
	#This code can only be ran if an item on the ground has been clicked
	#  >on to be picked up.
	# Called from a signal in Item
	if event.is_action_pressed("left_hand_action"):
		if left_held_item == null:
			item.reparent(left_hand_placeholder)
			item.take_in_hand()
	elif event.is_action_pressed("right_hand_action"):
		if right_held_item == null:
			item.reparent(right_hand_placeholder)
			item.take_in_hand()
	#only connect to one item's pickup signal at a time
	disconnect("pick_up", self.pickup)

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
