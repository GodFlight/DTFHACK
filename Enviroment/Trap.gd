extends Area2D

var trap_duration : float
export(float) var time_before_hit = 0.2

var is_active : bool = false

var current_body : PhysicsBody2D = null

var flag = false

func _ready() -> void:
	trap_duration = $AnimationPlayer.get_animation("default").length / $AnimationPlayer.playback_speed
	pass


func _on_Trap_body_entered(body: PhysicsBody2D) -> void:
	if not is_active:
		$Timer.start(trap_duration)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("default")
		current_body = body
		yield(get_tree().create_timer(time_before_hit), "timeout")
		is_active = true
	else:
		deal_damage(body)
	
	
func _physics_process(delta: float) -> void:
	if is_active and current_body:
		deal_damage(current_body)
	if flag:
		flag = false
	pass
			
func deal_damage(body : PhysicsBody2D):
	if body and body.has_method("damage"):
		body.damage(42, 0)


func _on_Trap_body_exited(body: PhysicsBody2D) -> void:
	current_body = null
	flag = true


func _on_Timer_timeout() -> void:
	is_active = false
	
