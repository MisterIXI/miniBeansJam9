extends Node3D


var lamps

func _ready():
	lamps = get_node("Light")



func ToggleLight(on: bool):
	lamps.set_deferred("visible", on)

	if on:
		$"../../AudioPlayer/SFXElectroOn".play()
	else:
		$"../../AudioPlayer/SFXElectroOff".play()
