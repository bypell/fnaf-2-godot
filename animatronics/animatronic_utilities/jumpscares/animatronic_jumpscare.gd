@tool
extends Node3D
class_name AnimatronicJumpscare

@export var jumpscare_anim_name := "jumpscare"
@export var scene_to_go_after : PackedScene = preload("res://game_over/game_over.tscn")
@export var test_jumpscare: bool = false: 
	set(value):
		play_jumpscare()

var model : Node3D
var model_anim : AnimationPlayer

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	model = get_child(0) as Node3D
	if model:
		model_anim = model.get_node("AnimationPlayer") as AnimationPlayer
	if model_anim:
		model.hide()
	else:
		printerr(self.name + " does not have a child animated model.")


func play_jumpscare():
	if not model_anim:
		return
	audio.play()
	model_anim.play(jumpscare_anim_name)
	await get_tree().process_frame
	model.show()
	await model_anim.animation_finished
	model.hide()
	if not Engine.is_editor_hint():
		get_tree().change_scene_to_file("res://game_over/game_over.tscn")
