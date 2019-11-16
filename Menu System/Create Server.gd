extends Control

onready var name_field = $"HBoxContainer/VBoxContainer/Player Name"
onready var port_field = $"HBoxContainer/VBoxContainer/Server Port"
onready var create_button = $"HBoxContainer/VBoxContainer/Create"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	create_button.connect("pressed", self, "_create")
	back_button.connect("pressed", self, "_back")

func _create():
	Lobby.create_server_press(port_field.text, name_field.text)
	$"..".change_screen_to("Servered")
	pass

func _back():
	$"..".change_screen_to("Main")