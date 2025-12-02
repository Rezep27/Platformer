extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_player_in_attack_range : bool = false
var can_attack : bool = true


@onready var animation_tree : AnimationTree = $AnimationTree
@onready var health_component : Node = $HealthComponent

func _process(delta: float) -> void:
	check_animation()
	if (is_player_in_attack_range and can_attack):
		attack()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
func check_animation():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
func apply_damage(damage : float):
	$Sprite2D.start_flash()
	$HealthComponent.apply_damage(damage)

func set_animation_state_false(animationName : String):
		animation_tree["parameters/conditions/" + animationName] = false

func on_entity_death():
	animation_tree["parameters/conditions/die"] = true

func delete_enemy():
	queue_free()
	
func attack():
	animation_tree["parameters/conditions/attack"] = true
	can_attack = false
	$AttackCooldown.start()
	
#Function to set the animation state to false on the animation tree,
#so that they won't stay turned on after the animation finishes
func set_animation_state_to_false(anim_name):
	animation_tree["parameters/conditions/" + anim_name] = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	is_player_in_attack_range = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	is_player_in_attack_range = false


func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _activate_hitbox_collider(): 
	pass

func _deactivate_hitbox_collider():
	pass
	
	
