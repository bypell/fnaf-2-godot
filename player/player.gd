extends Node3D


@export_group("Links")

## The GUI node that will tell the player node when, for example, the player is trying to put the mask on.
@export var gui_node : Control
@export var cam_manager : Node


@export_group("Panning Settings")

## Player view panning mode. 
## [br][br]When set to [code]Use Curve[/code], the panning speed increases as the mouse goes away from the center of the screen based on [param panning_curve].
## [br][br]When set to [code]Absolute[/code], all parameters except the rotation limits are ignored.
@export_enum("Use Curve", "Absolute") var panning_mode : String = "Use Curve"

## Curve that is used to increase the panning speed as the mouse moves away from the center of the screen.
## [br][br]The left side of the graph represents the center or the screen. 
## [br][br]The right side of the graph represents the left or right side of the screen.
## [br][br]The height of the line represents how much of [param max_panning_speed] is used.
@export var panning_curve : Curve = preload("res://panning_curve_presets/smooth.tres")

## How fast the player can pan left or right.
@export var max_panning_speed : float = 70.0

## How far to the left the player can look (in degrees).
@export_range(0.0, 180.0) var left_rotation_limit : float = 50.0

## How far to the right the player can look (in degrees).
@export_range(-180.0, 0.0) var right_rotation_limit : float = -50.0

## Turn this on to ignore rotation limits.
@export var allow_360 : bool = false


@onready var cam = $Camera3D
@onready var mask = %Mask
@onready var monitor = $%Monitor


func _ready():
	# Connecting a signal from the GUI to a function in this script
	# The GUI node will tell us when we have to toggle the mask
	cam.current = true
	gui_node.mask_button_mouse_entered.connect(tell_mask_to_toggle)
	gui_node.monitor_button_mouse_entered.connect(flip_monitor)


func _process(delta):
	# Getting the mouse x position and transforming it into a value between 0 and 1 (left side and right side)
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_pos_x_normalized = (mouse_pos.x / get_viewport().get_visible_rect().size.x)
	
	# Call the correct panning function based on the panning mode
	var panning_function : Callable
	
	match panning_mode:
		"Use Curve":
			panning_function = Callable(self, "panning_use_curve")
		"Absolute":
			panning_function = Callable(self, "panning_absolute")
	
	panning_function.call(delta, mouse_pos_x_normalized)


func panning_use_curve(delta, mouse_pos_x_normalized):
	# Getting how far from the center the mouse is (value between 0 and 1) 
	var distance_from_center = abs(mouse_pos_x_normalized - 0.5) * 2.0
	
	# Setting the panning speed multiplier based on that value and the panning_curve
	var panning_speed_multiplier = panning_curve.sample(distance_from_center)
	
	# Inversing the value if the mouse is on the right side of the screen
	if mouse_pos_x_normalized > 0.5:
		panning_speed_multiplier *= -1
	
	# Rotating the camera
	cam.rotation_degrees.y += (delta * max_panning_speed * panning_speed_multiplier)
	
	# Preventing the camera from going too far left or right if allow_360 is disabled
	if not allow_360:
		cam.rotation_degrees.y = clampf(cam.rotation_degrees.y, right_rotation_limit, left_rotation_limit)


func panning_absolute(delta, mouse_pos_x_normalized):
	# Taking mouse position (0, 1) and applying it directly to the camera rotation (right_rotation_limit, left_rotation_limit)
	cam.rotation_degrees.y = left_rotation_limit - ((left_rotation_limit - right_rotation_limit) * mouse_pos_x_normalized)
	cam.rotation_degrees.y = clampf(cam.rotation_degrees.y, right_rotation_limit, left_rotation_limit)


func tell_mask_to_toggle():
	if monitor.monitor_on:
		return
	
	mask.toggle_mask()


func flip_monitor():
	if mask.mask_on:
		return
	
	if monitor.monitor_on:
		monitor.turn_off()
		cam_manager.disable_camera_display()
		cam.current = true
	else:
		monitor.turn_on()
		await monitor.turned_on
		cam.current = false
		cam_manager.enable_camera_display()
