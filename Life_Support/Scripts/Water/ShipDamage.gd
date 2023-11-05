extends Node3D

var waterlevel = -1.6
var maxWaterlevel = -0.3
var drainspeed = -0.03
var fillSpeed = 0.01
var maxLeaks = 3

var pipes = []


var waterLeak
var water

signal game_over


func _ready():
	pipes = get_node("Pipes").get_children()

	waterLeak = preload("res://Nodes/Water/water_leak.tscn")
	water = get_node("Water")


func _process(delta):
	if waterlevel >= maxWaterlevel:
		print_debug("Game Over")
		emit_signal("game_over")
		fillSpeed = 0
		drainspeed = 0
	elif waterlevel >= -1.6:
		waterlevel += drainspeed * delta
	print_debug("Water level: " + str(waterlevel))
	water.transform.origin = Vector3(0, waterlevel, 0)
	



func _on_radar_ship_damage():
	for i in range(0, randi_range(1,maxLeaks)):
		var leak = waterLeak.instantiate()
		add_child(leak)
		
		var pipeIndex = randi_range(0, pipes.size() - 1)
		print_debug(pipes[pipeIndex].name)

		var selector = Vector3(1,0,0)
		
		if "Up" in pipes[pipeIndex].name:
			selector = Vector3(0,1,0)
		if "Left" in pipes[pipeIndex].name:
			leak.rotate_y(deg_to_rad(180))
		elif "Back" in pipes[pipeIndex].name:
			selector = Vector3(0,0,1)
			leak.rotate_y(deg_to_rad(90))
		
		leak.global_transform.origin = (pipes[pipeIndex].global_transform.origin - (pipes[pipeIndex].get_scale().x * (selector * 0.5))) + (randf_range(0, pipes[pipeIndex].get_scale().x) * selector)


func FillWater(delta):
	waterlevel += fillSpeed * delta
