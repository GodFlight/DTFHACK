extends Area2D

export(int) var laser_cooldown = 15
export(float) var laser_duration = 0

var is_active : bool = true

func _ready() -> void:
	$AnimationPlayer.play("default")
	create_lasers()
	pass


func create_lasers():
	var add_laser : bool = true
	var laser

	for node in $Emitters.get_children():
		if add_laser:
			laser = Line2D.new()
			add_child(laser)
			laser.add_point(node.position)
			laser.default_color = "ff0000"
			laser.width = 4
			laser.visible = false
			add_laser = false
			continue
		laser.add_point(node.position)
		add_laser = true


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


func hide_lasers():
	for node in get_children():
		if node is Line2D:
			node.visible = false
			
		
func _on_Cooldown_timeout() -> void:
	is_active = true
	$AnimationPlayer.play("default")
