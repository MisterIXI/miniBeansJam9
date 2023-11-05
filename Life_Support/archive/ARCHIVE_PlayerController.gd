extends CharacterBody3D

# Reference  #
@onready var nek = $Nek
@onready var head = $Nek/Head
@onready var collision_stand = $CollisionShape_stand
@onready var collision_crouch = $CollisionShape_crouch
@onready var crouching_raycast = $CrouchRayCast
@onready var camera = $Nek/Head/CameraMain

# Variables  #
var current_speed  = 7.0
const walking_speed = 7.0
const sprinting_speed = 8.0
const crouching_speed = 4.0

# States
var pstate_walking =false
var pstate_sprinting = false
var pstate_crouching = false
var pstate_free_looking =false
var pstate_sliding  = false

# Sliding
var slide_timer = 0.0
var slide_timer_max = 1.0
var slide_vector = Vector2.ZERO
var slide_speed  = 12.0

# Movement
var jump_velocity = 10
var sprinting_timer = 0.0
var lerp_speed = 10.0
var crouching_depth = -0.6
var free_look_tilt_amount = 3
# Input 
var direction = Vector3.ZERO
const mouse_sens = 0.4


#Get the gravity from the project settings to be synced with Rigidbody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func CrouchCollisionShape(crouching_state : bool):
	if crouching_state:
		collision_stand.disabled = true
		collision_crouch.disabled = false
	else:
		collision_stand.disabled = false
		collision_crouch.disabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Camera Movement based on Head Object with Mousecontrol
func _input(event):
	#Pause On Play
	if Input.is_key_pressed(KEY_ESCAPE):
		get_node("../Global_UI").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
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

	#Crouching
	if Input.is_action_pressed("crouch") || pstate_sliding:
		current_speed = crouching_speed
		# Lerp crouching
		head.position.y = lerp(head.position.y, crouching_depth, delta *lerp_speed)
		CrouchCollisionShape(true)

		if pstate_sprinting && input_dir != Vector2.ZERO:
			pstate_sliding = true
			jump_velocity = 13
			slide_timer = slide_timer_max
			slide_vector = input_dir
			pstate_free_looking = true
			
		
		pstate_sprinting = false
		pstate_crouching = true
		pstate_walking = false
		
	elif !crouching_raycast.is_colliding():
		head.position.y = lerp(head.position.y, 0.0, delta *lerp_speed)
		CrouchCollisionShape(false)
		#Sprinting
		if(Input.is_action_pressed("sprint")):
			current_speed = sprinting_speed
			sprinting_timer = 0.5
			pstate_sprinting = true
			pstate_crouching = false
			pstate_walking = false
		else:
			current_speed = walking_speed
			sprinting_timer -= delta
			if sprinting_timer <= 0:
				pstate_sprinting = false
				pstate_crouching = false
				pstate_walking = true
	#Handle free looking
	if Input.is_action_pressed("free_look") || pstate_sliding:
		pstate_free_looking = true
		
		if pstate_sliding:
			camera.rotation.z = lerp(camera.rotation.z,-deg_to_rad(7.0), delta * lerp_speed)
		else:
			camera.rotation.z = -deg_to_rad(nek.rotation.y * free_look_tilt_amount)
	else:
		pstate_free_looking = false
		nek.rotation.y = lerp(nek.rotation.y,0.0, delta * lerp_speed)
		camera.rotation.z = lerp(camera.rotation.z,0.0, delta * lerp_speed)
	
	# Sliding
	if pstate_sliding:
		slide_timer -= delta
		if slide_timer <=0:
			pstate_sliding = false
			jump_velocity = 10
			pstate_free_looking = false
			
			

	# Falling
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		pstate_sliding = false

	# Lerp direction #
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta *lerp_speed)
	
	if pstate_sliding:
		direction = (transform.basis * Vector3(slide_vector.x,0, slide_vector.y)).normalized()

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed

		if pstate_sliding:
			velocity.x = direction.x * (slide_timer +0.1) * slide_speed
			velocity.z = direction.z * (slide_timer +0.1) * slide_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()

