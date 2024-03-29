extends KinematicBody2D

var vel = Vector2()
var acc = Vector2()

var mouse_delta = Vector2()

enum MOUSE_MODE {
	SPACE,
	NORMAL,
	PHYSICS,
	SAND,
	SMOOTH,
	GRAVITY
}

export(PackedScene) var next

var can_control = true
var mouse_mode = MOUSE_MODE.SPACE
var prev_mode = mouse_mode
var held_object = null

func _ready():
	# position = last_mouse_pos
	# get_viewport().warp_mouse(Vector2(100,100))
	position = Vector2(100,100)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


	
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	for a in $area.get_overlapping_areas():
		if a.is_in_group("attractor"):
			var f = a.get_force(global_position) * 100
			acc += f * delta
		
		if Input.is_action_just_pressed("left_click"):

			if a.is_in_group("switch"):
				a.activate()
			if a.owner.is_in_group("draggable"):
				if !held_object:
					held_object = a.owner
					held_object.pickup(self)
				
	if Input.is_action_just_released("left_click"):
		if held_object:
			held_object.drop()
			held_object = null
	
	vel = get_velocity(mouse_mode, delta)
	move_and_slide(vel)
	if $ray.get_collider() and vel.y > 0:
		vel.y = 0
		vel.x *= 0.9
	if $ray2.get_collider() and abs(vel.x) > 0:
		vel.x = 0
		
	mouse_delta = Vector2()
	acc = Vector2()
	
	
func get_velocity(mouse_mode, delta):
	match mouse_mode:
		MOUSE_MODE.SPACE:
			return outer_space(delta, 1)
		MOUSE_MODE.SMOOTH:
			return outer_space(delta, 0.99)
		MOUSE_MODE.NORMAL:
			return normal_move(50)
		MOUSE_MODE.PHYSICS:
			return physics_move(delta)
		MOUSE_MODE.SAND:
			return normal_move(delta)
		MOUSE_MODE.GRAVITY:
			return gravity_move(delta)

func gravity_move(delta):
	acc += Vector2(0, 100)
	vel += acc * 10
	vel += normal_move(50)
	return vel


func outer_space(delta, friction=1):
	acc += mouse_delta * delta
	vel += acc * 10
	vel *= friction
	return vel

func normal_move(delta):
	return (mouse_delta * delta).clamped(2500)

func physics_move(delta):
	if can_control and mouse_delta != Vector2():
		mouse_mode = prev_mode
	acc += Vector2(0, 1000) * delta
	vel += acc * 10
	return vel

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(vel)
			held_object = null
	

func _on_area_area_entered(area):
	if area.is_in_group("win"):
		get_tree().change_scene_to(next)
	if area.is_in_group("no_control_area"):
		prev_mode = mouse_mode
		mouse_mode = MOUSE_MODE.PHYSICS
		can_control = false
	
	if area.is_in_group("spike"):
		get_tree().reload_current_scene()

func _on_area_area_exited(area):
	if area.is_in_group("no_control_area"):
		can_control = true

