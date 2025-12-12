extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

var is_player_in_attack_range := false
var is_player_in_move_range := false
var is_busy := false

var can_attack : bool = true

@export var attack_damage := 40.0;

var player_body : CharacterBody2D;


@onready var animation_tree : AnimationTree = $AnimationTree
@onready var health_component : Node = $HealthComponent

func _ready() -> void:
	$Hitbox/DamageCollider.set_deferred("disabled", true)

func _process(delta: float) -> void:
	check_animation()
		
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if (is_player_in_attack_range and can_attack):
		attack()
		
	var direction = 0
	if (is_player_in_move_range and !is_player_in_attack_range):
		direction = player_body.global_position - global_position
		
		## Returns 1, -1 or 0 depending on the sign
		direction = sign(direction.x)
		
	if direction and !is_busy:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
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
	is_busy = true
	animation_tree["parameters/conditions/attack"] = true
	can_attack = false
	$AttackCooldown.start()

## This function is called from the animation player
func _attack_finished():
	is_busy = false
	
#Function to set the animation state to false on the animation tree,
#so that they won't stay turned on after the animation finishes
func set_animation_state_to_false(anim_name):
	animation_tree["parameters/conditions/" + anim_name] = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):	
		is_player_in_attack_range = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		is_player_in_attack_range = false


func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _activate_hitbox_collider(): 
	$Hitbox/DamageCollider.set_deferred("disabled", false)

func _deactivate_hitbox_collider():
	$Hitbox/DamageCollider.set_deferred("disabled", true)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		body.apply_damage(attack_damage);
		Hitstop.hit_stop(Hitstop.AttackType.HEAVY);


func _on_follow_player_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		player_body = body;
		is_player_in_move_range = true


func _on_follow_player_area_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		is_player_in_move_range = false
