extends Node2D

export(float) var teleport_cooldown = 2
export(float) var delay_before_teleport = 0

var players_list = {}

var timer_resource = preload("res://Enviroment/CustomTeleportTimer.tscn")

func _ready() -> void:
	pass
	

func start_timer(player_name : String):
	var timer_node = find_timer(player_name)
	timer_node.start(teleport_cooldown)
	

func find_timer(player_name : String):
	for timer in get_children():
		if timer is Timer and timer.player_name == player_name:
			return timer
	var new_timer = timer_resource.instance()
	add_child(new_timer)
	new_timer.init(player_name)
#	new_timer.connect("timeout", self, "_on_Delay_timeout")
	return new_timer
		
		
func stop_timer(player_name : String):
	var timer = find_timer(player_name)
	timer.stop()
	

func teleport_on_cooldown(player_name : String) -> bool:
	var timer = find_timer(player_name)
#	print("time left: ", timer.get_time_left())
	if timer.get_time_left() <= 0:
		return false
	return true


#func _on_Delay_timeout() -> void: #todo pass string
#	print("TIMEOUT")

	
