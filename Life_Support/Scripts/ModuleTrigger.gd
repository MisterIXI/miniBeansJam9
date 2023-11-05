extends StaticBody3D

@export var interaction_text: String = "Press LMB to interact"

@export var module_node: PackedScene = null
@onready var warn_light = get_node("WarnLight")
@onready var collider = get_node("CollisionShape3D")

signal _module_fixed
signal _module_broken

@onready var game_manager = get_node("/root/GameManager")
var active_module = null


func break_module():
	_module_broken.emit()
	warn_light.activate()
	collider.disabled = false


func fix_module():
	_module_fixed.emit()
	warn_light.deactivate()
	collider.disabled = true


func _finish():
	disconnect_signals()
	fix_module()
	game_manager.enable_player()
	active_module.queue_free()
	active_module = null


func _cancel():
	disconnect_signals()
	game_manager.enable_player()
	active_module.queue_free()
	active_module = null


func _failed():
	# when module resets due to user error
	# play sound
	pass


func interact():
	if active_module == null:
		game_manager.disable_player()
		active_module = module_node.instantiate()
		add_child(active_module)
		connect_signals()


func connect_signals():
	active_module.finish.connect(_finish)
	active_module.cancel.connect(_cancel)
	active_module.failed.connect(_failed)


func disconnect_signals():
	active_module.finish.disconnect(_finish)
	active_module.cancel.disconnect(_cancel)
	active_module.failed.disconnect(_failed)
