extends StaticBody2D

var is_mouse_over = false
var last_mouse_pos = Vector2()
var progress = 0.0

## progress_loss is the amount of progress lost per second
@export var progress_loss: float = 4.0
## progress_gain is the amount of progress gained per degree of rotation
@export var progress_gain: float = 0.7
@export var progress_bar: ProgressBar = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress = max(0.0, progress - (delta * progress_loss / 100.0))
	if progress_bar:
		progress_bar.value = progress * 100.0


func _input(event):
	if event is InputEventMouseMotion:
		if (event.button_mask & MOUSE_BUTTON_LEFT) == 1 && is_mouse_over:
			_drag_body(last_mouse_pos, event.position)
		last_mouse_pos = event.position


func _drag_body(drag_from: Vector2, drag_to: Vector2):
	if drag_to.distance_to(global_position) < 50:
		return
	# rotate the body to match the mouse movement relative to center point
	var intial_angle = (drag_from - global_position).angle()
	var drag_angle = (drag_to - global_position).angle()
	var delta_angle = drag_angle - intial_angle
	if rad_to_deg(delta_angle) > -50:
		rotation += delta_angle
		progress = max(0.0, min(1.0, progress + progress_gain * rad_to_deg(delta_angle) / 360.0))
		# print("delta_angle: " + str(rad_to_deg(delta_angle) / 360.0))
		print("angle: " + str(rad_to_deg(delta_angle)))


func _on_mouse_entered():
	print("mouse entered")
	is_mouse_over = true


func _on_mouse_exited():
	print("mouse exited")
	is_mouse_over = false
