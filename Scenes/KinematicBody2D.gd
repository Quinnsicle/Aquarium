extends KinematicBody2D

var motion = Vector2()
var state = 0
#0 for nothing, 1=right, 2=left

func _ready():
	var scene = load("res://Bubble.tscn")
	var player = scene.instance()
	add_child(player)
	
func _physics_process(delta):
	if state == 0:
		pass
	elif state == 1:
		motion.x = 100

	move_and_slide(motion, Vector2(0, -1))
