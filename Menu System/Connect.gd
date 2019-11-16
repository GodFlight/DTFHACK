extends Control

onready var name_field = $"HBoxContainer/VBoxContainer/Player Name"
onready var ip_field = $"HBoxContainer/VBoxContainer/Server Address"
onready var port_field = $"HBoxContainer/VBoxContainer/Server Port"
onready var connect_button = $"HBoxContainer/VBoxContainer/Connect"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	connect_button.connect("pressed", self, "_connect")
	back_button.connect("pressed", self, "_back")

func _connect():
	Lobby.connect_to_server_press(ip_field.text, port_field.text, name_field.text)
	$"..".change_screen_to("Connected")

func _back():
	$"..".change_screen_to("Main")