extends Node

const SERVER_PORT = 1488
const MAX_PLAYERS = 4

var player_info = {}
var player_name

signal player_sent_info
signal session_ended

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
	print("Start game")


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

