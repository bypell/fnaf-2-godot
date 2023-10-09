extends Node3D

signal turned_on
signal turned_off

var monitor_on = false
var refuse_requests = false

@onready var anim = $AnimationPlayer


func turn_on():
	if refuse_requests:
		return
	
	refuse_requests = true
	anim.play("slam_into_face")
	monitor_on = true
	await anim.animation_finished
	emit_signal("turned_on")
	refuse_requests = false
	

func turn_off():
	if refuse_requests:
		return
	
	refuse_requests = true
	anim.play("put_back_down")
	monitor_on = false
	await anim.animation_finished
	emit_signal("turned_off")
	refuse_requests = false
