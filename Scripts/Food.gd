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
	velocity.y = 80; 
	velocity.y += (delta * GRAVITY) / UNDERWATER
	

	var motion = velocity * delta
	
	var collision = move_and_collide(motion)
	if collision && collision.collider.name == "Outside":
		# Add a timer to this node
		var timer = Timer.new()
		self.add_child(timer)
	
		# Connect the timer to make it call "queue_free" after two seconds
		timer.connect("timeout", self, "queue_free")
		timer.set_wait_time(2)
		timer.start()
		
		#queue_free()
	#translate(motion)

func eaten():
	queue_free()


func _on_Food_ready():
	pass # Replace with function body.
