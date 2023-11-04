extends "res://Scripts/ModuleBase.gd"

@export var duct_tape_node: PackedScene = null
@export var crack_node: PackedScene = null
@export var tape_width: int = 150

var _dragging_tape: bool = false
var _tape: Node = null
var _tape_start_pos: Vector2 = Vector2.ZERO

const TAPE_OFFSET = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func create_cracks(count: int):
	var viewport_size = get_viewport()
	
	pass


func _input(event):
	if event is InputEventMouse:
		# print("mouse event: " + str(event))
		# print(event.button_mask)
		# start dragging
		if event.is_pressed() and (event.button_mask & MOUSE_BUTTON_LEFT) == 1:
			__start_dragging_tape(event)
		# stop dragging
		elif (event.button_mask & MOUSE_BUTTON_LEFT) == 0:
			if _dragging_tape:
				__stop_dragging_tape(event)
		# dragging
		if (event is InputEventMouseMotion) and _dragging_tape:
			__process_dragging_tape(event)
			# pass


func __start_dragging_tape(event):
	# spawn a new tape
	# print("start dragging")
	_tape = duct_tape_node.instantiate()
	_tape_start_pos = event.position
	_tape.position = _tape_start_pos - Vector2(TAPE_OFFSET, tape_width / 2.0)
	_tape.size.x = 100
	_tape.size.y = tape_width
	_tape.pivot_offset = Vector2(TAPE_OFFSET, tape_width / 2.0)
	add_child(_tape)
	_dragging_tape = true


func __stop_dragging_tape(event):
	# print("stop dragging")
	# activate collider of tape and adjust size
	var collider = _tape.get_node("Area2D/Collider")
	collider.set_deferred("disabled", false)
	var length = (_tape_start_pos - event.position).length() + TAPE_OFFSET
	# collider.position = Vector2(length/2.0, tape_width/2.0)
	# collider.size = Vector2(length, tape_width)
	collider.position = Vector2(length/2.0 + TAPE_OFFSET/2.0, tape_width/2.0)
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(length/2.0, tape_width/2.0)
	collider.shape = rect_shape
	_tape = null
	_dragging_tape = false


func __process_dragging_tape(event):
	# print("dragging: " + str(event.position))
	# calculate angle and length
	var angle = (event.position- _tape_start_pos).angle()
	var length = (_tape_start_pos - event.position).length()
	length += TAPE_OFFSET*2
	# set angle and length
	_tape.rotation = angle
	_tape.size.x = length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
