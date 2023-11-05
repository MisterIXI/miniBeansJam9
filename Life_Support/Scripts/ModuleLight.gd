extends OmniLight3D
## interval in seconds in which the light will be toggled
@export var interval = 1.0

@export var activated = false
var _last_toggle = 0.0


func activate():
	activated = true
	_last_toggle = 0.0
	self.visible = true


func deactivate():
	activated = false
	self.visible = false


func _process(delta):
	if activated:
		_last_toggle += delta
		if _last_toggle >= interval:
			_last_toggle = 0.0
			self.visible = !self.visible
