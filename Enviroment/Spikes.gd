extends Area2D

var spikes_duration : float
var is_active : bool = true

var current_body : PhysicsBody2D = null

func _ready() -> void:
	spikes_duration = $AnimationPlayer.get_animation("default").length / $AnimationPlayer.playback_speed
	$Timer.start(spikes_duration)
	pass
	

func _on_Spikes_body_entered(body: PhysicsBody2D) -> void:
	current_body = body


func _physics_process(delta: float) -> void:
	if is_active and current_body:
		deal_damage(current_body)
	pass


func deal_damage(body : PhysicsBody2D):
	if is_active and body.has_method("damage"):
		body.damage(42, 0)


func _on_Timer_timeout() -> void:
	if is_active:
		is_active = false
		$AnimationPlayer.stop()
		$Sprite.frame = 0
	else:
		$AnimationPlayer.play("default")
		is_active = true
		



func _on_Spikes_body_exited(body: PhysicsBody2D) -> void:
	current_body = null
