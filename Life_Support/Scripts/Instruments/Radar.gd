extends Node3D


var speed = 1
var highlightTime = 3

var timer = 0

var spinner
var monster

func _ready():
	spinner = get_node("Spinner")
	monster = get_node("Monster")



func _process(delta):
	spinner.rotate_y(delta * speed)

	if (timer > 0):
		timer -= delta
		monster.visible = true
	else:
		monster.visible = false;


func _on_monster_area_area_entered(area:Area3D):
	if (area.name == "NeedleArea"):
		timer = highlightTime
