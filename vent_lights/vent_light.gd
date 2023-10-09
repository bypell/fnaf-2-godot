extends OmniLight3D

@onready var light_sound = $LightSound


func _on_visibility_changed():
	if visible:
		light_sound.play()
	else:
		light_sound.stop()
