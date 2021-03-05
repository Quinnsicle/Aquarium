extends KinematicBody2D

enum states {ROAM, HUNGRY, DEAD}
var state = states.ROAM

var anim_state
var speed = 250
var in_action = false

# For roaming
var move_target = Vector2()


# For eating
var food = null

var velocity
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = 100
	self.position.y = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!in_action):
		choose_action()
	# Changing the x scale flips the sprite and its attack area.

	if velocity.x > 0:
		$Sprite.scale.x = 1
	elif velocity.x < 0:
		$Sprite.scale.x = -1

	#velocity = move_and_slide(velocity * delta)

func _physics_process(delta):
	
#	if state == states.HUNGRY:
#		print("process hunger")
#		velocity = velocity.move_toward(move_target, speed)
#		var collision = move_and_collide(velocity)
#		if collision:
#			print(collision.collider.name)
#		if collision.collider.name == "Food":
#			$Food.eaten()
			
	
	if (self.get_position() - move_target).length() > 5:
		# not at target destination, lerp there
		t += delta / speed
		position = position.linear_interpolate(move_target, t)
	else:
		# at target destination, choose another action
		choose_action()


func choose_action():
	print("choose action")
	velocity = Vector2.ZERO

	# Depending on the current state, choose a movement target.
	match state:
		states.DEAD:
			print("DEAD")
			set_physics_process(false)

	# Move around the tank
		states.ROAM:
			print("ROAM")
			speed = 250
			in_action = true
			# set roam to random point in aquarium
			move_target = get_rand_target()
			t = 0
			#tween.interpolate_property(self, "position", self.position, move_target, 8, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)


	# Franticly look for food
		states.HUNGRY:
			print("HUNGRY")
			speed = 500
			if($Food._on_Food_ready):
				move_target = $Food.position
			else:
				move_target = get_rand_target()

func get_rand_target():
	var target = Vector2()
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var screen_size = get_viewport().get_visible_rect().size
	target.x = rand.randf_range(0, screen_size.x)
	target.y = rand.randf_range(0, screen_size.y)
	print("move target (", target.x, ", ", target.y, ")")
	return target

func _on_Timer_timeout():
	# Enter hungry state
	print("fish is hungry!")
	state = states.HUNGRY
