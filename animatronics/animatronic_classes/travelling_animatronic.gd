extends AnimatronicBase
class_name TravellingAnimatronic
## Base class for animatronics that travel around the map.
##
## You can make your animatronic script extend this class to facilitate
## the process of making your animatronic move around.[br]
## Check out the code for one of the animatronics extending this class to get an idea of how you can use it.


const MOVEMENT_OPPORTUNITY_WAIT_TIME := 4 ## The time in seconds between each movement opportunity that the animatronic attempts.

@export var animatronic_positions_container : AnimatronicPositionsContainer ## A link to the animatronic's positions container. It will provide us with positions that the animatronic can go to.
@export var cam_manager : CameraManager ## A link to the camera manager (to be able to make the monitor lose communication when the animatronic moves).
@export var animation_player_path : String ## A string path to the model's [AnimationPlayer] node (so we can play different pose animations at different positions).

var _animation_player : AnimationPlayer
var current_position : AnimatronicPosition ## The [AnimatronicPosition] that the animatronic is currently at.


func _ready():
	_animation_player = get_node(animation_player_path)


## Makes the animatronic move between two positions
## the animatronic will pass through all position nodes in between (in the node hierarchy) before reaching its destination
## (can go upwards or downwards and will wait for a successful movement opportunity before each move).[br]
## Use the "await" keyword to wait until the function is done before making the animatronic do something else.
func travel_from_pos_to_pos(start_pos_name : String, end_pos_name : String):
	var start_pos : AnimatronicPosition = animatronic_positions_container.get_position_by_name(start_pos_name)
	var end_pos : AnimatronicPosition = animatronic_positions_container.get_position_by_name(end_pos_name)

	if start_pos == end_pos:
		return

	var roam_direction = 1 if end_pos.get_index() > start_pos.get_index() else -1 if end_pos.get_index() < start_pos.get_index() else 0
	if roam_direction == 0:
		return
	
	if current_position != start_pos:
		cam_manager.lose_communication(0.2)
		apply_position_to_body(start_pos)
		current_position = start_pos
	
	while true:
		# wait for a successful movement opportunity
		await wait_for_successful_movement_opportunity()
		
		# select next position in path
		if roam_direction > 0:
			current_position = current_position.get_next_position()
		else:
			current_position = current_position.get_previous_position()
			
		if not current_position:
			return
		
		cam_manager.lose_communication(0.2)
		apply_position_to_body(current_position)
		
		if current_position == end_pos:
			return


## Makes the animatronic directly move to the specified position name.
func move_to_pos(pos_name : String):
	var pos : AnimatronicPosition = animatronic_positions_container.get_position_by_name(pos_name)
	cam_manager.lose_communication(0.2)
	current_position = pos
	apply_position_to_body(current_position)


## Physically teleports the animatronic to an [AnimatronicPosition]
## and applies its [param animation_to_play] property if it is a valid animation name.
func apply_position_to_body(pos : AnimatronicPosition):
	global_transform = pos.global_transform
	if _animation_player and _animation_player.has_animation(pos.animation_to_play):
		_animation_player.play(pos.animation_to_play)
		

## This function ends once a movement opportunity is successful.[br]
## Use the "await" keyword to wait until the function is done before making the animatronic do something else.
func wait_for_successful_movement_opportunity():
	while true:
		await get_tree().create_timer(MOVEMENT_OPPORTUNITY_WAIT_TIME).timeout
		if ai_level >= randi_range(1,MAX_AI_LEVEL):
			break
