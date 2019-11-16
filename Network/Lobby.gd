extends Node

func create_server_press(port_str, player_name):
	print("Server creation!")
	print("Player: ", player_name, "	Port: ", port_str)

func connect_to_server_press(address_str, port_str, player_name):
	print("Client creation!")
	print("Player: ", player_name, "	Server: ", address_str, "	Port: ", port_str)

func start_game():
	print("Start game")