extends Node3D
class_name AnimatronicBase
## Base class for all animatronics that have an AI level.


const MAX_AI_LEVEL := 20

@export var player_desk_flashlight : DeskFlashlight ## A link to the player's desk flashlight node (to disable it or check if it's turned on)
@export var animatronic_jumpscare : AnimatronicJumpscare

var ai_level := 0


func start_ai():
	pass


## Disables the player's desk flashlight for a set amount of time.[br]
## Use the "await" keyword to wait until the function is done before making the animatronic do something else.
func temporarily_disable_player_desk_flashlight(time : float = 1.0):
	player_desk_flashlight.disable_for(time)
	await player_desk_flashlight.flashlight_is_back
