extends Area2D

export(int) var slow_percent = 50

var bodies_on_slow_area : int = 0

func _ready() -> void:
	$Sprite.frame = 0


func _on_SlowArea_body_entered(body: PhysicsBody2D) -> void:
	bodies_on_slow_area += 1
	if ($Sprite.frame == 0):
		$AnimationPlayer.play("default")
	if body.has_method("slow"):
		body.slow(slow_percent)


func _on_SlowArea_body_exited(body: PhysicsBody2D) -> void:
	bodies_on_slow_area -= 1
	if (bodies_on_slow_area == 0):
		$AnimationPlayer.stop()
		$Sprite.frame = 0
	if body.has_method("slow"):
		body.slow(0)
