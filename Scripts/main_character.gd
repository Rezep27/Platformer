extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

#Variable that indicates if the character can recieve any input
var is_busy : bool = false
#Tracks the attack combo
var attack_index : int = 0
#State, if the user can chain an attack
var can_chain : bool = false

var attack_damage = 30

#Set animation tree to a variable so we can access parameters
@onready var animation_tree : AnimationTree = $AnimationTree

#Set direction as global variable
var direction

func _ready() -> void:
	$HitBox/DamageCollider.set_deferred("disabled", true)

func _process(delta : float):
	if Input.is_action_just_pressed("attack"):
		if !is_busy and attack_index == 0:
			attack_index = 1
			_start_attack("attack1")
		elif (attack_index == 1 and can_chain):
			attack_index = 2
			_start_attack("attack2")
		elif (attack_index == 2 and can_chain):
			attack_index = 3
			_start_attack("attack3")
		elif (attack_index == 3 and can_chain):
			attack_index = 4
			_start_attack("attack4")

	update_animation()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !is_busy:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction and !is_busy:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func update_animation():
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true

func _start_attack(attack_para : String):
	is_busy = true
	can_chain = false
	animation_tree["parameters/conditions/" + attack_para] = true
	#Turns the condition off in the next frame, we just want to be able to enter the state once
	
func attack_animation_finished(animation_name):
	if animation_name == "attack1" or animation_name == "attack2" or animation_name == "attack3":
		can_chain = true
		$ComboTimer.start()
	elif animation_name == "attack4":
		_go_to_recovery()
		

func _go_to_recovery():
	can_chain = false
	is_busy = false
	var att_index : int = attack_index
	attack_index = 0
	animation_tree["parameters/conditions/attack" + str(att_index) + "_recover"] = true
	

func _on_combo_timer_timeout() -> void:
	if can_chain:
		_go_to_recovery()
		

#Function to set the animation state to false on the animation tree,
#so that they won't stay turned on after the animation finishes
func set_animation_state_to_false(anim_name):
	animation_tree["parameters/conditions/" + anim_name] = false

func enable_hit_collider():
	$HitBox/DamageCollider.set_deferred("disabled", false)
	
func disable_hit_collider():
	$HitBox/DamageCollider.set_deferred("disabled", true)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.apply_damage(attack_damage)
