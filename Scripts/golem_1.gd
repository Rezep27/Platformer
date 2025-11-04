extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health : float = 100

@onready var animation_tree : AnimationTree = $AnimationTree

func _process(delta: float) -> void:
	check_animation()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
func check_animation():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
func apply_damage(damage : float):
	health -= damage
	animation_tree["parameters/conditions/hurt"] = true
	print("Current health is " + str(health))

func set_animation_state_false(animationName : String):
		animation_tree["parameters/conditions/" + animationName] = false
