extends Node

var score_labels = {}
var time_label

func _ready():
	Lobby.connect("player_info_updated", self, "_refresh_score")
	Match.connect("ticked", self, "_refresh_time")
	Match.connect("game_ended", self, "_end_game")
	var ct = 0
	for pid in Lobby.player_info:
		var node = $"HBoxContainer".get_child(ct)
		if node.name == "Time Left":
			ct += 1
			node = $"HBoxContainer".get_child(ct)
		node.get_node("Name").text = Lobby.player_info[pid].name.substr(0, 7)
		node.get_node("Name").modulate = Lobby.player_info[pid].color
		node.get_node("Score").text = "%06d" % Lobby.player_info[pid].score
		node.show()
		score_labels[pid] = {
			"node": node.get_node("Score"),
			"name_node": node.get_node("Name")
		}
		ct += 1
	time_label = $"HBoxContainer/Time Left/Time"
	_refresh_score()

func _refresh_score():
	for pid in score_labels:
		score_labels[pid].node.text = "%06d" % Lobby.player_info[pid].score
		score_labels[pid].name_node.modulate = Lobby.player_info[pid].color

func _refresh_time(time_left):
	time_label.text = str(int(time_left) / 60) + ":" + "%02d" % (int(time_left) % 60)

func _change_sprite(sprite, type):
	match type:
		1:
			sprite.texture = preload("res://Assets/Characters/purple.png")
		2:
			sprite.texture = preload("res://Assets/Characters/blue.png")
		3:
			sprite.texture = preload("res://Assets/Characters/red.png")
		_:
			sprite.texture = preload("res://Assets/Characters/yellow.png")

func _end_game(win_id):
	var my_id = get_tree().get_network_unique_id()
	if my_id == 1:
		$"HBoxContainer".hide()
		$"Server End Screen".show()
		$"Server End Screen/HBoxContainer/VBoxContainer/Won".text = Lobby.player_info[win_id].name + " won!"
		$"Server End Screen/HBoxContainer/VBoxContainer/Top Score".text = "top score: " + "%06d" % Lobby.player_info[win_id].score
		$"Server End Screen/HBoxContainer/VBoxContainer/My Score".text = "my score: " + "%06d" % Lobby.player_info[my_id].score
		_change_sprite($"Server End Screen/Sprite", Lobby.player_info[win_id].type)
		$"Server End Screen/Sprite/AnimationPlayer".play("Idle")
	else:
		$"HBoxContainer".hide()
		$"Player End Screen".show()
		$"Player End Screen/HBoxContainer/VBoxContainer/Won".text = Lobby.player_info[win_id].name + " won!"
		$"Player End Screen/HBoxContainer/VBoxContainer/Top Score".text = "top score: " + "%06d" % Lobby.player_info[win_id].score
		$"Player End Screen/HBoxContainer/VBoxContainer/My Score".text = "my score: " + "%06d" % Lobby.player_info[my_id].score
		_change_sprite($"Player End Screen/Sprite", Lobby.player_info[win_id].type)
		$"Player End Screen/Sprite/AnimationPlayer".play("Idle")