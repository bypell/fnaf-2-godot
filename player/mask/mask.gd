extends Node3D

var mask_on = false

@onready var anim = $AnimationPlayer


func toggle_mask():
	mask_on = not mask_on
	if mask_on:
		anim.play("put_on")
	else:
		anim.play("put_off")
