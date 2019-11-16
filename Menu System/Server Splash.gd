extends Control

onready var player_list = $"HBoxContainer/VBoxContainer/Player List"
onready var start_button = $"HBoxContainer/VBoxContainer/Start Match"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	start_button.connect("pressed", self, "_start")
	back_button.connect("pressed", self, "_back")

func _start():
	Lobby.start_game()

func _back():
	$"..".change_screen_to("Main")