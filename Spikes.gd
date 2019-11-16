extends Area2D

func _ready() -> void:
	connect("body_entered", self, "_on_Spikes_body_entered")
	pass


func _on_Spikes_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("damage"):
		body.damage(21)
