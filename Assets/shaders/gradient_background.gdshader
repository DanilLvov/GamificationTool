shader_type canvas_item;

// Slow drift so the gradient never looks perfectly static.
uniform vec2 drift_speed = vec2(0.008, 0.005);
uniform vec4 color_black : source_color = vec4(0.01, 0.01, 0.025, 1.0);
uniform vec4 color_blue : source_color = vec4(0.04, 0.09, 0.24, 1.0);
uniform vec4 color_accent : source_color = vec4(0.12, 0.05, 0.20, 1.0);
uniform float accent_strength = 0.45;

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
	float value = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 4; i++) {
		value += amp * noise(p);
		p *= 2.0;
		amp *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 uv = UV + TIME * drift_speed;

	// Radial falloff from a slowly wandering center: dark blue at the core
	// fading to near-black toward the edges.
	vec2 center = vec2(0.5) + 0.18 * vec2(sin(TIME * 0.05), cos(TIME * 0.04));
	float dist = distance(UV, center);
	float grad = smoothstep(0.05, 0.95, dist);
	vec3 col = mix(color_blue.rgb, color_black.rgb, grad);

	// Soft drifting patches of a third color for extra depth/richness.
	float accent_noise = fbm(uv * 2.2 + 30.0);
	col = mix(col, color_accent.rgb, smoothstep(0.55, 0.85, accent_noise) * accent_strength);

	COLOR = vec4(col, 1.0);
}
