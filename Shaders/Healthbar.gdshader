shader_type canvas_item;

uniform float cutoff : hint_range(0.0, 1.0) = 0.5;
uniform vec4 tint_color : source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	if (UV.x > cutoff)
		discard;
	else
		COLOR = tint_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
