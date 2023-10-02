extends CanvasLayer

@onready var craft_fire: Button = $CraftFire

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y	
	craft_fire.connect("pressed", try_craft_fire)
	craft_fire.set_position(Vector2(0.05 * viewportWidth/2, 0.05 * viewportHeight/2))
	craft_fire.DRAW_DISABLED
	craft_fire.text = "Cannot craft Fire"
	#craft_fire.set_scale(Vector2(0.5,0.5))

func _on_ingredients_for_crafting_updated(ingredients: Array[Item]) -> void:
	craft_fire.DRAW_DISABLED
	craft_fire.text = "Cannot craft Fire"
	for ingredient in ingredients:
		var ingredient_type = ingredient.item_name
		if ingredient_type == "Grass":
			craft_fire.text = "Craft Fire"
			craft_fire.DRAW_NORMAL			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func try_craft_fire():
	var all_items = get_tree().get_nodes_in_group("items")
	var player = get_tree().get_first_node_in_group("player")
	for item in all_items:
		pass
