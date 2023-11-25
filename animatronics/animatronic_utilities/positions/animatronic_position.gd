@tool
extends Marker3D
class_name AnimatronicPosition
## Position that an animatronic can go to.
##
## This node represents a transform and an animation that an animatronic can apply to itself.

@export var animation_to_play : String = "" ## The animation that the animatronic can play when here.


## Returns the AnimatronicPosition above this one in the scene hierarchy. Or null if we are the first one.
func get_previous_position() -> AnimatronicPosition:
	if self.get_index() == 0:
		return null
	else:
		var idx = -1
		var previous_pos = get_parent().get_child(self.get_index() + idx)
		while not previous_pos is AnimatronicPosition:
			idx -= 1
			previous_pos = get_parent().get_child(self.get_index() + idx)
		return get_parent().get_child(self.get_index() - 1)


## Returns the AnimatronicPosition below this one in the scene hierarchy. Or null if we are the last one.
func get_next_position() -> AnimatronicPosition:
	var last_possible_index = get_parent().get_child_count() - 1
	if (self.get_index() + 1) > last_possible_index:
		return null
	else:
		var idx = 1
		var next_pos = get_parent().get_child(self.get_index() + idx)
		while not next_pos is AnimatronicPosition:
			idx += 1
			next_pos = get_parent().get_child(self.get_index() + idx)
		return get_parent().get_child(self.get_index() + 1)
