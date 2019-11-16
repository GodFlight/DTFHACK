extends Control

onready var name_label = $"HBoxContainer/VBoxContainer/Player Name"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	back_button.connect("pressed", self, "_back")
	Lobby.connect("session_ended", self, "_drop")

func _back():
	Lobby.end_session()
	$"..".change_screen_to("Main")

func _drop():
	$"..".change_screen_to("Main")