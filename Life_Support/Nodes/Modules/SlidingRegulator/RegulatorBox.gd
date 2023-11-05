extends Node2D
@onready var _children = get_node("CanvasLayer/MarginContainer/HBoxContainer").get_children()
var _value_targets = []
var _correctness = []

signal finish
signal failed
signal cancel

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(len(_children)):
		_children[x].get_node("SliderMarginCont/VSlider").value_changed.connect(
			func(value): process_slider(x, value)
		)
	roll_values()


func roll_values():
	_correctness = []
	_value_targets = []
	for x in range(len(_children)):
		var target_val = randf_range(0, 100)
		_value_targets.append(target_val)
		_correctness.append(false)
		var container = _children[x].get_node("MarginContainer") as MarginContainer
		container.add_theme_constant_override("margin_top", (1 - (target_val / 100)) * 400)
		container.add_theme_constant_override("margin_bottom", (target_val / 100) * 400)
		_children[x].get_node("SliderMarginCont/VSlider").value = randf_range(0, 100)


func process_slider(id: int, value: float):
	var texture_rect = _children[id].get_node("MarginContainer/TextureRect")
	print("id: " + str(id) + " value: " + str(value) + " target: " + str(_value_targets[id]))
	if abs(_value_targets[id] - value) < 5:
		# print("correct")
		_correctness[id] = true
		texture_rect.modulate = Color(0, 1, 0)
	else:
		# print("incorrect")
		_correctness[id] = false
		texture_rect.modulate = Color(1, 0, 0)
	if is_all_correct():
		print("all correct")
		finish.emit()


func is_all_correct():
	if len(_correctness) < len(_children):
		return false
	for x in range(len(_children)):
		if not _correctness[x]:
			return false
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
