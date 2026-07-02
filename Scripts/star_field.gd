class_name StarField
extends Node2D

@export var star_count: int = 120
@export var area_size: Vector2 = Vector2(1920, 1080)
# General drift heading; each star moves away from this so they don't all move together
@export var base_direction_degrees: float = 160.0 
@export var direction_jitter_degrees: float = 30.0
@export var speed_range: Vector2 = Vector2(2.0, 22.0)
@export var twinkle_speed_range: Vector2 = Vector2(1.0, 3.0)
@export var star_radius_range: Vector2 = Vector2(1.0, 2.6)
@export var star_colors: Array[Color] = [
	Color(1.0, 1.0, 1.0),    # white
	Color(0.75, 0.85, 1.0),  # blue-white
	Color(1.0, 0.93, 0.78),  # warm yellow
	Color(1.0, 0.8, 0.68),   # soft orange
]

# Shooting stars: rare, fast diagonal streaks with a fading trail.
@export var shooting_stars_enabled: bool = true
@export var shooting_star_interval_range: Vector2 = Vector2(2.5, 6.0) # seconds between spawns
@export var shooting_star_directions_degrees: Array[float] = [
	20.0,
	45.0, 
	70.0,  
	110.0,
	135.0,
	160.0
]
@export var shooting_star_direction_jitter_degrees: float = 12.0
@export var shooting_star_speed_range: Vector2 = Vector2(700.0, 1100.0)
@export var shooting_star_lifetime_range: Vector2 = Vector2(0.5, 0.9)
@export var shooting_star_trail_length: float = 140.0
@export var shooting_star_width: float = 2.2
@export var shooting_star_color: Color = Color(1.0, 1.0, 1.0)

var _stars: Array = []
var _shooting_stars: Array = []
var _next_shooting_star_in := 0.0
var _time := 0.0


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

	_next_shooting_star_in = randf_range(shooting_star_interval_range.x, shooting_star_interval_range.y)


func _process(delta: float) -> void:
	_time += delta
	for star in _stars:
		star["pos"] += star["velocity"] * delta
		star["pos"].x = fposmod(star["pos"].x, area_size.x)
		star["pos"].y = fposmod(star["pos"].y, area_size.y)

	if shooting_stars_enabled:
		_update_shooting_stars(delta)

	queue_redraw()


func _update_shooting_stars(delta: float) -> void:
	_next_shooting_star_in -= delta
	if _next_shooting_star_in <= 0.0:
		_spawn_shooting_star()
		_next_shooting_star_in = randf_range(shooting_star_interval_range.x, shooting_star_interval_range.y)

	for i in range(_shooting_stars.size() - 1, -1, -1):
		var shot: Dictionary = _shooting_stars[i]
		shot["age"] += delta
		shot["pos"] += shot["velocity"] * delta
		if shot["age"] >= shot["lifetime"]:
			_shooting_stars.remove_at(i)


func _spawn_shooting_star() -> void:
	var base_direction_degrees := 135.0
	if not shooting_star_directions_degrees.is_empty():
		base_direction_degrees = shooting_star_directions_degrees[randi() % shooting_star_directions_degrees.size()]
	var angle := deg_to_rad(base_direction_degrees + randf_range(-shooting_star_direction_jitter_degrees, shooting_star_direction_jitter_degrees))
	var direction := Vector2.RIGHT.rotated(angle)
	var speed := randf_range(shooting_star_speed_range.x, shooting_star_speed_range.y)
	var start := Vector2(randf_range(0.0, area_size.x), randf_range(0.0, area_size.y * 0.4)) - direction * 300.0

	_shooting_stars.append({
		"pos": start,
		"velocity": direction * speed,
		"age": 0.0,
		"lifetime": randf_range(shooting_star_lifetime_range.x, shooting_star_lifetime_range.y),
	})


func _draw() -> void:
	for star in _stars:
		var brightness := 0.5 + 0.5 * sin(_time * star["twinkle_speed"] + star["phase"])
		var alpha := lerpf(0.25, 1.0, brightness)
		var c: Color = star["color"]
		draw_circle(star["pos"], star["radius"], Color(c.r, c.g, c.b, alpha))

	for shot in _shooting_stars:
		_draw_shooting_star(shot)


func _draw_shooting_star(shot: Dictionary) -> void:
	var life_t: float = shot["age"] / shot["lifetime"]
	# Fade in over the first 15% of life, fade out over the last 30%.
	var fade := clampf(life_t / 0.15, 0.0, 1.0) * clampf((1.0 - life_t) / 0.3, 0.0, 1.0)
	if fade <= 0.0:
		return

	var velocity: Vector2 = shot["velocity"]
	var tail: Vector2 = shot["pos"] - velocity.normalized() * shooting_star_trail_length
	var head_color := Color(shooting_star_color.r, shooting_star_color.g, shooting_star_color.b, fade)
	var tail_color := Color(shooting_star_color.r, shooting_star_color.g, shooting_star_color.b, 0.0)

	draw_polyline_colors(
		PackedVector2Array([tail, shot["pos"]]),
		PackedColorArray([tail_color, head_color]),
		shooting_star_width,
		true
	)
	draw_circle(shot["pos"], shooting_star_width * 1.4, head_color)
