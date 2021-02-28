extends KinematicBody2D

var motion = Vector2()
var state = 0
#0 for nothing, 1=right, 2=left
	
func _physics_process(delta):
	
	if state == 0:
		pass
	elif state == 1:
		motion.x = 50
		motion.y = -20
	elif state == 2:
		motion.x = -50
		motion.y = -20

	move_and_slide(motion, Vector2(0, -1))


func _on_Timer_timeout():
	state = floor(rand_range(0,3))
	print(state)
	pass # Replace with function body.
