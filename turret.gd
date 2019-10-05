extends KinematicBody2D

var bullet = preload("res://bullet_kinematic.tscn")
var player = null
signal shoot

func _on_range_body_entered(body):
	if body.is_in_group("cursor"):
		player = body 

func _on_range_body_exited(body):
	if body.is_in_group("cursor"):
		player = null 

func _on_shoot_freq_timeout():
	if player:
		var b = bullet.instance()
		b.global_position = global_position
		b.vel = calc_vel(player.global_position - global_position)
		emit_signal("shoot", b)
		
func calc_vel(d):
	return d.normalized() * 600
	#var v0 = 1000
	#var vto2 = pow(v0, 2)
	#var vto4 = pow(vto2, 2)
	#var g = 980
	#var angle = atan((vto2 + sqrt(vto4 - g * (g * pow(d.x, 2) + 2 * d.y * vto2)))/(g*d.x) )
	#return Vector2(v0,0).rotated(-angle)
	
