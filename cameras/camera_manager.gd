extends Node
class_name CameraManager
## Camera Manager node
##
## This node manages a bunch of Camera3D nodes and keeps in it's scene a Camera UI
## that contains a bunch of camera buttons to allow the player to switch between cameras.

const DEFAULT_CAM_INDEX = 0

var selected_cam : Camera3D
var all_cams = {}

@onready var cam_ui = $%CameraUI
@onready var cam_buttons_parent = $%CamButtonsParent
@onready var cam_click_sound = $CamClickSound
@onready var ui_animation_player = $CameraUI/AnimationPlayer
@onready var cam_flashlight_sound = $CamFlashlightSound


func _ready():
	cam_ui.visible = false
	
	# Add all cameras to the camera dictionary
	# Each key is the name of the camera in lowercase and the value is a reference to the Camera3D node.
	for c in get_children():
		if c is Camera3D:
			all_cams[c.name.to_lower()] = c
			c.current = false
			c.visible = false
	
	# Connect the cam_button_pressed signal from each camera button
	# to the set_current_cam function
	for c in cam_buttons_parent.get_children():
		if c is BaseButton:
			c.connect("cam_button_pressed", set_current_cam)
	
	# Set default cam
	if not all_cams.values().is_empty():
		selected_cam = all_cams.values()[DEFAULT_CAM_INDEX]
	else:
		printerr("no cameras are under camera manager")


func _process(delta):
	# Turning on flashlight on the current camera if the action is pressed
	# We are just changing the camera's visibility (which does not 
	# affect the camera in itself, just its child SpotLight3D)
	if Input.is_action_pressed("flashlight") and selected_cam.current:
		selected_cam.visible = true
		if not cam_flashlight_sound.playing:
			cam_flashlight_sound.play()
	else:
		selected_cam.visible = false
		cam_flashlight_sound.stop()


func set_current_cam(cam : String):
	# set the previous camera as not current and hide it, switch to the new one and make that one current
	selected_cam.current = false
	selected_cam.visible = false
	selected_cam = all_cams[cam.to_lower()]
	selected_cam.current = true
	cam_click_sound.play()
	lose_communication(1.0)


func lose_communication(time_scale : float):
	ui_animation_player.stop()
	ui_animation_player.speed_scale = time_scale
	ui_animation_player.play("lost_communication")


func enable_camera_display():
	selected_cam.current = true
	cam_ui.visible = true


func disable_camera_display():
	selected_cam.current = false
	cam_ui.visible = false
