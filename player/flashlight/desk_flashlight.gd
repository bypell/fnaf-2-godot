extends SpotLight3D
class_name DeskFlashlight

signal flashlight_is_back

@export var player : Node3D
@export var vent_lights : Array[Light3D]

@onready var flashlight_sound = $FlashlightSound
@onready var flashlight_sound_not_working = $FlashlightSoundNotWorking
@onready var disabled_timer = $DisabledTimer

var prevent_flashlight = false


func _process(delta):
	var player_physically_cannot_toggle_flashlight = false
	
	if player and (player.mask.mask_on or player.monitor.monitor_on):
		player_physically_cannot_toggle_flashlight = true
	
	if Input.is_action_pressed("flashlight") and not are_vent_lights_on():
		if not prevent_flashlight and not player_physically_cannot_toggle_flashlight:
			show()
			if not flashlight_sound.playing:
				flashlight_sound.play()
		else:
			hide()
			flashlight_sound.stop()
			
		if prevent_flashlight and not player_physically_cannot_toggle_flashlight:
			if not flashlight_sound_not_working.playing:
				flashlight_sound_not_working.play()
			else:
				flashlight_sound_not_working.stop()
		else:
			flashlight_sound_not_working.stop()
	else:
		hide()
		flashlight_sound.stop()
		flashlight_sound_not_working.stop()


func disable_for(time : int):
	prevent_flashlight = true
	disabled_timer.stop()
	disabled_timer.wait_time = time
	disabled_timer.start()
	

func are_vent_lights_on():
	for l in vent_lights:
		if l.visible:
			return true #yessir
	return false


func _on_disabled_timer_timeout():
	prevent_flashlight = false
	emit_signal("flashlight_is_back")
