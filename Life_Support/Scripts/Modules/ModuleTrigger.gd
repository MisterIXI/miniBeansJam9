extends StaticBody3D

@export var life_pod_decay: float = 2.0
@export var life_pod: int = 0
@export var is_waterleak: bool = false
@export var respawn_module: bool = false
@export var interaction_text: String = "Press LMB to interact"

@export var module_node: PackedScene = null
@onready var warn_light = get_node("EventLight")
@onready var collider = get_node("CollisionShape3D")

@onready var game_over = get_node("/root/MainScene/Global_UI/GameOver")

signal _module_fixed
signal _module_broken

@onready var game_manager = get_node("/root/GameManager")
var active_module = null
@onready var life_pod_node: MeshInstance3D = get_node("/root/MainScene/Submarine/LifepodSingle")
var life_pod_val = 100
var life_pod_mats = []
var test: MeshInstance3D = null
var lifepod_dead = false


func _ready():
	if !respawn_module:
		collider.set_deferred("disabled", false)
		# collider.disabled = false
		active_module = module_node.instantiate()
		add_child(active_module)
		active_module.visible = false
	if is_waterleak:
		break_module()
	collider.name = "cooler_collider"
	if life_pod:
		var panel = life_pod_node.get_node("Panelslot" + str(life_pod) + "/Node3D/Panel")
		for i in range(1, 6):
			life_pod_mats.append(panel.get_surface_override_material(i))
		break_module()


func _process(delta):
	if life_pod:
		life_pod_val -= life_pod_decay * delta
		for i in range(5):
			var offset = i * 20
			var val = clamp(life_pod_val, offset, offset + 20) - offset
			val = 0.3 - val / 20 * 0.3
			life_pod_mats[i].set("uv1_offset", Vector3(0, -val, 0))
		if life_pod_val <= 0:
			life_pod_val = 0
			life_pod = 0
			interaction_text = "Life support offline - Inhabitant dead"
			lifepod_dead = true


func break_module():
	print("Breaking module")
	_module_broken.emit()
	if warn_light:
		warn_light.activate()
	if respawn_module:
		collider.set_deferred("disabled", false)
		print("Enabling collider")


func fix_module(suppress_signal = false):
	if !suppress_signal:
		_module_fixed.emit()
	if warn_light:
		warn_light.deactivate()
	if respawn_module:
		collider.set_deferred("disabled", true)


func is_broken():
	return !collider.disabled


func _finish():
	disconnect_signals()
	fix_module()
	game_manager.enable_player()
	if respawn_module:
		active_module.queue_free()
		active_module = null
	else:
		active_module.visible = false
	if is_waterleak:
		get_parent().queue_free()
	if life_pod:
		life_pod_val = min(100, life_pod_val + 100)
		break_module()


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
	if lifepod_dead:
		return
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
	game_over.cancel.connect(_cancel)


func disconnect_signals():
	active_module.finish.disconnect(_finish)
	active_module.cancel.disconnect(_cancel)
	active_module.failed.disconnect(_failed)
	game_over.cancel.disconnect(_cancel)
