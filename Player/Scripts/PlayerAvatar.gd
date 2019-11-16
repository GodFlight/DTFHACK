extends KinematicBody2D

onready var velocity = Vector2.ZERO
const speed = 500
var one_tap = true
var is_controlled = false

func _ready():
	$AreaTakeDamage.connect("area_entered", self, "damage")
	$AreaAttack.connect("area_entered", self, "attack")
	pass

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
#	print(input)
#	if not _possible_to_move(input):
#		return
	if velocity == Vector2.ZERO and input != Vector2.ZERO:
		rpc("change_velocity", input)
		rpc("sync_pos", position)
		rpc("_change_body_direction")

func _physics_process(delta):
	var col = move_and_collide(velocity * delta * speed)
	if col:
		change_velocity(Vector2.ZERO)

remotesync func change_velocity(input: Vector2):
	velocity = input

func _possible_to_move(input):
	return true

remote func sync_pos(pos):
	position = pos

remotesync func _change_body_direction():
#	print(velocity)
	if (velocity.y == 1):
		set_rotation_degrees(180)
	elif(velocity.y == -1):
		set_rotation_degrees(0)
	elif (velocity.y == 0):
		set_rotation_degrees(velocity.x * 90)

func attack(body):
#	if (body.name == "AreaTakeDamage"):
#		print("ATTACK!!!!!")
#	print(body.name)
	if (body != self and body.get_node("..").has_method("damage")):
#		print("HAS METHOD: ", body)
		body.get_node("..").damage(1)
	pass

func damage(amount : int):
	print("TAKE DAMAGE")
	print("Taken ", amount, " damage!")

func slow(percent : int):
	print("Slowing down by ", percent, " %")
