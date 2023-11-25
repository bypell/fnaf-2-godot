@tool
extends Node3D
class_name AnimatronicPositionsContainer

@export_group("Testing Utilities")
@export var testing_model : Node3D
@export var testing_model_turn_180 : bool = true
@export var testing_position_name : String


func _ready():
	if not Engine.is_editor_hint():
		set_process(false)


func _process(delta):
	if Engine.is_editor_hint() and testing_model and testing_model.is_inside_tree() and testing_position_name:
		var animatronic_pos = get_position_by_name(testing_position_name)
		if not animatronic_pos:
			return
		testing_model.global_transform = animatronic_pos.global_transform
		var animation_player = testing_model.get_node("AnimationPlayer") as AnimationPlayer
		if animation_player and animation_player.has_animation(animatronic_pos.animation_to_play):
			animation_player.play(animatronic_pos.animation_to_play)
		if testing_model_turn_180:
			testing_model.global_rotate(animatronic_pos.global_transform.basis.y, deg_to_rad(180))


## returns an array of positions that the animatronic will go through on it's path to the office
func get_array_of_positions() -> Array[AnimatronicPosition]:
	var positions : Array[AnimatronicPosition] = []
	for c in get_children():
		if c is AnimatronicPosition:
			positions.append(c)
	return positions


func get_position_by_name(pos_name : String) -> AnimatronicPosition:
	for c in get_children():
		if c is AnimatronicPosition and c.name == pos_name:
			return c
	return null
