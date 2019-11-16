extends KinematicBody2D

onready var velocity = Vector2(0.0, 0.0)

func _ready():
	
	pass # Replace with function body.

func _process(delta):
	if (move_and_collide(velocity * delta)):
		velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		velocity.x += 1
	elif Input.is_action_pressed("left"):
		velocity.x -= 1
	elif Input.is_action_pressed("up"):
		velocity.y -= 1
	elif Input.is_action_pressed("down"):
		velocity.y += 1
	velocity *= 1.5

func _physics_process(delta):
		
	pass
