extends Control

onready var name_label = $"HBoxContainer/VBoxContainer/Player Name"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	back_button.connect("pressed", self, "_back")
	Lobby.connect("session_ended", self, "_drop")
	Lobby.connect("player_sent_info", self, "_refresh")

func _refresh():
	var pid = get_tree().get_network_unique_id()
	name_label.text = Lobby.player_name
	name_label.modulate = Lobby.player_color
	print("pepega")

func _back():
	Lobby.end_session()
	$"..".change_screen_to("Main")

func _drop():
	$"..".change_screen_to("Main")