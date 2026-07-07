class_name StarField
extends Node2D

# Normal small stars
@export var star_count: int = 120
@export var area_size: Vector2 = Vector2(1920, 1080)
# General drift heading; each star moves away from this so they don't all move together
var base_direction_degrees: float = 160.0
var direction_jitter_degrees: float = 30.0
var speed_range: Vector2 = Vector2(2.0, 22.0)
var twinkle_speed_range: Vector2 = Vector2(1.0, 3.0)
var star_radius_range: Vector2 = Vector2(1.0, 2.6)
var star_colors: Array[Color] = [
	Color.WHITE,    # white
	Color(0.75, 0.85, 1.0),  # blue-white
	Color(1.0, 0.93, 0.78),  # warm yellow
	Color(1.0, 0.8, 0.68),   # soft orange
]

# Sprite stars, not moving, rotating and pulsing
var sprite_star_rotation_degrees: float = 6.0
var sprite_star_rotation_speed_range: Vector2 = Vector2(0.3, 0.8)
var sprite_star_color_speed_range: Vector2 = Vector2(0.2, 0.6)
var sprite_star_scale_pulse: float = 0.15
var sprite_star_scale_speed_range: Vector2 = Vector2(1.0, 2.0)

# Shooting stars: short fading streaks along predefined straight paths [from, to].
# One at a time; a path's length sets its apparent speed (length / lifetime).
var shooting_star_interval: Vector2 = Vector2(2.5, 6.0) # seconds between streaks
var shooting_star_lifetime: float = 0.7
var shooting_star_trail_length: float = 140.0
var shooting_star_width: float = 2.2
var shooting_star_color: Color = Color.WHITE
var shooting_star_paths := [
	[Vector2(200, 150), Vector2(950, 400)],
	[Vector2(1700, 100), Vector2(1050, 550)],
	[Vector2(900, 50), Vector2(1250, 700)],
	[Vector2(600, 250), Vector2(50, 650)],
	[Vector2(1500, 500), Vector2(800, 900)],
]

# Asteroid: rare drifter crossing the whole screen border to border.
# Flights are [from, to, duration in seconds, total spin in radians].
var asteroid_interval: float = 5.0 # seconds between flights
var asteroid_flights := [
	[Vector2(-150, 250), Vector2(2070, 350), 20.0, 6.0],
	[Vector2(2070, -100), Vector2(1600, 1000), 24.0, -8.0],
	[Vector2(1500, -150), Vector2(1900, 430), 17.0, 5.0],
]

@onready var _asteroid: Sprite2D = $Asteroid

var _stars: Array = []
var _sprite_stars: Array = []
var _time := 0.0

# Current shooting star, driven by the tween in _shooting_star_loop
var _shot_active := false
var _shot_t := 0.0
var _shot_from := Vector2.ZERO
var _shot_to := Vector2.ZERO

var _asteroid_base_scale: Vector2


func _ready() -> void:
	randomize()
	for i in star_count:
		var angle := deg_to_rad(base_direction_degrees + randf_range(-direction_jitter_degrees, direction_jitter_degrees))
		var speed := randf_range(speed_range.x, speed_range.y)
		_stars.append({
			"pos": Vector2(randf() * area_size.x, randf() * area_size.y),
			"velocity": Vector2.RIGHT.rotated(angle) * speed,
			"radius": randf_range(star_radius_range.x, star_radius_range.y),
			"phase": randf() * TAU,
			"twinkle_speed": randf_range(twinkle_speed_range.x, twinkle_speed_range.y),
			"color": star_colors[randi() % star_colors.size()],
		})

	_asteroid_base_scale = _asteroid.scale
	_asteroid.visible = false

	# getting all Star Nodes from StarField
	for child in get_children():
		if child == _asteroid:
			continue
		if child is Sprite2D:
			_sprite_stars.append({
				"node": child,
				"base_rotation": child.rotation,
				"rotation_phase": randf() * TAU,
				"rotation_speed": randf_range(sprite_star_rotation_speed_range.x, sprite_star_rotation_speed_range.y),
				"color_phase": randf() * TAU,
				"color_speed": randf_range(sprite_star_color_speed_range.x, sprite_star_color_speed_range.y),
				"color": star_colors[randi() % star_colors.size()],
				"base_scale": child.scale,
				"scale_phase": randf() * TAU,
				"scale_speed": randf_range(sprite_star_scale_speed_range.x, sprite_star_scale_speed_range.y),
			})

	_shooting_star_loop()
	_asteroid_loop()


func _process(delta: float) -> void:
	_time += delta

	_update_stars(delta)
	_update_sprite_stars()

	queue_redraw()

# updating small stars, just moving
func _update_stars(delta: float) -> void:
	for star in _stars:
		star["pos"] += star["velocity"] * delta
		star["pos"].x = fposmod(star["pos"].x, area_size.x)
		star["pos"].y = fposmod(star["pos"].y, area_size.y)

# updating big sprite stars, rotating, color pulse, scaling
func _update_sprite_stars() -> void:
	for star in _sprite_stars:
		var node: Sprite2D = star["node"]

		# rotation update
		var sway := sin(_time * star["rotation_speed"] + star["rotation_phase"])
		node.rotation = star["base_rotation"] + deg_to_rad(sprite_star_rotation_degrees) * sway

		# color update
		var blend := 0.5 + 0.5 * sin(_time * star["color_speed"] + star["color_phase"])
		node.modulate = Color(1.0, 1.0, 1.0).lerp(star["color"], blend)

		# scale update
		var pulse := sin(_time * star["scale_speed"] + star["scale_phase"])
		node.scale = star["base_scale"] * (1.0 + sprite_star_scale_pulse * pulse)


# Endless loop: wait, then fly one streak along a predefined path via tween
func _shooting_star_loop() -> void:
	while true:
		await get_tree().create_timer(randf_range(shooting_star_interval.x, shooting_star_interval.y)).timeout

		var path: Array = shooting_star_paths.pick_random()
		_shot_from = path[0]
		_shot_to = path[1]
		_shot_active = true

		var tween := create_tween()
		tween.tween_method(func(t: float): _shot_t = t, 0.0, 1.0, shooting_star_lifetime)
		await tween.finished

		_shot_active = false


# Endless loop: wait, then fly the asteroid along a predefined flight via tween
func _asteroid_loop() -> void:
	while true:
		await get_tree().create_timer(asteroid_interval).timeout

		var flight: Array = asteroid_flights.pick_random()
		_asteroid.position = flight[0]
		_asteroid.scale = _asteroid_base_scale * 0.8
		_asteroid.visible = true

		var tween := create_tween()
		tween.tween_property(_asteroid, "position", flight[1], flight[2])
		tween.parallel().tween_property(_asteroid, "rotation", _asteroid.rotation + flight[3], flight[2])
		# grows slightly over the flight, reads as coming closer
		tween.parallel().tween_property(_asteroid, "scale", _asteroid_base_scale * 1.2, flight[2])
		await tween.finished

		_asteroid.visible = false


func _draw() -> void:
	for star in _stars:
		var brightness := 0.5 + 0.5 * sin(_time * star["twinkle_speed"] + star["phase"])
		var alpha := lerpf(0.25, 1.0, brightness)
		var c: Color = star["color"]
		draw_circle(star["pos"], star["radius"], Color(c.r, c.g, c.b, alpha))

	if _shot_active:
		_draw_shooting_star()


func _draw_shooting_star() -> void:
	# Fade in over the first 15% of life, fade out over the last 30%.
	var fade := clampf(_shot_t / 0.15, 0.0, 1.0) * clampf((1.0 - _shot_t) / 0.3, 0.0, 1.0)
	if fade <= 0.0:
		return

	var pos := _shot_from.lerp(_shot_to, _shot_t)
	var tail := pos - (_shot_to - _shot_from).normalized() * shooting_star_trail_length
	var head_color := Color(shooting_star_color.r, shooting_star_color.g, shooting_star_color.b, fade)
	var tail_color := Color(shooting_star_color.r, shooting_star_color.g, shooting_star_color.b, 0.0)

	draw_polyline_colors(
		PackedVector2Array([tail, pos]),
		PackedColorArray([tail_color, head_color]),
		shooting_star_width,
		true
	)
	draw_circle(pos, shooting_star_width * 1.4, head_color)
