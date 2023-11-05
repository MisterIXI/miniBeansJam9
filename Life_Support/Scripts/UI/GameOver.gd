extends Control
@onready var loosePanel:Control = $Lose
@onready var winPanel:Control = $Win

#TEXTURE WIN
#TEXT WIN, LOSE
@onready var winTexture:TextureRect =$Win/TextureRect
@onready var winText: Label = $Win/WinText
@onready var loseText: Label = $Lose/LoseText

var image = Image.load_from_file("res://Assets/Textures/UI/Win_Star_01.png")
var winStart01 = ImageTexture.create_from_image(image)

var image2 = Image.load_from_file("res://Assets/Textures/UI/Win_Star_02.png")
var winStart02 = ImageTexture.create_from_image(image2)

var image3 = Image.load_from_file("res://Assets/Textures/UI/Win_Star_03.png")
var winStart03 = ImageTexture.create_from_image(image3)
func _ready():
	winPanel.hide()
	loosePanel.hide()

func OnGameover(value: bool, crewMember: int):
	if value:
		winPanel.show()
		loosePanel.hide()
		if crewMember ==1:
			winTexture.texture =winStart01
		if crewMember ==2:
			winTexture.texture =winStart02
		if crewMember ==3:
			winTexture.texture =winStart03	
	else:
		winPanel.hide()
		loosePanel.show()
func _onButtonClick():
	winPanel.hide()
	loosePanel.hide()
	get_tree().change_scene_to_file("res://Nodes/FinalMenuScene.tscn")