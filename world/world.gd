extends Node2D

func _ready():
	for a in get_tree().get_nodes_in_group("turret"):
		a.connect("shoot", self, "_on_turret_shoots")

func _on_turret_shoots(b):
	$bullets.add_child(b)
		
