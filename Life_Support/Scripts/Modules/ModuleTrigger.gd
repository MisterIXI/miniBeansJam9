extends StaticBody3D

@export var respawn_module: bool = false
@export var interaction_text: String = "Press LMB to interact"

@export var module_node: PackedScene = null
@onready var warn_light = get_node("EventLight")
@onready var collider = get_node("CollisionShape3D")

signal _module_fixed
signal _module_broken

@onready var game_manager = get_node("/root/GameManager")
var active_module = null


func _ready():
	if !respawn_module:
		collider.disabled = false
		active_module = module_node.instantiate()
		add_child(active_module)
		active_module.visible = false


func break_module():
	_module_broken.emit()
	warn_light.activate()
	if respawn_module:
		collider.disabled = false


func fix_module():
	_module_fixed.emit()
	warn_light.deactivate()
	if respawn_module:
		collider.disabled = true


func _finish():
	disconnect_signals()
	fix_module()
	game_manager.enable_player()
	if respawn_module:
		active_module.queue_free()
		active_module = null
	else:
		active_module.visible = false


func _cancel():
	disconnect_signals()
	game_manager.enable_player()
	if respawn_module:
		active_module.queue_free()
		active_module = null
	else:
		active_module.visible = false


func _failed():
	# when module resets due to user error
	# play sound
	pass


func interact():
	if respawn_module:
		if active_module == null:
			game_manager.disable_player()
			active_module = module_node.instantiate()
			add_child(active_module)
			connect_signals()
	else:
		if active_module.visible == false:
			game_manager.disable_player()
			active_module.visible = true
			connect_signals()


func connect_signals():
	active_module.finish.connect(_finish)
	active_module.cancel.connect(_cancel)
	active_module.failed.connect(_failed)


func disconnect_signals():
	active_module.finish.disconnect(_finish)
	active_module.cancel.disconnect(_cancel)
	active_module.failed.disconnect(_failed)