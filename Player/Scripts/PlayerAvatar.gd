extends KinematicBody2D

onready var velocity = Vector2.ZERO
const speed = 500
var one_tap = true

func _ready():
	$AreaTakeDamage.connect("area_entered", self, "damage")
	$AreaAttack.connect("area_entered", self, "attack")
	pass

func _process(delta):
	if one_tap == true:
		_check_input(delta)
		_change_body_direction()		
	if (move_and_collide(velocity * speed * delta)):
		one_tap = true
		velocity = Vector2.ZERO

func _change_body_direction():
	if (velocity.y == 1):
		set_rotation_degrees(180)
	elif(velocity.y == -1):
		set_rotation_degrees(0)
	elif (velocity.y == 0):
		set_rotation_degrees(velocity.x * 90)

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

func attack(body):
	if (body != self && body.has_method("damage")):
		body.damage(body)
	pass
	if (body != self):
		print("check")
	pass

func damage(amount : int):
	print("Taken ", amount, " damage!")

func _physics_process(delta):

	pass

func slow(percent : int):
	print("Slowing down by ", percent, " %")
