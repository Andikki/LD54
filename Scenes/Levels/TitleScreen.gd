extends MarginContainer

@onready var title_screen_bg: TextureRect = $TitleScreenBG

# Called when the node enters the scene tree for the first time.
func _ready():
	var texture_bg : Texture2D = load("res://Assets/Sprites/PlaceHolderGround.png")
	title_screen_bg.set_texture(texture_bg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
