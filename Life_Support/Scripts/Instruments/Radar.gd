extends Node3D


var speed = 1.5
var highlightTime = 2

var monsterSpeedRange = [0.015, 0.04]
var monsterSpeed
var monsterCurrSpeed = monsterSpeed

var timer = 0
var monsterDir = false;

var spawnPoints = [0.70, -0.70]

var spinner
var monster
var monsterClone
var path
var follow

@onready var siren_module = $"/root/MainScene/EventManager/SirenModule"

signal ship_damage


func _ready():
	siren_module._module_fixed.connect(OnSiren)
	spinner = get_node("Spinner")
	monsterClone = get_node("MonsterClone")

	path = get_node("Path")
	follow = get_node("Path/Follow")
	monster = get_node("Path/Follow/Monster")
	monster.visible = false;
	GenerateMonster()




func _process(delta):
	Radar(delta)
	Monster(delta)




func Radar(delta):
	spinner.rotate_y(delta * speed)

	if (timer > 0):
		timer -= delta
		monsterClone.visible = true
	else:
		monsterClone.visible = false;


func Monster(delta):
	follow.progress_ratio = follow.progress_ratio + monsterCurrSpeed * delta

	if (follow.progress_ratio <= 0):
		GenerateMonster()


func GenerateMonster():
	follow.progress_ratio = 0.01

	monsterSpeed = randf_range(monsterSpeedRange[0], monsterSpeedRange[1])
	monsterCurrSpeed = monsterSpeed

	path.curve.clear_points()

	if monsterDir:
		path.curve.add_point(Vector3(randf_range(spawnPoints[0], spawnPoints[1]), 0, spawnPoints[randi() % 2]))
	else:
		path.curve.add_point(Vector3(spawnPoints[randi() % 2], 0, randf_range(spawnPoints[0], spawnPoints[1])))

	monsterDir = !monsterDir
	path.curve.add_point(Vector3(0, 0, 0), Vector3(randf_range(0, 0.5), 0, randf_range(0, 0.5)))


	
func _on_monster_area_area_entered(area:Area3D):
	if (area.name == "NeedleArea"):
		monsterClone.global_transform.origin = monster.global_transform.origin
		timer = highlightTime
		if monsterCurrSpeed >= 0 && !siren_module.is_broken():
			siren_module.break_module()
		$"../../AudioPlayer/SFXSonar".play()
		
	if (area.name == "NeedleHolderArea"):
		emit_signal("ship_damage")
		monsterCurrSpeed = -monsterSpeed
		siren_module.fix_module(true)
		$"../../AudioPlayer/SFXShipDamage".play()

func OnSiren():
	monsterCurrSpeed = -monsterSpeed
	$"../../AudioPlayer/SFXScareMonster".play()

