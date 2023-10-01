extends Node2D

@onready var main_menu_image: Sprite2D = $MainMenuImage
@onready var main_menu_music: AudioStreamPlayer = $MainMenuMusic
@onready var main_menu_button: Button = $MainMenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y	
	var scaleW = viewportWidth / main_menu_image.texture.get_size().x
	var scaleH = viewportHeight / main_menu_image.texture.get_size().y	
	main_menu_image.set_scale(Vector2(scaleW,scaleH))
	main_menu_image.set_position(Vector2(viewportWidth/2, viewportHeight/2))	
	main_menu_music.play(0.0)
	main_menu_button.connect("pressed", press_button)
	main_menu_button.set_position(Vector2(1.75 * viewportWidth/2, 1.75 * viewportHeight/2))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func press_button():
	queue_free()
