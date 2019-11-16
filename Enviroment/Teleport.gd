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
#	if body.is_type("Player") todo ?
	player_on_teleport = true
	if !get_parent().timer_started:
		yield(get_tree().create_timer(delay_before_teleport), "timeout")
		if player_on_teleport:
			body.global_position = another_portal_pos
			get_parent().start_timer()
		
func _player_exited(body : PhysicsBody2D):
	player_on_teleport = false
	get_parent().timer_started = false
		
