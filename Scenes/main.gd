extends Node2D

# Player health bar shader


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_character_player_health_changed(current_health : float) -> void:
	var mat = $HUD/HealthBar/Health.material
	mat.set_shader_parameter("cutoff", current_health / 100)
