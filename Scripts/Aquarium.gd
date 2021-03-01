extends Node


func _ready():
	pass




		
		# Spawn food on left click
	if Input.is_action_just_pressed("spawn_food"):
		var scene = load("res://Scenes/Food.tscn")
		var food = scene.instance()
		# set food position to mouse position
		var mouse_position = get_viewport().get_mouse_position()
		food.position = mouse_position
		add_child(food)
		

			
		
	
		
	


func _on_Timer_timeout(): 
	var rand = RandomNumberGenerator.new()
	var screen_size = get_viewport().get_visible_rect().size
	var bubble_scene = load("res://Scenes/Bubble.tscn")
	var bubble_spawn = bubble_scene.instance()
	rand.randomize()
	var x = rand.randf_range(0,screen_size.x)
	rand.randomize()
	var y = rand.randf_range(0, screen_size.y)
	bubble_spawn.position.y = y
	bubble_spawn.position.x = x
	add_child(bubble_spawn)
	pass # Replace with function body.
