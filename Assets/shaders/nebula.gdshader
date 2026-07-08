shader_type canvas_item;

// Slow drift of the noise field, giving the clouds a sense of depth/motion.
uniform vec2 drift_speed = vec2(0.006, -0.004);
uniform float noise_scale = 3.0;
// Shifts where this layer samples the noise field, so multiple nebula
// layers don't cluster their clouds in the same spot on screen.
uniform vec2 seed_offset = vec2(0.0);
// Higher = more of the screen covered in cloud.
uniform float density = 0.55;
uniform float max_alpha = 0.9;
uniform vec4 color_deep : source_color = vec4(0.05, 0.02, 0.12, 1.0);
uniform vec4 color_mid : source_color = vec4(0.42, 0.12, 0.55, 1.0);
uniform vec4 color_bright : source_color = vec4(0.35, 0.75, 0.85, 1.0);

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

// Fractal Brownian motion: layered noise octaves for cloud-like detail.
float fbm(vec2 p) {
	float value = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 5; i++) {
		value += amp * noise(p);
		p *= 2.0;
		amp *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 p = UV * noise_scale + TIME * drift_speed + seed_offset;

	// Two independently offset cloud masses combined with max() so the
	// layer has multiple cluster centers instead of one dominant blob —
	// as one drifts off-screen another is already visible elsewhere.
	float shape_a = fbm(p);
	float shape_b = fbm(p * 1.3 + vec2(17.3, -9.4));
	float shape = max(shape_a, shape_b);

	float cloud = smoothstep(1.0 - density, 1.0, shape);
	// Fully transparent here regardless of detail/color below, so bail out
	// before paying for the third fbm() call and the color mixing.
	if (cloud <= 0.0) {
		discard;
	}

	float detail = fbm(p * 2.3 + 11.7);
	vec3 col = mix(color_deep.rgb, color_mid.rgb, smoothstep(0.2, 0.7, shape));
	col = mix(col, color_bright.rgb, smoothstep(0.65, 0.95, detail) * cloud);

	COLOR = vec4(col, cloud * max_alpha);
}
