extends Node

const SERVER_PORT = 1488
const MAX_PLAYERS = 4

var player_info = {}
var player_name
var player_scene = preload("res://Player/Character.tscn")
var current_map = preload("res://Game.tscn")

signal player_sent_info
signal session_ended

func __debug_launch():
	create_server_press("1488", "FUCKMEINTHEASS")
	start_game()

func create_server_press(port_str, pl_name):
	print("Server creation!")
	print("Player: ", pl_name, "	Port: ", port_str)
	
	player_name = pl_name
	player_info[1] = player_name
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	if (err != OK):
		emit_signal("session_ended")
		end_session()
		return
	get_tree().set_network_peer(peer)


func connect_to_server_press(address_str, port_str, pl_name):
	print("Client creation!")
	print("Player: ", pl_name, "	Server: ", address_str, "	Port: ", port_str)
	
	player_name = pl_name
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_client(address_str, SERVER_PORT)
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
	print("Start game")

remotesync func _start():
	_load_level()
	_load_my_player()
	_load_other_players()


func _load_level():
	get_node("/root/Control").queue_free()
	var node = current_map.instance()
	get_node("/root/").add_child(node)
	node.set_name("Game")


func _load_my_player():
	var my_pid = get_tree().get_network_unique_id()
	var my_node = player_scene.instance()
	my_node.set_name(str(my_pid))
	my_node.set_network_master(my_pid)
	my_node.get_node("PlayerAvatar2").is_controlled = true
	get_node("/root/Game/").add_child(my_node)
	my_node.global_position = Vector2()
	if my_pid == 1:
		my_node.global_position = Vector2(32, 32)


func _load_other_players():
	var my_pid = get_tree().get_network_unique_id()
	for pid in player_info:
		if pid == my_pid:
			continue
		var player_node = player_scene.instance()
		player_node.set_name(str(pid))
		player_node.set_network_master(pid)
		get_node("/root/Game").add_child(player_node)
		player_node.global_position = Vector2()
		if pid == 1:
			player_node.global_position = Vector2(32, 32)


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


# Called on server and every client
func _player_connected(id):
	rpc_id(id, "register_player", player_name)


# Called on server and every client
func _player_disconnected(id):
	player_info.erase(id)
	emit_signal("player_sent_info")


# Only called on clients
func _connected_ok():
	pass


# Only called on clients
func _server_disconnected():
	emit_signal("session_ended")
	end_session()
	pass


# Only called on clients
func _connected_fail():
	emit_signal("session_ended")
	end_session()
	pass


remote func register_player(pl_name):
	var id = get_tree().get_rpc_sender_id()
	player_info[id] = pl_name
	emit_signal("player_sent_info")

