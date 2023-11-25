extends TravellingAnimatronic
class_name MaskFooledAnimatronic
## A base class for animatronics that can be fooled by the player's mask.
##
## A base class for animatronics that can be fooled by the player's mask. Can handle judging whether the player has put on the mask at the correct time and for long enough.

const MAX_DANGER_LEVEL = 0.5

@export var flashing_lights_event_manager : FlashingLightsEventManager
@export var player : Player ## A link to the player node so that the animatronic can check if mask is on, etc.

var player_now_has_to_have_mask_on := false
var max_danger_reached := false
var danger_buildup := 0.0


func _process(delta):
	if player_now_has_to_have_mask_on and not player.is_mask_on():
		danger_buildup += delta
		if danger_buildup > MAX_DANGER_LEVEL:
			max_danger_reached = true
			set_process(false)
	else:
		danger_buildup = 0.0


## A different movement opportunity system meant to be used when the animatronic wants to enter the office.[br]
## The animatronic has a 10% chance to enter the office every 1.5 - (0.5 x (ai_level/MAX_AI_LEVEL)) seconds
## or it will enter the office if the player has the mask on for a certain amount of opportunities.[br]
## The safe_ticks parameter makes the first set amount of movement opportunities fail.[br]
## Use the "await" keyword to wait until the function is done before making the animatronic do something else.
func wait_for_entering_office_successful_movement_opportunity(safe_ticks : float = 0):
	var safe_ticks_left = safe_ticks
	var mask_on_time = 0
	while true:
		await get_tree().create_timer(1.5 - (0.5 * (ai_level/MAX_AI_LEVEL))).timeout
		mask_on_time = mask_on_time + 1 if player.mask.mask_on else 0
		safe_ticks_left = safe_ticks_left - 1 if safe_ticks_left > 0 else 0 
		
		if safe_ticks_left > 0:
			continue
		
		if randi_range(1,10) == 1 or mask_on_time >= 4:
			break


## Makes the animatronic enter the office, makes the lights flicker and decides whether to jumpscare
## the player depending on if the mask is put on in time and not left off for too long.
func enter_office_and_try_to_kill_player(office_position_name : String):
	# if the lights are flashing, that means that another animatronic is in the office, we wait
	if flashing_lights_event_manager.event_in_progress:
		await flashing_lights_event_manager.event_done
		
	player.force_monitor_down()
	
	# move to our office position and start event
	move_to_pos(office_position_name)
	flashing_lights_event_manager.start_flashing_lights_event()
	
	# short safe period before checking for mask (how forgiving depends on ai level)
	await get_tree().create_timer(2 - (1.3 * (ai_level/MAX_AI_LEVEL))).timeout
	player_now_has_to_have_mask_on = true
	
	await flashing_lights_event_manager.event_done
	var do_jumpscare = danger_buildup >= MAX_DANGER_LEVEL
	player_now_has_to_have_mask_on = false
	
	if do_jumpscare:
		hide()
		await player.monitor_flipped_up
		await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
		await player.force_monitor_down()
		animatronic_jumpscare.play_jumpscare()
