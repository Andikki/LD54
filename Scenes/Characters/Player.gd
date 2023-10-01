extends CharacterBody2D

@export var move_speed := 100.0
@export var starting_direction := Vector2.UP

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

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

func update_animation_parameters(move_direction: Vector2) -> void:
	if move_direction != Vector2.ZERO:
		animation_tree["parameters/Walk/blend_position"] = move_direction
		animation_tree["parameters/Idle/blend_position"] = move_direction
	
	if velocity == Vector2.ZERO:
		animation_state_machine.travel("Idle")
	else:
		animation_state_machine.travel("Walk")
		
	
