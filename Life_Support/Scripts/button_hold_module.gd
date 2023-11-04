extends Node2D
## decay per second of 100
@export var decay_speed = 1
## charge per second of 100
@export var charge_speed = 2
var progress: float = 0.
var button: Button = null
var progress_bar: ProgressBar = null
var button_is_down = false


# Called when the node enters the scene tree for the first time.
func _ready():
	button = get_node("Button")
	progress_bar = get_node("ProgressBar")
	button.button_down.connect(Button_down)
	button.button_up.connect(Button_up)


func Button_down():
	button_is_down = true


func Button_up():
	button_is_down = false


func _process(delta):
	if button_is_down:
		progress += delta * charge_speed
	else:
		progress -= delta * decay_speed
	progress = clamp(progress, 0, 100)
	progress_bar.value = progress
	if progress == 100:
		print("Button is fully charged!")
