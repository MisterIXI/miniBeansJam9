extends Node3D


var shipDamage

func _ready():
	shipDamage = get_node("/root/OliScene/ShipDamage")



func _process(delta):
	shipDamage.FillWater(delta)
