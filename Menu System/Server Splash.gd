extends Control

var player_label = preload("res://Menu System/Player_Label.tscn")
onready var player_list = $"HBoxContainer/VBoxContainer/Player List"
onready var start_button = $"HBoxContainer/VBoxContainer/Start Match"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	start_button.connect("pressed", self, "_start")
	back_button.connect("pressed", self, "_back")
	Lobby.connect("player_sent_info", self, "_refresh_list")
	Lobby.connect("session_ended", self, "_drop")
	_refresh_list()

func _start():
	Lobby.start_game()

func _back():
	Lobby.end_session()
	$"..".change_screen_to("Main")

func _drop():
	$"..".change_screen_to("Main")

func _refresh_list():
	for node in player_list.get_children():
		node.queue_free()
	for pid in Lobby.player_info:
		var node = player_label.instance()
		player_list.add_child(node)
		node.text = Lobby.player_info[pid]
	pass