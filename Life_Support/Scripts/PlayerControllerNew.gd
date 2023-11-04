extends CharacterBody3D

# Reference  #
@onready var nek = $Nek
@onready var head = $Nek/Head
@onready var camera = $Nek/Head/CameraMain
# Variables  #
var current_speed  = 8.0
# States
var pstate_free_looking =false
# Movement
var lerp_speed = 10.0
var free_look_tilt_amount = 3
# Input 
var direction = Vector3.ZERO
const mouse_sens = 0.4
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Camera Movement based on Head Object with Mousecontrol
func _input(event):
	#Mouse Looking Logic
	if event is InputEventMouseMotion:
		if pstate_free_looking:
			nek.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			nek.rotation.y = clamp(nek.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	#Input from InputMap
	var input_dir = Input.get_vector("Left","Right", "Forward", "Backward")

	#Handle free looking
	if Input.is_action_pressed("free_look"):
		pstate_free_looking = true
		
		camera.rotation.z = -deg_to_rad(nek.rotation.y * free_look_tilt_amount)
	else:
		pstate_free_looking = false
		nek.rotation.y = lerp(nek.rotation.y,0.0, delta * lerp_speed)
		camera.rotation.z = lerp(camera.rotation.z,0.0, delta * lerp_speed)
	
	
	# Lerp direction #
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta *lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed

	else:	
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()

