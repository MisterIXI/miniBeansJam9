extends Node3D

var maxHeight = -4500
var currentHeight = -3000

var motorSpeed = 15
var sinkingSpeed = -5
var currentMotorSpeed = motorSpeed

var containerPosTop
var containerPosBot

var heightBar
var label
var container

var motorAlarmLamps
var alarmTime = 1

var timer = 0
var alarm = false

signal game_won
signal game_over

@onready var circuit_breaker = get_node("/root/MainScene/EventManager/CircuitBreaker")
var next_break_time
const BREAK_RANGE = Vector2i(30, 50)

func _ready():
	heightBar = get_node("Heightbar")
	label = get_node("HeightLabel")
	container = get_node("Container")
	containerPosTop = container.transform.origin.y + container.get_scale().y * 0.3
	containerPosBot = container.transform.origin.y - container.get_scale().y * 0.3

	motorAlarmLamps = get_node("MotorAlarmLamps")
	ToggleMotor(true)
	next_break_time = randi() % (BREAK_RANGE.y - BREAK_RANGE.x) + BREAK_RANGE.x
	circuit_breaker._module_fixed.connect(on_fix_module)



func _process(delta):
	UpdateHeightSensor(delta)
	MotorAlarm(delta)
	if next_break_time > -1 && Time.get_ticks_msec() / 1000.0 > next_break_time:
		circuit_breaker.break_module()
		ToggleMotor(false)
		next_break_time = -1
		print("Motor broke down!")

func on_fix_module():
	ToggleMotor(true)
	next_break_time = Time.get_ticks_msec() / 1000.0 + randi() % (BREAK_RANGE.y - BREAK_RANGE.x) + BREAK_RANGE.x
	print("Motor fixed!")
		

func UpdateHeightSensor(delta):
	currentHeight += currentMotorSpeed * delta

	if currentHeight <= maxHeight:
		emit_signal("game_won")
	elif currentHeight >= 0:
		emit_signal("game_over")
	else:
		var nextPos = containerPosBot + (containerPosTop - containerPosBot) * (1 - (currentHeight / maxHeight))
		heightBar.transform.origin = Vector3(heightBar.transform.origin.x , nextPos, heightBar.transform.origin.z)
		label.text = str(round(currentHeight)) + "m"



func MotorAlarm(delta):
	if currentMotorSpeed > 0:
		alarm = false
	else:
		timer += delta
		if timer >= alarmTime:
			timer = 0
			alarm = !alarm

			if alarm:
				$"../../AudioPlayer/SFXAlarm".play()
	
	motorAlarmLamps.visible = alarm



func ToggleMotor(on: bool):
	if on:
		currentMotorSpeed = motorSpeed
		$"../../AudioPlayer/SFXMotor".play()
	else:
		currentMotorSpeed = sinkingSpeed
		$"../../AudioPlayer/SFXMotor".stop()
