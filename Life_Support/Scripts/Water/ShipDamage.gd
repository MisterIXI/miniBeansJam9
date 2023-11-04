extends Node3D

var waterlevel = 0
var maxWaterlevel = 1.3
var drainspeed = -0.1
var fillSpeed = 0.05
var maxLeaks = 3

var pipe1
var pipe2

var waterLeak

var water

signal game_over


func _ready():
	pipe1 = get_node("Pipes/Left/Pipe1")
	pipe2 = get_node("Pipes/Right/Pipe2")

	waterLeak = preload("res://Nodes/Water/water_leak.tscn")
	water = get_node("Water")


func _process(delta):
	if waterlevel >= maxWaterlevel:
		emit_signal("game_over")
	elif waterlevel >= 0:
		waterlevel += drainspeed * delta

	water.global_transform.origin = Vector3(0, waterlevel, 0)
	
	





func _on_radar_ship_damage():
	for i in range(0, randi_range(1,maxLeaks)):
		var leak = waterLeak.instantiate()
		add_child(leak)
		
		if randi() % 2:
			leak.global_transform.origin = (pipe1.global_transform.origin - (pipe1.get_scale().x * Vector3(0.5,0,0))) + (randf_range(0, pipe1.get_scale().x) * Vector3(1,0,0))
		else:
			leak.global_transform.origin = (pipe2.global_transform.origin - (pipe2.get_scale().x * Vector3(0.5,0,0))) + (randf_range(0, pipe2.get_scale().x) * Vector3(1,0,0))
			leak.rotate_y(deg_to_rad(180))


func FillWater(delta):
	waterlevel += fillSpeed * delta
