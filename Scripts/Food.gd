extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


const GRAVITY = 200.0
const UNDERWATER = 10.0
var velocity = Vector2()

func _physics_process(delta):
	velocity.y += (delta * GRAVITY) / UNDERWATER

	var motion = velocity * delta
	move_and_collide(motion)
