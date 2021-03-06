extends KinematicBody2D

var motion = Vector2()
var state = 0
#0 for nothing, 1=right, 2=left

### use prefix delta with underscore if delta is never used (_delta)
### this is causing a warning in the debugger
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

	### you can set move_and_slide to a variable such as (collision = move_and_slide) 
	### then you can use that collision to pop the bubble or have the bubble bounce
	### off the surface such as the wall.
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



func _on_Timer_timeout():
	state = floor(rand_range(0,3))
	#print(state)
	pass # Replace with function body.
