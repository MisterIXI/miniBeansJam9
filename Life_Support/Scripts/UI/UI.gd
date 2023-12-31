extends Control
#top of script
@onready var previous_window = DisplayServer.window_get_mode()
@onready var current_window = DisplayServer.window_get_mode()
# MENUES
@onready var hmenuPanel = $HMenu
@onready var hsettingPanel = $SettingMenu
@onready var hcreditPanel = $CreditMenu
# BUTTONS AND SLIDERS
@onready var button_Start: Button = $HMenu/MarginContainer/VBoxContainer/Button_Start
@onready var button_Settings: Button = $HMenu/MarginContainer/VBoxContainer/Button_Settings
@onready var button_Credits: Button = $HMenu/MarginContainer/VBoxContainer/Button_Credits
@onready var button_Quit: Button = $HMenu/MarginContainer/VBoxContainer/Button_Quit
@onready var button_Resume: Button = $HMenu/MarginContainer/VBoxContainer/Button_Resume
#Vars
var GAMEVAR_MUSIC_VOLUME = 0.5
var GAMEVAR_SOUND_VOLUME = 0.5
var GAMEVAR_MOUSE_SENSIVITY = 0.5
var GAMEVAR_INVERT = false
var GAMEVAR_ISPAUSED = false

var _music
var _sfx


func _ready():
	button_Resume.connect("pressed", self._on_resume_pressed)
	if get_parent().name == "MainScene":
		button_Start.connect("pressed", self._on_resume_pressed)
		button_Resume.show()
		button_Start.hide()
	else:
		button_Start.connect("pressed", self._on_play_pressed)
		button_Resume.hide()
		button_Start.show()
	button_Settings.connect("pressed", self._on_options_pressed)
	button_Credits.connect("pressed", self._on_credits_pressed)
	button_Quit.connect("pressed", self._on_quit_pressed)
	_music = AudioServer.get_bus_index("Music")
	_sfx = AudioServer.get_bus_index("SFX")


func _on_resume_pressed():
	ShowNode(self, false)
	print("RESUME")
	# TIMESCALE  ?!
	get_tree().paused = false
	# capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Nodes/main_scene.tscn")
	ShowNode(self, false)
	print("PLAY")


func _on_options_pressed():
	ShowNode(hsettingPanel, true)
	ShowNode(hcreditPanel, false)
	print("SETTINGS")


func _on_credits_pressed():
	ShowNode(hsettingPanel, false)
	ShowNode(hcreditPanel, true)
	print("CREDITS")


func _on_quit_pressed():
	get_tree().quit()


func _on_v_slider_3_mouse_s_value_changed(value: float):
	GAMEVAR_MOUSE_SENSIVITY = value / 100
	print(GAMEVAR_MOUSE_SENSIVITY)


func _on_v_slider_2_sound_value_changed(value: float):
	GAMEVAR_SOUND_VOLUME = value / 100
	print(GAMEVAR_SOUND_VOLUME)
	AudioServer.set_bus_volume_db(_sfx, linear_to_db(GAMEVAR_SOUND_VOLUME))


func _on_v_slider_music_value_changed(value: float):
	GAMEVAR_MUSIC_VOLUME = value / 100
	print(GAMEVAR_MUSIC_VOLUME)
	AudioServer.set_bus_volume_db(_music, linear_to_db(GAMEVAR_MUSIC_VOLUME))


func _on_check_box_2_screen_toggled(button_pressed: bool):
	current_window = DisplayServer.window_get_mode()
	if current_window != 4 && button_pressed:
		previous_window = current_window
		DisplayServer.window_set_mode(4)
	else:
		if previous_window == 4:
			previous_window = 2
		DisplayServer.window_set_mode(previous_window)


func _on_check_box_invert_toggled(button_pressed: bool):
	GAMEVAR_INVERT = button_pressed
	print(GAMEVAR_INVERT)


func ShowNode(node: Node, value: bool) -> void:
	node.visible = value
