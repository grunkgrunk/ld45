extends RigidBody2D

var lift_mass = 1 
var cursor = null

func _ready():
	pass # Replace with function body.
	
func pickup(_cursor):
	if cursor:
		return
	mode = RigidBody2D.MODE_STATIC
	cursor = _cursor
	
func drop(impulse=Vector2.ZERO):
	if cursor:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse)
		cursor = null
		
func _physics_process(delta):
    if cursor:
        global_transform.origin = cursor.global_position
