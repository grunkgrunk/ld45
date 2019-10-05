extends KinematicBody2D

var vel = Vector2()
var alive = true

func _process(delta):
	if not alive:
		return
	var col = move_and_collide(vel * delta)
	if col:
		alive = false
		queue_free()
		
