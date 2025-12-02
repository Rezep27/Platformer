extends Sprite2D

@export var flash_duration := 0.05;
@export var flash_speed := 40.0;
@export var flash_color := Color.WHITE;

var flash_time := 0.0
var mat = null

func _ready():
	mat = self.material
	
	if mat == null:
		push_warning("Hitflash: No sprite2d or material found")
		return
	mat.set("shader_parameter/flash_color", flash_color)
	
## Call this function when the entity is hit
func start_flash():
	flash_time = flash_duration

func _process(delta):
	if mat == null:
		return
	
	if flash_time > 0.0:
		flash_time -= delta
		
		var t = 1.0 - (flash_time/flash_duration)
		var pulse = abs(sin(t * flash_speed))
		
		mat.set("shader_parameter/flash_strength", pulse)
	else:
		mat.set("shader_parameter/flash_strength", 0.0)
	
	
