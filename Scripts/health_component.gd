extends Node


@export var max_health : float = 100
var current_health = max_health
var animation_tree : AnimationTree
func _ready() -> void:
	animation_tree = get_parent().get("AnimationTree")
	
func apply_damage(damage : int):
	current_health -= damage
	animation_tree["parameters/conditions/hurt"] = true
	print("Current health is " + str(current_health))
