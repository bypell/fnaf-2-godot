extends Button

signal cam_button_pressed(cam_node_name:String)

## The name of the related Camera3D under CameraManager in the "night" scene
@export var camera_node_name : String
@export var cam_manager : Node


func _ready():
	if camera_node_name.is_empty():
		camera_node_name = text
	

func _pressed():
	emit_signal("cam_button_pressed", camera_node_name)
