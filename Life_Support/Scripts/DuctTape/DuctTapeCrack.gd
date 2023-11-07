extends StaticBody2D

var is_covered = false
signal crack_covered
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func cover_crack():
	if !is_covered:
		is_covered = true
		print("I just covered a crack!")
		emit_signal("crack_covered")
		get_node("WaterParticles").set_emitting(false)

		

