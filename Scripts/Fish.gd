extends KinematicBody2D

enum states {ROAM, HUNGRY, DEAD}
var state = states.ROAM

# fish speeds
export (int) var roam_speed : int = 200
export (int) var hungry_speed : int = 270
export (int) var death_speed : int = 1
var speed = roam_speed
var in_action = false

# For roaming
var move_target = Vector2()
var swim = Vector2()
var swim_timer = Timer.new()
var rand_swim = RandomNumberGenerator.new()
var target_direction
var wait = false
var wait_timer

# For eating
var food_collision
var food

# For death
onready var death_timer = get_node("Death Timer")

var velocity
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = 100
	self.position.y = 100
	
	self.add_child(swim_timer)
	swim_timer.set_wait_time(1.0)
	swim_timer.set_one_shot(true)
	choose_action()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	# Changing the x scale flips the sprite and its attack area.
	#if current position.x < move_target.x, right
	# elif current position.x > move_target.x, left
	if position.x > move_target.x:
		$Sprite.set_flip_h(false) #right
	elif position.x < move_target.x:
		$Sprite.set_flip_h(true) #left


#		velocity = velocity.move_toward(move_target, speed)
#		var collision = move_and_collide(velocity)
#		if collision:
#			print(collision.collider.name)
#		if collision.collider.name == "Food":
#			$Food.eaten()
	if food && food.collision:
		food_collision = food.collision.get_collider()
	
	

	if (state == states.DEAD):
		if(self.get_position().y <= 0):
			self.queue_free()
		position = position.move_toward(move_target, speed)
	elif (self.get_position() - move_target).length() < 5 || food_collision == self:
		if(!wait):
			at_target()
			
	else:
		# not at target destination
		var distance_to_target = self.get_position().distance_to(move_target);
		if (distance_to_target < 100):
			swim = Vector2(0, 0)
		elif (swim_timer.time_left <= 0 || swim_timer.is_stopped()): #and distance is < number
			rand_swim.randomize()
			#if swim direction is vertical swim.x, else swim.y
			#if target_direction 
			swim.x = rand_swim.randf_range(-80, 80) #maybe change to direction instead of points?
			swim.y = rand_swim.randf_range(-80, 80)
			swim_timer.start()
		
		position = position.move_toward(move_target + swim, speed/100)
		 #old movement
		#position = position.linear_interpolate(move_target, t)
		if state == states.HUNGRY:
			find_food()

func at_target():
	print("at target!")
	if(state == states.HUNGRY && food):
		death_timer.stop()
		food.eaten()
		food_collision = null
		state = states.ROAM
	else:
		# wait
		wait = true
		wait_timer = yield(get_tree().create_timer(0.2), "timeout")
		wait = false
	choose_action()

func choose_action():
	print("choose action")
	velocity = Vector2.ZERO

	# Depending on the current state, choose a movement target.
	match state:
		states.DEAD:
			print("DEAD")
			speed = death_speed
			move_target.x = self.get_position().x
			move_target.y = 0
			$Sprite.set_modulate(Color(.25, 1, .5, 1))
			$Sprite.set_flip_v(true)

		# Move around the tank
		states.ROAM:
			# move in a random direction, semi frequently
			print("ROAM")
			var percent = randf()
			if (percent > 0.7):
				# move in random direction
				speed = roam_speed
				in_action = true
				move_target = get_rand_target()
				t = 0
			elif (percent < .3):
				# move in same direction
				pass
			else:
				# stay
				speed = roam_speed
				in_action = true
				move_target = position;
				t = 0

		# Franticly look for food
		states.HUNGRY:
			print("HUNGRY")
			if(wait):
				if(wait_timer):
					wait_timer.resume()
				wait = false
			speed = hungry_speed
			move_target = get_rand_target()
			t = 0
			print("start death timer")
			if(death_timer.is_stopped()):
				death_timer.start()
			find_food()
		_:
			state = states.ROAM

func find_food():
	if(get_parent().get_node("Food")):
		food = get_parent().get_node("Food")
	if(food):
		move_target = food.position

func get_rand_target():
	var target = Vector2()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var screen_size = get_viewport().get_visible_rect().size
	target.x = rand.randf_range(100, screen_size.x - 100)
	target.y = rand.randf_range(100, screen_size.y - 100)
	print("move target (", target.x, ", ", target.y, ")")
	target_direction = self.get_position().direction_to(target)
	print("direction: ", target_direction)
	return target

func _on_Timer_timeout():
	# Enter hungry state
	state = states.HUNGRY
	choose_action()


func _on_Death_Timer_timeout():
	# Enter Dead state
	state = states.DEAD
	choose_action()
