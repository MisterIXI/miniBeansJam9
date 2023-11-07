extends CharacterBody3D

# Reference  #
@onready var nek = $Nek
@onready var head = $Nek/Head
@onready var camera = $Nek/Head/Eyes/CameraMain

@onready var ray = $Nek/Head/Eyes/CameraMain/ObjectUI_Raycast
@onready var info_text = $Nek/Head/Eyes/CameraMain/ObjectUI_Raycast/InfoText
@onready var eyes = $Nek/Head/Eyes
# Variables  #
@export var current_speed = 4
# States
var pstate_free_looking = false
# Movement
var lerp_speed = 10
var free_look_tilt_amount = 3
# Input
var direction = Vector3.ZERO
const mouse_sens = 0.3

var interaction_target = null
var is_reacting_to_input = true
#Head bobbing
const head_bobbing_speed = 14.0
const head_bobbing_intensity = 0.05
var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity =0.0

var stepLeft = true
var leftFoot
var rightFoot
var stepsounds = [preload("res://Assets/SFX/Steps/Schritt_1_Hall.mp3"),  
				preload("res://Assets/SFX/Steps/Schritt_2_Hall.mp3"), 
				preload("res://Assets/SFX/Steps/Schritt_3_Hall.mp3"),
				preload("res://Assets/SFX/Steps/Schritt_4_Hall.mp3"),
				preload("res://Assets/SFX/Steps/Schritt_5_Hall.mp3"),
				preload("res://Assets/SFX/Steps/Schritt_6_Hall.mp3")]


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("/root/GameManager").player = self
	
	leftFoot = $Nek/Head/Eyes/CameraMain/SFXFootstepLeft
	rightFoot = $Nek/Head/Eyes/CameraMain/SFXFootstepRight


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
		get_node("../Global_UI").set_deferred("visible", true)
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
	#Handle Headbob
	head_bobbing_current_intensity = head_bobbing_intensity
	head_bobbing_index += head_bobbing_speed * delta
	if is_on_floor() && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2)+0.5
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y*(head_bobbing_current_intensity/2.0),delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x*head_bobbing_current_intensity,delta * lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerp_speed)
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



	
	var stepsound = stepsounds[randi_range(0, stepsounds.size() - 1)]

	if stepLeft:
		if eyes.position.x >= 0.0005:
			rightFoot.stream = stepsound
			rightFoot.play()
			stepLeft = false
	else:
		if eyes.position.x <= -0.005:
			rightFoot.stream = stepsound
			leftFoot.play()
			stepLeft = true
