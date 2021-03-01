extends KinematicBody2D

var motion = Vector2()
var state = 0
#0 for nothing, 1=right, 2=left
	
func _physics_process(delta):
	motion.y = -20
	
	if state == 0:
		pass
	elif state == 1:
		motion.x = 50
		motion.y = -20
	elif state == 2:
		motion.x = -50
		motion.y = -20

	move_and_slide(motion, Vector2(0, -1))
		
	if is_on_ceiling():
		var timer = Timer.new()
		self.add_child(timer)
		$AnimatedSprite.play("pop")
		motion.y = 0
		motion.x = 0
		timer.connect("timeout", self, "queue_free")
		timer.set_wait_time(.1)
		timer.start()
		
	
	if is_on_ceiling():
		queue_free()


func _on_Timer_timeout():
	state = floor(rand_range(0,3))
	#print(state)
	pass # Replace with function body.
