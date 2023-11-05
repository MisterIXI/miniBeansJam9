extends Node3D
## interval in seconds in which the light will be toggled
@export var interval = 1.0

@export var activated = false
var _last_toggle = 0.0

@onready var _light = get_node("OmniLight3D")

func activate():
	activated = true
	_last_toggle = 0.0
	_light.visible = true


func deactivate():
	activated = false
	_light.visible = false


func _process(delta):
	if activated:
		_last_toggle += delta
		if _last_toggle >= interval:
			_last_toggle = 0.0
			_light.visible = !_light.visible
