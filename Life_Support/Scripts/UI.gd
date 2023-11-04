extends Container

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Nodes/game_scene.tscn"

func _on_options_pressed():
	pass

func _on_credits_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()

