extends Node2D

export(float) var teleport_cooldown = 2
export(float) var delay_before_teleport = 0

var timer_started : bool = false

func _ready() -> void:
	pass
	

func start_timer():
	$Delay.start(teleport_cooldown)
	timer_started = true
	

func _on_Delay_timeout() -> void:
	timer_started = false

	
