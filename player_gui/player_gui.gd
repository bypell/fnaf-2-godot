extends Control

signal mask_button_mouse_entered
signal monitor_button_mouse_entered

const IGNORE_MOUSE_ENTERING_BOTTOM_MARGIN = 25.0

@onready var mask_button = %MaskButton
@onready var monitor_button = %MonitorButton


func _on_mask_button_mouse_entered():
	if is_mouse_coming_from_bottom_of_window():
		return
	emit_signal("mask_button_mouse_entered")


func _on_monitor_button_mouse_entered():
	if is_mouse_coming_from_bottom_of_window():
		return
	emit_signal("monitor_button_mouse_entered")


func is_mouse_coming_from_bottom_of_window() -> bool:
	# This function checks if the mouse is almost at the complete bottom of the window
	return get_global_mouse_position().y > (get_viewport().get_visible_rect().size.y - IGNORE_MOUSE_ENTERING_BOTTOM_MARGIN)
