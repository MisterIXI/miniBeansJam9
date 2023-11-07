extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_area_2d_body_entered(body:Node2D):
	# print("body entered" + str(body))
	# check if body is in group "crack"
	if body.is_in_group("crack"):
		body.cover_crack()
