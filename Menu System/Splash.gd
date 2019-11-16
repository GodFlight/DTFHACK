extends Control

func _process(delta):
	if Input.is_action_just_pressed("player_down"):
		_proceed()
	if Input.is_action_just_pressed("player_left"):
		_proceed()
	if Input.is_action_just_pressed("player_right"):
		_proceed()
	if Input.is_action_just_pressed("player_up"):
		_proceed()
	if Input.is_action_just_pressed("ui_accept"):
		_proceed()
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		_proceed()
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		_proceed()

func _proceed():
	$"..".change_screen_to("Main")
	pass