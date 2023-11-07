extends Node2D
@export var breaker_scale: float = 0.3
@export var start_offset: Vector2 = Vector2(150, 150)
@export var step_offset: Vector2 = Vector2(110, 110)
@export var rows: int = 2
@export var columns: int = 5
@onready var tutorial_note = $Tutorial_note
signal finish
signal cancel
signal failed

@export var circuit_breaker_node: PackedScene

var _breakerlist: Array = []
var isTutorial :bool = false

func _ready():
	var pos = start_offset
	for i in range(rows):
		for j in range(columns):
			var breaker = circuit_breaker_node.instantiate()
			breaker.position = pos
			pos.x += step_offset.x
			add_child(breaker)
			breaker.scale = Vector2(breaker_scale, breaker_scale)
			_breakerlist.append(breaker)
			breaker.index = Vector2(j, i)
			breaker.toggled.connect(react_to_breaker)
		pos.x = start_offset.x
		pos.y += step_offset.y
	break_random_breakers(3)


func break_random_breakers(count: int):
	var active_breakers = []
	for breaker in _breakerlist:
		if breaker.active:
			active_breakers.append(breaker)
	active_breakers.shuffle()
	for i in range(count):
		active_breakers[i].switch(false, false)


func react_to_breaker(active: bool, index: Vector2i):
	print("reacting to breaker", index, active)
	# if wrongly activated, punish player
	if not active:
		failed.emit()
		# randomly select 2 active other breakers to toggle
		var active_breakers = []
		for breaker in _breakerlist:
			if breaker.active:
				active_breakers.append(breaker)
		active_breakers.shuffle()
		if len(active_breakers) > 0:
			active_breakers[0].switch(false, false)
		if len(active_breakers) > 1:
			active_breakers[1].switch(false, false)
	else:
		# check if all breakers are active
		var all_active = true
		for breaker in _breakerlist:
			if not breaker.active:
				all_active = false
				break
		if all_active:
			finish.emit()
			print("all breakers active")


func _on_button_tutorial_pressed():
	isTutorial = !isTutorial
	if isTutorial:
		for x in _breakerlist:
			x.hide()
			tutorial_note.show()
	else:
		for x in _breakerlist:
			x.show()
			tutorial_note.hide()

func _on_button_quit_pressed():
	emit_signal("cancel")
