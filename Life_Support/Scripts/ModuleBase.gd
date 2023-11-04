extends Node

signal _module_fixed
signal _module_broken



func break_module():
	_module_broken.emit()


func fix_module():
	_module_fixed.emit()


func _process(delta):
	pass
