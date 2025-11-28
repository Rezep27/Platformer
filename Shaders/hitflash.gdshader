shader_type canvas_item;

uniform float flash_strength = 0;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    vec3 flashed = mix(base.rgb, flash_color.rgb, flash_strength);
    COLOR = vec4(flashed, base.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
