extends Node

var score_labels = {}

func _ready():
	Lobby.connect("player_info_updated", self, "_refresh_score")
	var ct = 0
	for pid in Lobby.player_info:
		var node = $"HBoxContainer".get_child(ct)
		if node.name == "Time Left":
			ct += 1
			node = $"HBoxContainer".get_child(ct)
		node.get_node("Name").text = Lobby.player_info[pid].name
		node.get_node("Name").modulate = Lobby.player_info[pid].color
		node.get_node("Score").text = "%06d" % Lobby.player_info[pid].score
		node.show()
		score_labels[pid] = {
			"node": node.get_node("Score")
		}
		ct += 1

func _refresh_score():
	for pid in score_labels:
		score_labels[pid].node.text = "%06d" % Lobby.player_info[pid].score
