extends Area2D

var is_moused_over = false
var is_active = false
var mouse_pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_active:
		position = position.move_toward(mouse_pos, 1000 * delta)
		print("Changing position to: ", position)
	
	# move process
	
	

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if is_moused_over:
				print("Mouse Click at: ", event.position)
				is_active = true
		else:
			print("Mouse Unclick at: ", event.position)
			is_active = false
	elif event is InputEventMouseMotion:
		mouse_pos = event.position


	
func _on_mouse_entered():
	print("Mouse Entered")
	is_moused_over = true
		
func _on_mouse_exited():
	print("Mouse Exited")
	is_moused_over = false
