extends KinematicBody2D

onready var velocity = Vector2(0.0, 0.0)

func _ready():
	
	pass # Replace with function body.

func _process(delta):
	if (move_and_collide(velocity * delta)):
		velocity = Vector2.ZERO
	if Input.is_action_pressed("player_right"):
		velocity.x += 1
	if Input.is_action_pressed("player_left"):
		velocity.x -= 1
	if Input.is_action_pressed("player_up"):
		velocity.y -= 1
	if Input.is_action_pressed("player_down"):
		velocity.y += 1
	velocity *= 1.5

func _physics_process(delta):
		
	pass
