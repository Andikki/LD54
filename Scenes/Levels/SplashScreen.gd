extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y	
	var scaleW = viewportWidth / texture.get_size().x
	var scaleH = viewportHeight / texture.get_size().y	
	set_scale(Vector2(scaleW,scaleH))
	set_position(Vector2(viewportWidth/2, viewportHeight/2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
