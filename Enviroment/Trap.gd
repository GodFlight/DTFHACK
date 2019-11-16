extends Area2D


func _ready() -> void:
	pass


func _on_Trap_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("damage"):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("default")
		body.damage(42)
