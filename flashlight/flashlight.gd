extends SpotLight3D

@export var player : Node3D

@onready var flashlight_sound = $FlashlightSound


func _process(delta):
	var player_unable_to_toggle_flashlight = false
	
	if player and (player.mask.mask_on or player.monitor.monitor_on):
		player_unable_to_toggle_flashlight = true
	
	if Input.is_action_pressed("flashlight") and not player_unable_to_toggle_flashlight:
		show()
		flashlight_sound.play()
	else:
		hide()
		flashlight_sound.stop()
