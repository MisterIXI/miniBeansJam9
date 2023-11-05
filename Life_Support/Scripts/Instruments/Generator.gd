extends Node3D


var lamps

func _ready():
	lamps = get_node("Light")



func ToggleLight(on: bool):
	lamps.visible = on