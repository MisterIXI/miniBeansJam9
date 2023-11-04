extends CharacterBody3D

# Variables  #
var vel = Vector3()
const MAX_SPEED = 20
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL = 16
const MAX_SLOPE_ANGLE  = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY =0.05


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $CameraMain
	rotation_helper = $RotationHelper

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	HandleMovement(delta)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		self.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x  = clamp(camera_rot.x, -70, 70)
		
		rotation_helper.rotation_degrees = camera_rot

func HandleMovement(delta):
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Input.get_vector("Left","Right","Backward", "Forward")

	# Basic vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	dir.y =0
	dir = dir.normalized()

	#Velocity
	var hvel = vel
	var target = dir
	target *= MAX_SPEED
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.lerp(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	velocity.y = 0
	move_and_slide()
	
	

