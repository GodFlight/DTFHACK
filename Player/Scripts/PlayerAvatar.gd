extends KinematicBody2D

onready var velocity = Vector2.ZERO
onready var tmp_velocity = velocity
const base_speed = 400
var speed = 0
var one_tap = true
var is_controlled = false
var is_dead = false

func _ready():
	$AreaAttack.connect("area_entered", self, "area_collision")
	$AreaAttack.connect("body_entered", self, "collision")
	$AnimationPlayer.play("Idle")
	speed = base_speed
	pass

remotesync func change_sprite(num):
	is_dead = false
	$AnimationPlayer.play("Idle")
	velocity = Vector2.ZERO
	rotation_degrees = 0
	match num:
		1:
			$"Sprite".texture = preload("res://Assets/Characters/purple.png")
		2:
			$"Sprite".texture = preload("res://Assets/Characters/blue.png")
		3:
			$"Sprite".texture = preload("res://Assets/Characters/red.png")
		_:
			$"Sprite".texture = preload("res://Assets/Characters/yellow.png")

func _process(delta):
	if not is_controlled:
		return
	var input = Vector2()
	if Input.is_action_just_pressed("player_down"):
		input.y = 1
	elif Input.is_action_just_pressed("player_up"):
		input.y = -1
	elif Input.is_action_just_pressed("player_right"):
		input.x = 1
	elif Input.is_action_just_pressed("player_left"):
		input.x = -1
	if velocity == Vector2.ZERO and input != Vector2.ZERO:
		var body_angle = rotation_degrees + 90
		var input_angle = rad2deg(input.angle())
		if round(body_angle) == round(input_angle): # Jump down fix
			return
		rpc("change_velocity", input)
		rpc("sync_pos", position)
		rpc("_change_body_direction")

func _physics_process(delta : float):
	var move = move_and_slide(velocity * speed)
	if velocity != Vector2.ZERO and move == Vector2.ZERO:
		var col = get_slide_collision(0)
		if tmp_velocity != Vector2.ZERO:
			_turn_around()
		change_velocity(Vector2.ZERO)

remotesync func change_velocity(input: Vector2):
	velocity = input
	tmp_velocity = velocity
	if velocity == Vector2.ZERO:
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Fly")

func _possible_to_move(delta : float, input : Vector2):
	var check_move = test_move(transform, input * delta)
	if !check_move:
		return true
	return false

remote func sync_pos(pos):
	position = pos

remotesync func _change_body_direction():
	if (velocity.y == 1):
		set_rotation_degrees(180)
	elif(velocity.y == -1):
		set_rotation_degrees(0)
	elif (velocity.y == 0):
		set_rotation_degrees(velocity.x * 90)

func _turn_around():
	set_rotation_degrees(rotation_degrees + 180)


func area_collision(area: Area2D):
	var mb_player = area.get_node("..")
	if mb_player != self and mb_player.has_method("damage") and not mb_player.is_dead:
		rpc("change_velocity", -velocity)
		if velocity != Vector2.ZERO:
			rpc("_change_body_direction")
	pass


func collision(body: PhysicsBody2D):
	if body and body != self and body.has_method("damage") and not body.is_dead:
		body.damage(999)
	pass


func damage(amount: int):
	if get_tree().get_network_unique_id() == 1:
		is_dead = true
		Lobby.add_score(int($"..".name))
		Respawn.call_rpc(int($"..".name))

func slow(percent : int):
	speed = base_speed - (base_speed / 100 * percent)
	print("Slowing down by ", percent, " %")
