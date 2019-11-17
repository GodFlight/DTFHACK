extends Node

#const ROUND_TIME = 150
const ROUND_TIME = 12
var timer
var tick_timer

signal ticked
signal game_ended

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.connect("timeout", self, "end_game")
	add_child(timer)
	tick_timer = Timer.new()
	tick_timer.connect("timeout", self, "tick")
	add_child(tick_timer)
	pass


func tick():
	rpc("all_tick")


remotesync func all_tick():
	emit_signal("ticked")


func end_game():
	rpc("all_end")
	pass


remotesync func all_end():
	emit_signal("game_ended")


func start_game():
	if get_tree().get_network_unique_id() == 1:
		timer.start(ROUND_TIME)
		tick_timer.start(1)