extends Node3D
## Root node of the night scene
##
## This node manages different things related to the night in general, like animatronic AI levels depending on the night.

@export var clock : Control
@export var blue_animatronic : AnimatronicBase
@export var yellow_animatronic : AnimatronicBase


func _ready():
	clock.six_am_reached.connect(night_done)
	match Global.current_night:
		1:
			manage_night_one_ai_levels()
		2:
			manage_night_two_ai_levels()


func start_all_animatronic_ais():
	blue_animatronic.start_ai()
	yellow_animatronic.start_ai()


func night_done():
	get_tree().change_scene_to_file("res://night/six_am/six_am.tscn")


func manage_night_one_ai_levels():
	yellow_animatronic.ai_level = 0
	blue_animatronic.ai_level = 0
	start_all_animatronic_ais()
	await clock.hour_passed 
	
	# now 1AM
	blue_animatronic.ai_level = 5
	await clock.hour_passed
	
	# now 2AM
	yellow_animatronic.ai_level = 2
	await clock.hour_passed
	
	# now 3AM
	await clock.hour_passed
	
	# now 4AM
	blue_animatronic.ai_level = 2
	yellow_animatronic.ai_level = 5


func manage_night_two_ai_levels():
	yellow_animatronic.ai_level = 10
	blue_animatronic.ai_level = 10
	start_all_animatronic_ais()
