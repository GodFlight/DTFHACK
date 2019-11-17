extends Area2D

export(int) var laser_cooldown = 15
export(float) var laser_duration = 0
export(Color) var laser_color = "#ff0000"

var is_active : bool = true

var laser_line_resource = preload("res://Enviroment/LaserLine.tscn")

func _ready() -> void:
	$AnimationPlayer.play("default")
	create_lasers()
	pass


func create_lasers():
	var add_laser_flag : bool = true
	var laser
	
	for node in $Emitters.get_children():
		if add_laser_flag:
			laser = laser_line_resource.instance()
			add_child(laser)
			create_laser_line(laser, node.position, 0)
			add_laser_flag = false
			continue
		
		laser.set_point_position(1, node.position)
		create_laser_collider(laser, laser.get_node("Area2D"))
		add_laser_flag = true


func create_laser_line(laser, pos : Vector2, laser_nbr : int):
	laser.set_point_position(laser_nbr, pos)
	laser.default_color = laser_color
	laser.width = 4
	laser.visible = false


func create_laser_collider(laser, laser_area : Area2D):
	laser.add_child(laser_area)
	laser_area.connect("body_entered", self, "deal_damage")
	laser_area.position.x = (laser.get_point_position(0).x + laser.get_point_position(1).x) / 2
	laser_area.position.y = (laser.get_point_position(0).y + laser.get_point_position(1).y) / 2
	if round(laser.get_point_position(0).x) - round(laser.get_point_position(1).x) == 0:
		laser_area.scale.y = abs(laser.get_point_position(0).y - laser.get_point_position(1).y) / 2
		laser_area.scale.x = laser.width
	else:
		laser_area.scale.x = abs(laser.get_point_position(0).x - laser.get_point_position(1).x) / 2
		laser_area.scale.y = laser.width


func _on_LaserButton_body_entered(body: PhysicsBody2D) -> void:
	if is_active:
		emit_laser()
		$Cooldown.start(laser_cooldown)
		$AnimationPlayer.stop()
		$ButtonSprite.frame = 0
		is_active = false
		

func emit_laser():
	show_lasers()
	yield(get_tree().create_timer(laser_duration), "timeout")
	hide_lasers()
	
	
func show_lasers():
	for node in get_children():
		if node is Line2D:
			node.visible = true
			node.get_node("Area2D").monitoring = true


func hide_lasers():
	for node in get_children():
		if node is Line2D:
			node.visible = false
			node.get_node("Area2D").monitoring = false
			
		
func _on_Cooldown_timeout() -> void:
	is_active = true
	$AnimationPlayer.play("default")


func deal_damage(body : PhysicsBody2D):
	if body and body.has_method("damage"):
		body.damage(42, 0)

