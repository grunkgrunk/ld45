extends Area2D

func get_force(a):
	var dir = global_position - a
	return dir.normalized() * 1000 / max(dir.length_squared(), 10)
	
