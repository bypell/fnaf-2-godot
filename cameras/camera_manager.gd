extends Node

var selected_cam : Camera3D
var all_cams = {}

@onready var cam_ui = $%CameraUI
@onready var cam_buttons_parent = $%CamButtonsParent
@onready var cam_click_sound = $CamClickSound
@onready var ui_animation_player = $CameraUI/AnimationPlayer
@onready var cam_flashlight_sound = $CamFlashlightSound


func _ready():
	cam_ui.visible = false
	
	for c in get_children():
		if c is Camera3D:
			all_cams[c.name.to_lower()] = c
			c.current = false
			c.visible = false
			
	for c in cam_buttons_parent.get_children():
		if c is BaseButton:
			c.connect("cam_button_pressed", set_current_cam)
	
	if not all_cams.values().is_empty():
		selected_cam = all_cams.values()[0]
	else:
		printerr("no cams present")


func _process(delta):
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
	ui_animation_player.play("lost_communication")


func enable_camera_display():
	selected_cam.current = true
	cam_ui.visible = true


func disable_camera_display():
	selected_cam.current = false
	cam_ui.visible = false
