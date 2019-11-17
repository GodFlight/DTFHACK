extends Node

const ROUND_TIME = 150
#const ROUND_TIME = 12
var timer
var tick_timer
var in_game = false

signal ticked(time_left)
signal game_ended(win_id)

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
	rpc("all_tick", timer.time_left)


remotesync func all_tick(time_left):
	emit_signal("ticked", time_left)


func _process(delta):
	if in_game and get_tree().get_network_unique_id() == 1 and timer.time_left == 0:
		if Input.is_key_pressed(KEY_R):
			pass
		elif Input.is_key_pressed(KEY_N):
			in_game = false
			clean_map()
			rpc("clean_map")
			Lobby.reset_score()
			Lobby.start_game()
			pass
		elif Input.is_key_pressed(KEY_B):
			in_game = false
			Lobby.end_session()
			get_node("/root/Game").queue_free()
			var node = preload("res://Menu System/Menu_Scene.tscn").instance()
			get_node("/root").add_child(node)
			pass


remote func clean_map():
	get_node("/root/Game").name = "Game_Old"
	get_node("/root/Game_Old").queue_free()


func end_game():
	var win_id = 1
	for pid in Lobby.player_info:
		if Lobby.player_info[pid].score > Lobby.player_info[win_id].score:
			win_id = pid
	rpc("all_end", win_id)
	pass


remotesync func all_end(win_id):
	emit_signal("game_ended", win_id)
	get_node("/root/Game/Map").queue_free()
	for pid in Lobby.player_info:
		get_node("/root/Game/" + str(pid)).queue_free()


func start_game():
	if get_tree().get_network_unique_id() == 1:
		in_game = true
		timer.start(ROUND_TIME)
		tick_timer.start(1)