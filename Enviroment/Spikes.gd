extends Area2D

var spikes_duration : float
var is_active : bool = true

func _ready() -> void:
	spikes_duration = $AnimationPlayer.get_animation("default").length / $AnimationPlayer.playback_speed
	$Timer.start(spikes_duration)
	pass
	

func _on_Spikes_body_entered(body: PhysicsBody2D) -> void:
	if is_active and body.has_method("damage"):
		body.damage(21, 0)


func _on_Timer_timeout() -> void:
	if is_active:
		is_active = false
		$AnimationPlayer.stop()
		$Sprite.frame = 0
	else:
		$AnimationPlayer.play("default")
		is_active = true
