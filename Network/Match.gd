extends Node

const ROUND_TIME = 150
var timer
var tick_timer

signal ticked

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
	print("boop")
	rpc("all_tick")


remotesync func all_tick():
	emit_signal("ticked")


func end_game():
	pass


func start_game():
	if get_tree().get_network_unique_id() == 1:
		timer.start(ROUND_TIME)
		tick_timer.start(1)