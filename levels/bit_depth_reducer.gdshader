shader_type canvas_item;

uniform sampler2D Texture2DParameter : hint_screen_texture;
uniform int Levels : hint_range(0, 100) = 8;

void fragment() {
	vec4 color = texture(Texture2DParameter, SCREEN_UV);
	vec4 levels = vec4(float(Levels));
	color = round(color * levels);
	color = color / levels;
	COLOR = color;
}
