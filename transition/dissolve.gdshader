shader_type canvas_item;

uniform float fader: hint_range(0.0, 1.0) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;
uniform sampler2D noise;

void fragment() {
	float noise_color = texture(noise, SCREEN_UV).r * fader + fader;
	if (noise_color < 0.7) {
		COLOR.rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	} else if (noise_color < 0.72) {
		COLOR.rgb = vec3(0.8, 0.0, 0.0);
	} else {
		COLOR.rgb = vec3(0.0, 0.0, 0.0);
	}
}