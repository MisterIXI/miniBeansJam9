extends GridContainer

var _children = []
var _current = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	_children = get_children()
	for x in range(len(_children)):
		_children[x].pressed.connect(func(): on_click(x + 1))
	reshuffle()


func reshuffle():
	# clear children
	for child in _children:
		remove_child(child)
	# shuffle children
	_children.shuffle()
	# re add children
	for child in _children:
		add_child(child)
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
	else:
		# on wrong press
		reshuffle()
