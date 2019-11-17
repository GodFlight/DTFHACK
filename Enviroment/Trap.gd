extends Area2D

var trap_duration : float

var is_active : bool = false

func _ready() -> void:
	trap_duration = $AnimationPlayer.get_animation("default").length / $AnimationPlayer.playback_speed
	pass


func _on_Trap_body_entered(body: PhysicsBody2D) -> void:
	if not is_active:
		$Timer.start(trap_duration)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("default")
		is_active = true
		return
	if body.has_method("damage"):
		body.damage(42)


func _on_Timer_timeout() -> void:
	$AnimationPlayer.stop()
	is_active = false
