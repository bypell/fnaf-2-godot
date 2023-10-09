extends Area3D

@export var connected_light : Light3D
@export var player : Node3D


func _ready():
	# Hide the light as it should be off at the beginning
	connected_light.hide()

func _input(event):
	# If left mouse button released, turn off light
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		connected_light.visible = false


func _on_input_event(camera, event, position, normal, shape_idx):
	# If left mouse button pressed while hovering over the button, turn on light
	if not player.mask.mask_on and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		connected_light.visible = true


func _on_mouse_exited():
	# If mouse no longer hovering over button, turn off light
	connected_light.visible = false
