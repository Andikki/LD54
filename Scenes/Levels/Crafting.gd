extends CanvasLayer

@onready var craft_fire: Button = $CraftFire
@onready var craft_rope: Button = $CraftRope
@onready var craft_raft: Button = $CraftRaft

var cur_ingredients: Array[Item]

signal please_place_rope()
signal please_place_raft()

# Called when the node enters the scene tree for the first time.
func _ready():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y	
	craft_fire.connect("pressed", try_craft_fire)
	craft_rope.connect("pressed", try_craft_rope)
	craft_raft.connect("pressed", try_craft_raft)
	craft_fire.set_position(Vector2(0.05 * viewportWidth/2, 0.05 * viewportHeight/2))
	craft_rope.set_position(Vector2(0.05 * viewportWidth/2, 0.25 * viewportHeight/2))
	craft_raft.set_position(Vector2(0.05 * viewportWidth/2, 0.45 * viewportHeight/2))
	disable_all_buttons()

func _on_ingredients_for_crafting_updated(ingredients: Array[Item]) -> void:
	cur_ingredients = ingredients
	disable_all_buttons()
	var grass_count = 0
	var log_count = 0
	var rope_count = 0
	for ingredient in cur_ingredients:
		var ingredient_type = ingredient.item_name
		if ingredient_type == "Grass":
			grass_count += 1
		elif ingredient.item_name == "Log":
			log_count += 1
		elif ingredient.item_name == "Rope":
			rope_count += 1
	if log_count >= 2: #fire = 2 wood			
		craft_fire.text = "Craft Fire"
		craft_fire.DRAW_NORMAL			
	if grass_count >= 3: #rope = 3 grass
		craft_rope.text = "Craft Rope"
		craft_rope.DRAW_NORMAL			
	if rope_count >= 1 and log_count >= 3:
		craft_raft.text = "Craft Raft"
		craft_raft.DRAW_NORMAL			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func disable_all_buttons() -> void:
	craft_fire.DRAW_DISABLED
	craft_fire.text = "Cannot craft Fire"	
	craft_rope.DRAW_DISABLED
	craft_rope.text = "Cannot craft Rope"	
	craft_raft.DRAW_DISABLED
	craft_raft.text = "Cannot craft Raft"	
	
func try_craft_fire():
	pass
	
func try_craft_rope():
	var grass_required = 3
	for ingredient in cur_ingredients:
		var ingredient_type = ingredient.item_name
		if ingredient_type == "Grass" and grass_required > 0:
			grass_required -= 1
			ingredient.queue_free()
	emit_signal("please_place_rope")
	
func try_craft_raft():
	var logs_required = 3
	var rope_required = 1
	for ingredient in cur_ingredients:
		var ingredient_type = ingredient.item_name
		if ingredient_type == "Log":
			logs_required -= 1
			ingredient.queue_free()
		if ingredient_type == "Rope":
			rope_required -= 1
			ingredient.queue_free()
	emit_signal("please_place_raft")
	
