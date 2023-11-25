extends MaskFooledAnimatronic


@export var left_vent_light : VentLight

var notice_player_no_mask_delay := 1.5


func _ready():
	super._ready()
	if not _animation_player:
		printerr("Animatronic " + self.name + " does not have a valid AnimationPlayer set up.")


func start_ai():
	# Go to Stage and progressively move to SmallHallway.
	await travel_from_pos_to_pos("Stage", "Stage3")
	
	# From here, infinitely roam from Stage3 to OfficeLeftVent and try to attack the player.
	while true:
		show()
		
		await travel_from_pos_to_pos("Stage3", "LeftVent")
		await wait_for_successful_movement_opportunity()
		
		if left_vent_light.is_turned_on():
			await left_vent_light.turned_off
		
		move_to_pos("OfficeLeftVent")
		
		# Wait for a successful entering office movement opportunity.
		# We also make the first two opportunities fail so the animatronic is not too overpowered.
		await wait_for_entering_office_successful_movement_opportunity(2)
		
		if left_vent_light.is_turned_on():
			await left_vent_light.turned_off
		
		# Judgement time!
		hide()
		if player.is_mask_on():
			$VentLeavingSound.play()
			await $VentLeavingSound.finished
			continue
		else:
			await player.monitor_flipped_up
			await get_tree().create_timer(randf_range(0.0, 1.0)).timeout
			await player.force_monitor_down()
			animatronic_jumpscare.play_jumpscare()

