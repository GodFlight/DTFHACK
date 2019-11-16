extends Control

onready var server_button = $"HBoxContainer/VBoxContainer/New Server"
onready var connect_button = $"HBoxContainer/VBoxContainer/Connect"
onready var quit_button = $"HBoxContainer/VBoxContainer/Quit"

func _ready():
	server_button.connect("pressed", self, "_new_server")
	connect_button.connect("pressed", self, "_connect")
	quit_button.connect("pressed", self, "_quit")

func _new_server():
	$"..".change_screen_to("Server")

func _connect():
	$"..".change_screen_to("Connect")

func _quit():
	get_tree().quit()