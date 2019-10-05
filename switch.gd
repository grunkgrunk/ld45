extends Area2D

signal switched_on
signal switched_off

export(bool) var is_on = false

func _ready():
	$AnimatedSprite.frame = 0
	if is_on:
		$AnimatedSprite.frame = 1

func activate():
	if is_on:
		switch_off()
	else:
		switch_on()

func switch_on():
	is_on = true
	emit_signal("switched_on")
	$AnimatedSprite.frame = 1

func switch_off():
	is_on = false
	emit_signal("switched_off")
	$AnimatedSprite.frame = 0




