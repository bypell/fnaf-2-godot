extends Control


func _on_night_one_button_pressed():
	start_night(1)


func _on_night_two_button_pressed():
	start_night(2)


func start_night(night : int):
	Global.current_night = night
	get_tree().change_scene_to_file("res://night/night.tscn")
	
