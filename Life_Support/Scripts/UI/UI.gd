extends Control
#top of script
@onready var previous_window = DisplayServer.window_get_mode()
@onready var current_window = DisplayServer.window_get_mode()
#Vars 
var scene_setting = load("res://Nodes/UI/Settings.tscn")
var scene_credits = load("res://Nodes/UI/Credits.tscn")

var GAMEVAR_MUSIC_VOLUME = 0.5
var GAMEVAR_SOUND_VOLUME = 0.5
var GAMEVAR_MOUSE_SENSIVITY = 0.5
var GAMEVAR_INVERT = false
var GAMEVAR_ISPAUSED = false


func _on_resume_pressed():
	self.queue_free()
	# TIMESCALE  ?!
	
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Nodes/game_scene.tscn")

func _on_options_pressed():
	var instance = scene_setting.instantiate()
	add_child(instance)
	self.queue_free()

func _on_credits_pressed():
	var instance = scene_credits.instantiate()
	add_child(instance)


	
func _on_quit_pressed():
	get_tree().quit()
		
		
		
func _on_v_slider_3_mouse_s_value_changed(value:float):
	GAMEVAR_MOUSE_SENSIVITY = 100 / value


func _on_v_slider_2_sound_value_changed(value:float):
	GAMEVAR_SOUND_VOLUME = 100 / value
	
func _on_v_slider_music_value_changed(value:float):
	GAMEVAR_MUSIC_VOLUME = 100 / value



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