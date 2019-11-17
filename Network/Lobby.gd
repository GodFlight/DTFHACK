extends Node

const SERVER_PORT = 1488
const MAX_PLAYERS = 4

var player_colors = {
	0: Color("#e6da29"), # Yellow
	1: Color("#7b53ad"), # Purple
	2: Color("#2d93dd"), # Blue
	3: Color("#d32734") # Red
}

var player_info = {}
var player_name
var player_color = Color.black
var player_scene = preload("res://Player/Character.tscn")
var current_map = preload("res://Maps/Map3.tscn")

signal player_sent_info
signal session_ended
signal player_info_updated

var a = Array()


func __debug_launch():
	create_server_press("1488", "FUCKMEINTHEASS")
	start_game()

func create_server_press(port_str, pl_name):
	a.shuffle()	
	player_name = pl_name
	player_color = player_colors[a[0]]
	player_info[1] = {
		"name": player_name,
		"color": player_color,
		"type": a[0],
		"score": 0
	}
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(int(port_str), MAX_PLAYERS)
	if (err != OK):
		emit_signal("session_ended")
		end_session()
		return
	get_tree().set_network_peer(peer)


func connect_to_server_press(address_str, port_str, pl_name):
	player_name = pl_name
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(address_str, int(port_str))
	if (err != OK):
		emit_signal("session_ended")
		end_session()
		return
	get_tree().set_network_peer(peer)

func end_session():
	player_info = {}
	var peer = get_tree().get_network_peer()
	if peer != null:
		peer.close_connection()
		get_tree().set_network_peer(null)

func start_game():
	var pid = get_tree().get_network_unique_id()
	if pid == 1:
		rpc("_start")

remotesync func _start():
	_load_level()
	_load_my_player()
	_load_other_players()
	if get_tree().get_network_unique_id() == 1:
		Respawn.init()
		for pid in player_info:
			Respawn.player(pid)
		Match.start_game()
	emit_signal("player_info_updated")


func _load_level():
	if get_node("/root/Control") != null:
		get_node("/root/Control").queue_free()
	var node = current_map.instance()
	get_node("/root/").add_child(node)
	node.set_name("Game")


func _load_my_player():
	var my_pid = get_tree().get_network_unique_id()
	var my_node = player_scene.instance()
	my_node.set_name(str(my_pid))
	my_node.set_network_master(my_pid)
	my_node.get_node("PlayerAvatar").is_controlled = true
	get_node("/root/Game/").add_child(my_node)


func _load_other_players():
	var my_pid = get_tree().get_network_unique_id()
	for pid in player_info:
		if pid == my_pid:
			continue
		var player_node = player_scene.instance()
		player_node.set_name(str(pid))
		player_node.set_network_master(pid)
		get_node("/root/Game").add_child(player_node)


func reset_score():
	for pid in player_info:
		player_info[pid].score = 0
	rpc("sync_pinfo", player_info)


remote func sync_pinfo(pinfo):
	player_info = pinfo
	emit_signal("player_info_updated")


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	randomize()
	a.push_back(0)
	a.push_back(1)
	a.push_back(2)
	a.push_back(3)


# Called on server and every client
func _player_connected(id):
	rpc_id(id, "register_player", player_name)


# Called on server and every client
func _player_disconnected(id):
	player_info.erase(id)
	emit_signal("player_sent_info")


# Only called on client
func _connected_ok():
	pass


# Only called on client
func _server_disconnected():
	emit_signal("session_ended")
	end_session()
	pass


# Only called on client
func _connected_fail():
	emit_signal("session_ended")
	end_session()
	pass


remote func request_color(peer_id):
	var my_id = get_tree().get_network_unique_id()
	if my_id == 1:
		player_info

func add_score(pid):
	rpc("_add_score", pid)

remotesync func _add_score(pid):
	player_info[pid].score += 1
	emit_signal("player_info_updated")

remote func register_player(pl_name):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = {
		"name": pl_name,
		"color": Color.black,
		"type": 0,
		"score": 0
	}
	var my_id = get_tree().get_network_unique_id()
	if my_id == 1:
		var pl_id = len(player_info) - 1
		player_info[id].color = player_colors[a[pl_id]]
		player_info[id].type = a[pl_id]
#		player_info[id].type = len(player_info) - 1
		
		rpc("sync_info", id, player_info[id])
		rpc("sync_pinfo", player_info)
	emit_signal("player_sent_info")

remotesync func sync_info(pid, info):
	player_info[pid] = info
	if get_tree().get_network_unique_id() == pid:
		player_color = player_info[pid].color
	emit_signal("player_sent_info")
