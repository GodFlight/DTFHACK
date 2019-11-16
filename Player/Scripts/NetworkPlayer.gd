extends KinematicBody2D

var velocity: Vector2 = Vector2()
var is_controlled = false

func _process(delta):
	if not is_controlled:
		return
	var input = Vector2()
	if Input.is_action_just_pressed("player_down"):
		input.y = 1
	if Input.is_action_just_pressed("player_up"):
		input.y = -1
	if Input.is_action_just_pressed("player_right"):
		input.x = 1
	if Input.is_action_just_pressed("player_left"):
		input.x = -1
	if not possible_to_move(input):
		return
	if input != Vector2.ZERO:
		rpc("change_velocity", input)
		rpc("sync_pos", position)

func _physics_process(delta):
	var col = move_and_collide(velocity * delta * 500)
	if col:
		change_velocity(Vector2.ZERO)

func possible_to_move(input):
	return true

remote func sync_pos(pos):
	position = pos

remotesync func change_velocity(input: Vector2):
	velocity = input