extends Node3D


var shipDamage
var pos = 1

func _ready():
	shipDamage = get_node("/root/MainScene/Instruments/ShipDamage")
	$SFXWaterLeak.play()



func _process(delta):
	shipDamage.FillWater(delta)


func _exit_tree():
	$SFXWaterLeak.stop()
