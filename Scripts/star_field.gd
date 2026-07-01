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

var _stars: Array = []
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


func _process(delta: float) -> void:
	_time += delta
	for star in _stars:
		star["pos"] += star["velocity"] * delta
		star["pos"].x = fposmod(star["pos"].x, area_size.x)
		star["pos"].y = fposmod(star["pos"].y, area_size.y)
	queue_redraw()


func _draw() -> void:
	for star in _stars:
		var brightness := 0.5 + 0.5 * sin(_time * star["twinkle_speed"] + star["phase"])
		var alpha := lerpf(0.25, 1.0, brightness)
		var c: Color = star["color"]
		draw_circle(star["pos"], star["radius"], Color(c.r, c.g, c.b, alpha))
