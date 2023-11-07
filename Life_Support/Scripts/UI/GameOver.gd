extends Control
@onready var losePanel: Control = $Lose
@onready var winPanel: Control = $Win

#TEXTURE WIN
#TEXT WIN, LOSE
@onready var winTexture: TextureRect = $Win/TextureRect
@onready var winText: Label = $Win/WinText
@onready var loseText: Label = $Lose/LoseText
signal cancel
var image = Image.load_from_file("res://Assets/Textures/UI/Win_Star_01.png")
var winStart01 = ImageTexture.create_from_image(image)

var image2 = Image.load_from_file("res://Assets/Textures/UI/Win_Star_02.png")
var winStart02 = ImageTexture.create_from_image(image2)

var image3 = Image.load_from_file("res://Assets/Textures/UI/Win_Star_03.png")
var winStart03 = ImageTexture.create_from_image(image3)

var image4 = Image.load_from_file("res://Assets/Textures/UI/Win_Star_00.png")
var winStart04 = ImageTexture.create_from_image(image4)


func _ready():
	winPanel.hide()
	losePanel.hide()
	


func OnGameover(value: bool, loseInfoText : String=""):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	self.visible = true
	emit_signal("cancel")
	if value:
		winPanel.show()
		losePanel.hide()
		var event = get_node("/root/MainScene/EventManager")
		var crewmember_alive = 0
		if event.get_node("RegulatorModule").life_pod_val > 0:
			crewmember_alive += 1
		if event.get_node("CodeModule").life_pod_val > 0:
			crewmember_alive += 1
		if event.get_node("HoldButtonModule").life_pod_val > 0:
			crewmember_alive += 1
		print(crewmember_alive)

		if crewmember_alive == 0:
			winText.text = "You saved no one"
			winTexture.texture = winStart04
		elif crewmember_alive == 1:
			winText.text = "You saved one crew member"
			winTexture.texture = winStart01
		elif crewmember_alive == 2:
			winText.text = "You saved two crew members"
			winTexture.texture = winStart02
		elif crewmember_alive == 3:
			winText.text = "You saved all crew members"
			winTexture.texture = winStart03
	else:
		winPanel.hide()
		losePanel.show()
		loseText.text  = loseInfoText
	var parent = get_parent()
	parent.visible = true


func _onButtonClick():
	winPanel.hide()
	losePanel.hide()
	get_tree().paused = false
	self.visible = false
	get_tree().change_scene_to_file("res://Nodes/FinalMenuScene.tscn")
