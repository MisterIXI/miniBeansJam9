extends Control
@onready var loosePanel:Control = $Lose
@onready var winPanel:Control = $Win


func _ready():
	winPanel.hide()
	loosePanel.hide()

func OnGameover(value: bool):
	if value:
		winPanel.show()
		loosePanel.hide()
	else:
		winPanel.hide()
		loosePanel.show()
func _onButtonClick():
	winPanel.hide()
	loosePanel.hide()
	get_tree().change_scene_to_file("res://Nodes/FinalMenuScene.tscn")