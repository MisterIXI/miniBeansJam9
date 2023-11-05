extends Node3D
@onready var circuit_breaker = get_node("CircuitBreaker")
func _ready():
	circuit_breaker.break_module()
