extends OmniLight3D
class_name VentLight

signal turned_on
signal turned_off

@onready var light_sound = $LightSound


func _on_visibility_changed():
	if visible and not light_sound.playing:
		light_sound.play()
		turned_on.emit()
	else:
		light_sound.stop()
		turned_off.emit()


func is_turned_on() -> bool:
	return self.visible
