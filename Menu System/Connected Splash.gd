extends Control

onready var name_label = $"HBoxContainer/VBoxContainer/Player Name"
onready var back_button = $"HBoxContainer/VBoxContainer/Back"

func _ready():
	back_button.connect("pressed", self, "_back")

func _back():
	$"..".change_screen_to("Main")