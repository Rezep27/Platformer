extends Node

enum AttackType{
	LIGHT,
	HEAVY,
	SPECIAL
}

func hit_stop(attackType : AttackType):
	var duration : float = 0
	
	match attackType:
		AttackType.LIGHT:
			duration = 0.08
		AttackType.HEAVY:
			duration = 0.12
		AttackType.SPECIAL:
			duration = 0.20
	
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
