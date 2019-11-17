extends KinematicBody2D

onready var velocity = Vector2.ZERO
onready var tmp_velocity = velocity
const speed = 400
var one_tap = true
var is_controlled = false

func _ready():
	$AreaAttack.connect("area_entered", self, "area_collision")
	$AreaAttack.connect("body_entered", self, "collision")
	$AnimationPlayer.play("Idle")
#	$AreaTakeDamage.connect("area_entered", self, "damage")
	pass

remotesync func respawn(num):
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
	if Input.is_action_just_pressed("player_up"):
		input.y = -1
	if Input.is_action_just_pressed("player_right"):
		input.x = 1
	if Input.is_action_just_pressed("player_left"):
		input.x = -1
#	if _possible_to_move(delta, input):
#		return
#	print(velocity)
	if velocity == Vector2.ZERO and input != Vector2.ZERO:
		rpc("change_velocity", input)
		rpc("sync_pos", position)
		rpc("_change_body_direction")

func _physics_process(delta : float):
	var col = move_and_collide(velocity * delta * speed)
	if col:
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
	if mb_player != self and mb_player.has_method("damage"):
		print("Player[", $"..".name, "] booped Player[", mb_player.get_node("..").name, "]")
#		print("Id[", get_tree().get_network_unique_id(),"]	Player[", $"..".name, "] booped Player[", mb_player.get_node("..").name, "]")
#		mb_player.rpc("change_velocity", -mb_player.velocity)
		rpc("change_velocity", -velocity)
		if velocity != Vector2.ZERO:
			rpc("_change_body_direction")
	pass


func collision(body: PhysicsBody2D):
	if body and body != self and body.has_method("damage"):
		print("Player[", $"..".name, "] attacked Player[", body.get_node("..").name, "]")
#		var id = get_tree().get_network_unique_id()
#		print("Id[Player[", id, "] attacked Player[", body.get_node("..").name, "]")
		body.damage(999)
	pass


#func attack(body):
#	print("pepega 1")
#	if body != self and body.get_node("..").has_method("damage"):
#		if body.name == "AreaAttack":
##			print(velocity)
#			velocity = -velocity
#			print("Check")
##			print(velocity)
#			return
#		body.get_node("..").damage(1)
#
remotesync func damage(amount : int):
	Respawn.player(int($"..".name))
#	print("PEPEGUS MAXIMUS")
#	queue_free()
#	print("Taken ", amount, " damage!")

func slow(percent : int):
	print("Slowing down by ", percent, " %")
