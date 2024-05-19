shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform sampler2D color_gradient: source_color, repeat_disable;
uniform float percent;
uniform float feather_size;
uniform float pixel_size;
uniform vec2 effect_tiling;
uniform vec2 scroll_speed;
uniform vec2 player_pos;
uniform vec2 alpha_smoothstep= vec2(0.0,1.0);
varying vec2 player_pos_normalized;

float overlay(float base, float blend){
	float limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}


void vertex(){
	player_pos_normalized = (vec4(player_pos, 0.0,1.0) * CANVAS_MATRIX * SCREEN_MATRIX).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 pos_screen_uv = player_pos_normalized;
	vec2 coord = SCREEN_UV - (pos_screen_uv) * 0.5;
	coord.y *= SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	//coord *= 0.5;
	float dist = length(coord);
	coord = vec2(atan(coord.x, coord.y) / PI, dist);
	coord *= effect_tiling;
	dist = smoothstep(1.0 - percent - pixel_size* SCREEN_PIXEL_SIZE.x, 1.0 - percent , dist);
	float noise_col = texture(noise, coord + scroll_speed * TIME).r;
	COLOR = texture(color_gradient, vec2(overlay(dist,noise_col)));
	COLOR.a = dist - noise_col;
	COLOR.a = overlay(dist, COLOR.a);
	COLOR.a = smoothstep(alpha_smoothstep.x, alpha_smoothstep.y, COLOR.a);
	//COLOR.a = step(0.2, COLOR.a);
	//COLOR.rgb = step(vec3(0.3),COLOR.rgb);
	//COLOR.rgb = vec3(1.0);
	
}
