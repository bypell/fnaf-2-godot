extends Node
class_name FlashingLightsEventManager

signal event_done

@onready var timer := $Timer as Timer

var event_in_progress := false
var lights : Array[Light3D]
var initial_lights_energy : Array[float]


func _ready():
	for c in get_children():
		if c is Light3D:
			lights.append(c)
	for l in lights:
		initial_lights_energy.append(l.light_energy)


func start_flashing_lights_event():
	event_in_progress = true
	timer.wait_time = 0.03
	timer.start()
	while true:
		await timer.timeout
		if randi() % 2 == 0:
			toggle_lights()
		timer.wait_time += 0.001
		if timer.wait_time > 0.1:
			break
	event_done.emit()
	fade_out_of_flashing_lights_event()
	

func fade_out_of_flashing_lights_event():
	for l in lights:
		l.visible = true
		l.light_energy = 0
	timer.wait_time = 0.1
	var amount_energy = 0.0
	var lights_number = lights.size()
	while amount_energy < 1:
		if amount_energy > 1:
			amount_energy = 1
		for i in range(lights_number):
			lights[i].light_energy = initial_lights_energy[i] * amount_energy
		amount_energy += 0.1
		await timer.timeout
		event_in_progress = false
	

func toggle_lights():
	for l in lights:
		l.visible = not l.visible
