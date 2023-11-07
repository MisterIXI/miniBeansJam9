extends Area2D

# clickable circuit breaker, that toggles to active or inactive

@export var sprite_active: Texture2D = null
@export var sprite_inactive: Texture2D = null
@onready var sprite = get_node("Sprite2D")

signal toggled(active: bool, index: Vector2i)
var index: Vector2i
var active = true
var mouse_inside = false


func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


func _on_mouse_entered():
	mouse_inside = true


func _on_mouse_exited():
	mouse_inside = false


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_inside:
			switch(not active)


func switch(state: bool, emit = true):
	if state != active:
		active = state
		if state:
			sprite.texture = sprite_active
			get_node("/root/MainScene/AudioPlayer/SFXElectroOn").play()
		else:
			sprite.texture = sprite_inactive
			get_node("/root/MainScene/AudioPlayer/SFXElectroOff").play()
		if emit:
			toggled.emit(active, index)
