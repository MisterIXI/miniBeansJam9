extends Node2D

@onready var _container = get_node("GridContainer")
@onready var tutorial_note = $Tutorial_note
var _children = []
var _current = 0

signal finish
signal cancel
signal failed
var isTutorial: bool  = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_children = _container.get_children()
	for x in range(len(_children)):
		_children[x].pressed.connect(func(): on_click(x + 1))
	reshuffle()


func reshuffle():
	# clear children
	for child in _children:
		_container.remove_child(child)
	# shuffle children
	_children.shuffle()
	# re add children
	for child in _children:
		_container.add_child(child)
		child.disabled = false
	_current = 0


func hide_button(id: int):
	for child in _children:
		if child.text == str(id):
			child.disabled = true
			break


func on_click(id: int):
	if id == _current + 1:
		# on correct press
		hide_button(id)
		_current += 1
		if _current == len(_children):
			finish.emit()
			reshuffle()
	else:
		# on wrong press
		reshuffle()
		failed.emit()

func _on_button_quit_pressed():
	emit_signal("cancel")
	print("cancel")

func _on_button_tutorial_pressed():
	
	isTutorial = !isTutorial
	if isTutorial:
		_container.hide()
		tutorial_note.show()
	else:
		_container.show()
		tutorial_note.hide()
	
