extends Node

enum gamestate { menu, playing, paused, failed }

signal state_changed(old_state: gamestate, new_state: gamestate)

var _state: gamestate = gamestate.menu
var player = null

func change_state(state: gamestate):
	state_changed.emit(state, _state)

func disable_player():
	if player != null:
		player.disable()
	else:
		# print_debug("player is null")
		push_error("player is null")

func enable_player():
	if player != null:
		player.enable()
	else:
		# print_debug("player is null")
		push_error("player is null")