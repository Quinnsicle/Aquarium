extends KinematicBody2D

enum states {ROAM, HUNGRY, EAT, DEAD}
var state = states.ROAM

var anim_state
var speed = 25
var in_action = false

# For roaming
var move_target = Vector2()
var screen_size
var rand = RandomNumberGenerator.new()
onready var tween = get_node("Tween")

# For eating
var food = null

var velocity
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = 100
	self.position.y = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!in_action):
		choose_action()
	# Changing the x scale flips the sprite and its attack area.

	if velocity.x > 0:
		$Sprite.scale.x = 1
	elif velocity.x < 0:
		$Sprite.scale.x = -1

	#velocity = move_and_slide(velocity * delta)

func _physics_process(delta):
	if((self.get_position() - move_target).length() > 0.2):
		t += delta / speed
		print(position)
		position = position.linear_interpolate(move_target, t)
		#self.move_and_slide(move_target * speed * delta)

func choose_action():
	print("choose action")
	velocity = Vector2.ZERO

	# Depending on the current state, choose a movement target.

	var target
	match state:
		states.DEAD:
			print("DEAD")
			set_physics_process(false)

	# Move around the tank

		states.ROAM:
			print("ROAM")
			in_action = true
			# set roam to random point in aquarium
			rand.randomize()
			screen_size = get_viewport().get_visible_rect().size
			move_target.x = rand.randf_range(0, screen_size.x)
			move_target.y = rand.randf_range(0, screen_size.y)
			print("roam to (", move_target.x, move_target.y, ")")
			velocity = velocity.move_toward(move_target, speed)
			print(velocity)
			#tween.interpolate_property(self, "position", self.position, move_target, 8, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)


	# Franticly look for food

		states.HUNGRY:
			print("HUNGRY")
			target = food.position
			velocity = (target - position).normalized() * speed

	# If food is found, move towards it and eat

		states.EAT:
			print("EAT")
			target = food.position
			if target.x > position.x:
				$Sprite.scale.x = 1
			elif target.x < position.x:
				$Sprite.scale.x = -1
			anim_state.travel("attack")









