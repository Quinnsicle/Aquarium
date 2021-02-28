extends Node


func _ready():
	pass




func _process(delta):
	# Spawn food on left click
	if Input.is_action_just_pressed("spawn_food"):
		var scene = load("res://Scenes/Food.tscn")
		var food = scene.instance()
		# set food position to mouse position
		var mouse_position = get_viewport().get_mouse_position()
		food.position = mouse_position
		add_child(food)
