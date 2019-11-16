extends Area2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_SlowArea_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("slow"):
		body.slow(50)
#		$AnimationPlayer.play("default")
