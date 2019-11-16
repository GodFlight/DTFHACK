extends KinematicBody2D

onready var velocity = Vector2(0.0, 0.0)
var is_on_collide = false
var check 
var speed = 500
var one_tap = true

func _ready():
	
	pass # Replace with function body.

func _process(delta):
	if one_tap == true:
		_check_input(delta)
	velocity = velocity.normalized()
	if (move_and_collide(velocity * speed * delta)):
		one_tap = true
		velocity = Vector2.ZERO

func _check_input(delta : float):
	if Input.is_action_just_pressed("right"):
		velocity.x = 1
		if ((_check_direction(delta))):
			one_tap = true
			return
	elif Input.is_action_just_pressed("left"):
		velocity.x = -1
		if ((_check_direction(delta))):
			one_tap = true
			return
	elif Input.is_action_just_pressed("up"):
		velocity.y = -1
		if ((_check_direction(delta))):
			one_tap = true
			return
	elif Input.is_action_just_pressed("down"):
		velocity.y = 1
		if ((_check_direction(delta))):
			one_tap = true
			return
	if (velocity != Vector2.ZERO):
		one_tap = false

func _check_direction(delta : float) -> bool :
	check = test_move(transform, (velocity * delta))
	if (!check):
		return true
	return false

func _physics_process(delta):

	pass
