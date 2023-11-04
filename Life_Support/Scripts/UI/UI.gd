extends Control
#top of script
@onready var previous_window = DisplayServer.window_get_mode()
@onready var current_window = DisplayServer.window_get_mode()
# MENUES
@onready var hmenuPanel = $HMenu
@onready var hsettingPanel = $SettingMenu
@onready var hcreditPanel = $CreditMenu
# BUTTONS AND SLIDERS
@onready var button_Start : Button  = $HMenu/MarginContainer/VBoxContainer/Button_Start
@onready var button_Settings : Button  = $HMenu/MarginContainer/VBoxContainer/Button_Settings
@onready var button_Credits : Button  = $HMenu/MarginContainer/VBoxContainer/Button_Credits
@onready var button_Quit : Button = $HMenu/MarginContainer/VBoxContainer/Button_Quit

#Vars 
var GAMEVAR_MUSIC_VOLUME = 0.5
var GAMEVAR_SOUND_VOLUME = 0.5
var GAMEVAR_MOUSE_SENSIVITY = 0.5
var GAMEVAR_INVERT = false
var GAMEVAR_ISPAUSED = false


func _ready():
	button_Start.connect("pressed", self._on_play_pressed)
	button_Settings.connect("pressed",self._on_options_pressed)
	button_Credits.connect("pressed", self._on_credits_pressed) 
	button_Quit.connect("pressed", self._on_quit_pressed)

func _on_resume_pressed():
	ShowNode(self,false)
	print("RESUME")
	# TIMESCALE  ?!
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Nodes/game_scene.tscn")
	ShowNode(self,false)
	print("PLAY")

func _on_options_pressed():
	ShowNode(hsettingPanel,true)
	ShowNode(hcreditPanel,false)
	print("SETTINGS")
	

func _on_credits_pressed():
	ShowNode(hsettingPanel,false)
	ShowNode(hcreditPanel,true)
	print("CREDITS")
	


	
func _on_quit_pressed():
	get_tree().quit()
		
		
		
func _on_v_slider_3_mouse_s_value_changed(value:float):
	GAMEVAR_MOUSE_SENSIVITY = 100 / value
	print (GAMEVAR_MOUSE_SENSIVITY)

func _on_v_slider_2_sound_value_changed(value:float):
	GAMEVAR_SOUND_VOLUME = 100 / value
	print (GAMEVAR_SOUND_VOLUME)
	
func _on_v_slider_music_value_changed(value:float):
	GAMEVAR_MUSIC_VOLUME = 100 / value
	print (GAMEVAR_MUSIC_VOLUME)



func _on_check_box_2_screen_toggled(button_pressed:bool):
	
	current_window = DisplayServer.window_get_mode()
	if current_window != 4 && button_pressed:
		previous_window = current_window
		DisplayServer.window_set_mode(4)
	else:
		if previous_window == 4:
			previous_window = 2
		DisplayServer.window_set_mode(previous_window)

func _on_check_box_invert_toggled(button_pressed:bool):
	GAMEVAR_INVERT = button_pressed
	print(GAMEVAR_INVERT)

func ShowNode(node:Node, value: bool) -> void:
	node.visible = !value
	
