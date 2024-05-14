extends Control


signal hour_passed
signal six_am_reached

const SECONDS_BETWEEN_HOURS : int = 60

@onready var label : Label = $Label

var current_hour : int = 0


func _ready():
	# todo: should put this in another function and call it in a deferred way. (too lazy to git clone and fix rn)
	while current_hour < 6:
		label.text = _get_current_hour_text()
		await get_tree().create_timer(SECONDS_BETWEEN_HOURS).timeout
		current_hour += 1
		hour_passed.emit()
	
	label.text = _get_current_hour_text()
	six_am_reached.emit()


func _get_current_hour_text() -> String:
	if current_hour == 0:
		return "12 AM"
	else:
		return str(current_hour) + " AM"
