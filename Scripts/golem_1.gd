extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health : float = 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func apply_damage(damage : float):
	health -= damage
	print("Current health is " + str(health))
