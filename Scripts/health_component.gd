extends Node


@export var max_health : float = 100
var current_health = max_health

signal entity_dies
	
func _ready() -> void:
	get_parent().connect_health_signals()
	
func apply_damage(damage : int):
	current_health -= damage
	print("Current health on health component is " + str(current_health))
	if current_health <= max_health:
		die()

func die():
	entity_dies.emit()
	
