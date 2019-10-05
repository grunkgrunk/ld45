extends Area2D

func get_force(a):
	var dir = a.global_position - global_position
	return dir.normalized() / dir.length_squared()
	
	
	
	