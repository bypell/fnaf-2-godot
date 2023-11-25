extends MaskFooledAnimatronic


@export var right_vent_light : VentLight


func _ready():
	super._ready()
	if not _animation_player:
		printerr("Animatronic " + self.name + " does not have a valid AnimationPlayer set up.")


func start_ai():
	# go to Stage and eventually move to SmallHallway
	await travel_from_pos_to_pos("Stage", "SmallHallway")
	
	# from here, infinitely roam from SmallHallway to OfficeRightVent and try to attack the player
	while true:
		await travel_from_pos_to_pos("SmallHallway", "PartyRoomLeft")
		await wait_for_successful_movement_opportunity()
		await temporarily_disable_player_desk_flashlight()
		move_to_pos("Hallway")
		await wait_for_successful_movement_opportunity()
		await temporarily_disable_player_desk_flashlight()
		await travel_from_pos_to_pos("PartyRoomRight", "RightVent")
		await wait_for_successful_movement_opportunity()
		
		if right_vent_light.is_turned_on():
			await right_vent_light.turned_off
		
		move_to_pos("OfficeRightVent")
		await wait_for_entering_office_successful_movement_opportunity()
		await enter_office_and_try_to_kill_player("Office")
