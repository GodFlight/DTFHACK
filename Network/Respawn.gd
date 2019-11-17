extends Node

var spawn_points = Array()
var current_point = 0

func init():
	randomize()
	spawn_points = Array()
	var points = get_node("/root/Game/Map/Spawn Points")
	for p in points.get_children():
		spawn_points.append(p.position)
		p.queue_free()
	current_point = randi() % len(spawn_points)

func call_rpc(pid):
	if get_tree().get_network_unique_id() != 1:
		rpc_id(1, "player", pid)
	else:
		player(pid)

remote func player(pid):
	var player_node = get_node("/root/Game/" + str(pid))
	var avatar = player_node.get_node("PlayerAvatar")
	var pos = spawn_points[current_point]
	avatar.sync_pos(pos)
	avatar.rpc("sync_pos", pos)
	avatar.rpc("change_sprite", Lobby.player_info[pid].type)
	current_point += 1
	if current_point == len(spawn_points):
		current_point = 0
	pass
