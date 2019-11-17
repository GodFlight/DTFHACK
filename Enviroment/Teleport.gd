extends Area2D

var another_portal_pos : Vector2
var player_on_teleport : bool = false

var delay_before_teleport : float

func _ready() -> void:
	connect("body_entered", self, "_teleport")
	connect("body_exited", self, "_player_exited")
	another_portal_pos = get_another_teleport_pos()
	delay_before_teleport = get_parent().delay_before_teleport
	$AnimationPlayer.play("default")


func get_another_teleport_pos():
	var nodes = get_parent().get_children()
	for node in nodes:
		if node != self:
			return node.global_position
						

func _teleport(body : PhysicsBody2D):
	player_on_teleport = true
	if !get_parent().teleport_on_cooldown(body.get_parent().name):
		yield(get_tree().create_timer(delay_before_teleport), "timeout")
		if player_on_teleport:
			body.global_position = another_portal_pos
			get_parent().start_timer(body.get_parent().name)
	
		
func _player_exited(body : PhysicsBody2D):
	player_on_teleport = false
#	get_parent().stop_timer(body.get_parent().name) # можно раскомментить чтобы таймер перезагружался каждый раз при выходе перса из Area2D
		
