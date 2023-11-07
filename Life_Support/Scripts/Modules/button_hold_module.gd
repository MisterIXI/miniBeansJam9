extends Node2D
## charge per second of 100
@export var charge_speed = 2
var progress: float = 0.
var button: Button = null
var progress_bar: ProgressBar = null
var button_is_down = false
@onready var parent = get_parent()
@onready var tutorial_note = $Tutorial_note
signal finish
signal failed
signal cancel
var isTutorial:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	button = get_node("Button")
	progress_bar = get_node("ProgressBar")
	button.button_down.connect(Button_down)
	button.button_up.connect(Button_up)
		
	


func Button_down():
	button_is_down = true
	get_node("/root/MainScene/AudioPlayer/SFXHold").play()

func Button_up():
	button_is_down = false
	get_node("/root/MainScene/AudioPlayer/SFXHold").stop()

func _process(delta):
	if button_is_down:
		parent.life_pod_val += delta * charge_speed
	parent.life_pod_val = clamp(parent.life_pod_val, 0, 100)
	progress_bar.value = parent.life_pod_val
	

func _on_button_tutorial_pressed():
	isTutorial = !isTutorial
	if isTutorial:
		
		tutorial_note.show()
	else:
		
		tutorial_note.hide()


func _on_button_quit_pressed():
	emit_signal("cancel")
	print("cancel")
