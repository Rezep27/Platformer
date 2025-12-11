extends Control

@export var char_per_second := 10.0
var second_per_char
var can_update = false
var displayed_text_array
var displayed_text_index

var acummulated_time


func _process(delta: float) -> void:
	if can_update and displayed_text_index <= displayed_text_array.size():
		_update_text(displayed_text_array.slice(0,displayed_text_index))
		
	if displayed_text_index > displayed_text_array.size():
		can_update = false
	
	if acummulated_time >= second_per_char and can_update:
		displayed_text_index += 1
		acummulated_time = 0
	acummulated_time += delta

func _update_text(text : Array):
	var new_text = "".join(text)
	$Label.text = new_text

func _update_text_at_speed(text: String):
	second_per_char = 1/char_per_second
	can_update = true
	displayed_text_array = text.split()
	displayed_text_index = 0
	acummulated_time = 0
