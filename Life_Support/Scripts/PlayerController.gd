extends CharacterBody3D

# Reference  #
@onready var head = $Head

# Variables  #
var current_speed  = 5.0

const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0

const jump_velocity = 4.5

const mouse_sens = 0.4

var lerp_speed = 10.0

var direction = Vector3.ZERO

var crouching_depth = -0.5

#Get the gravity from the project settings to be synced with Rigidbody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta):

	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = 0.595 - crouching_depth
	else:
		head.position.y = 0.595
		if(Input.is_action_pressed("sprint")):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	#Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("Left","Right", "Forward", "Backward")
	# Lerp direction #

	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta *lerp_speed)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
