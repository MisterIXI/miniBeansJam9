extends CharacterBody3D

# Reference  #
@onready var nek = $Nek
@onready var head = $Nek/Head
@onready var camera = $Nek/Head/CameraMain

@onready var ray = $Nek/Head/CameraMain/ObjectUI_Raycast
@onready var info_text = $Nek/Head/CameraMain/ObjectUI_Raycast/InfoText

# Variables  #
var current_speed = 8.0
# States
var pstate_free_looking = false
# Movement
var lerp_speed = 10.0
var free_look_tilt_amount = 3
# Input
var direction = Vector3.ZERO
const mouse_sens = 0.4

var interaction_target = null
var is_reacting_to_input = true


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("/root/GameManager").player = self


func _exit_tree():
	var gm = get_node("/root/GameManager")
	if gm.player == self:
		gm.player = null


func disable():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	is_reacting_to_input = false
	interaction_target = null


func enable():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_reacting_to_input = true
	# fix first frame click
	interaction_target = null


# Camera Movement based on Head Object with Mousecontrol
func _input(event):
	if not is_reacting_to_input:
		return
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
	if event is InputEventMouseButton and event.button_mask & MOUSE_BUTTON_LEFT:
		if interaction_target:
			interaction_target.interact()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_reacting_to_input:
		return
	#Input from InputMap
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")

	#Handle free looking
	if Input.is_action_pressed("free_look"):
		pstate_free_looking = true

		camera.rotation.z = -deg_to_rad(nek.rotation.y * free_look_tilt_amount)
	else:
		pstate_free_looking = false
		nek.rotation.y = lerp(nek.rotation.y, 0.0, delta * lerp_speed)
		camera.rotation.z = lerp(camera.rotation.z, 0.0, delta * lerp_speed)

	# Lerp direction #
	direction = lerp(
		direction,
		(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
		delta * lerp_speed
	)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed

	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# input raycast
	var raycast = ray.get_collider()
	if raycast && raycast.is_in_group("Interactable"):
		# info_text.text = raycast.name
		info_text.text = raycast.interaction_text
		interaction_target = raycast
	else:
		info_text.text = ""
		interaction_target = null
	move_and_slide()
