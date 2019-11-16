extends Area2D

var another_portal_pos : Vector2

func _ready() -> void:
	connect("body_entered", self, "_teleport")
	another_portal_pos = get_another_teleport_pos()
	$AnimationPlayer.play("default")


func get_another_teleport_pos():
	var nodes = get_parent().get_children()
	for node in nodes:
		if node != self:
			return node.global_position
						

func _teleport(body : PhysicsBody2D):
#	if body.is_type("Player") todo ?
	if !get_parent().timer_started:
		body.global_position = another_portal_pos
		get_parent().start_timer()


