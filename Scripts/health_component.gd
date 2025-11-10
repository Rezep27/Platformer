extends Node


@export var max_health : float = 100
var current_health = max_health
var is_dead : bool = false

signal entity_dies

func apply_damage(damage : int):
	if !is_dead:
		current_health -= damage
		print("Current health on health component is " + str(current_health))
		if current_health <= 0:
			die()

func die():
	is_dead = true
	entity_dies.emit()
	
