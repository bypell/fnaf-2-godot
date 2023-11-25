@tool
extends Node3D
class_name AnimatronicJumpscare
## Jumpscare player node.
##
## This node can play a jumpscare animation and changes the scene to the game over scene afterwards.
## [br]Requires a model (Node3D node with an animationplayer as a child) to work.
## [br]You can also optionally add a AudioStreamPlayer as a child of this node to play a jumpscare sound (or just modify the animation to play audio).


@export var jumpscare_anim_name := "jumpscare"
@export var scene_to_go_after : PackedScene = preload("res://game_over/game_over.tscn")
@export var test_jumpscare: bool = false: 
	set(value):
		play_jumpscare()

var model : Node3D
var model_anim : AnimationPlayer

@onready var audio : AudioStreamPlayer = $AudioStreamPlayer as AudioStreamPlayer


func _ready():
	for c in get_children():
		if c is AudioStreamPlayer:
			audio = c as AudioStreamPlayer
	
	for c in get_children():
		if c is Node3D:
			model = c as Node3D
			break
	if model:
		model_anim = model.get_node("AnimationPlayer") as AnimationPlayer
	if model_anim:
		model.hide()
	else:
		printerr(self.name + " does not have a child animated model.")


func play_jumpscare():
	if not model_anim:
		return
	if audio:
		audio.play()
	model_anim.play(jumpscare_anim_name)
	await get_tree().process_frame
	model.show()
	await model_anim.animation_finished
	model.hide()
	if not Engine.is_editor_hint():
		get_tree().change_scene_to_file("res://game_over/game_over.tscn")
