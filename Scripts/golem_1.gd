extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_in_attack_range : bool = false


@onready var animation_tree : AnimationTree = $AnimationTree
@onready var health_component : Node = $HealthComponent

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
	animation_tree["parameters/conditions/hurt"] = true
	$HealthComponent.apply_damage(damage)

func set_animation_state_false(animationName : String):
		animation_tree["parameters/conditions/" + animationName] = false

func on_entity_death():
	animation_tree["parameters/conditions/die"] = true

func delete_enemy():
	queue_free()
	
func attack():
	animation_tree["parameters/conditions/attack"] = true



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
