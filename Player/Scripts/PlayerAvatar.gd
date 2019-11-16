extends KinematicBody2D

onready var velocity = Vector2(0.0, 0.0)
var speed = 500
var one_tap = true

func _ready():
	$AreaTakeDamage.connect("area_entered", self, "_take_damage")
	$AreaAttack.connect("area_entered", self, "_attack")
	pass # Replace with function body.

func _process(delta):
	if one_tap == true:
		_check_input(delta)
	velocity = velocity.normalized()
	if (move_and_collide(velocity * speed * delta)):
		one_tap = true
		velocity = Vector2.ZERO

func _check_input(delta : float):
	if Input.is_action_just_pressed("player_right"):
		velocity.x = 1
		if ((_check_direction(delta))):
			one_tap = true
			return
	elif Input.is_action_just_pressed("player_left"):
		velocity.x = -1
		if ((_check_direction(delta))):
			one_tap = true
			return
	elif Input.is_action_just_pressed("player_up"):
		velocity.y = -1
		if ((_check_direction(delta))):
			one_tap = true
			return
	elif Input.is_action_just_pressed("player_down"):
		velocity.y = 1
		if ((_check_direction(delta))):
			one_tap = true
			return
	if (velocity != Vector2.ZERO):
		one_tap = false

func _check_direction(delta : float) -> bool :
	var check = test_move(transform, (velocity * delta))
	if (!check):
		return true
	return false

func _attack(body):
	if (body != self && body.has_method("_take_damage")):
		body.take_damage(body)
	pass

func _take_damage(body):
	if (body != self):
		print("check")
	pass


func _physics_process(delta):

	pass

func damage(amount : int):
	print("Taken ", amount, " damage!")
	

func slow(percent : int):
	print("Slowing down by ", percent, " %")
