extends Node2D

var sun_time := 0.0

@onready var sun = $Sun1
@onready var planets = [ 
{	"center": Vector2(600, 260),
	"radius_x": 200.0,
	"radius_y": 90.0,
	"angle":  PI * 5.0 / 6.0,
	"speed": 0.5,
	"forward": true,
	"planet": $Planet1_1NoBlur,
	"scale_min": 0.1,
	"scale_max": 0.2

},
{	"center": Vector2(600, 275),
	"radius_x": 250.0,
	"radius_y": 115.0,
	"angle": PI / 6.0,
	"speed": 0.5,
	"forward": true,
	"planet": $Planet2_1,
	"scale_min": 0.1,
	"scale_max": 0.2
},
{	"center": Vector2(600, 290),
	"radius_x": 290.0,
	"radius_y": 140.0,
	"angle": 3 * PI/2,
	"speed": 0.5,
	"forward": true,
	"planet": $Planet3_1,
	"scale_min": 0.08,
	"scale_max": 0.15
}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_process(0)	
	pass # Replace with function body.


func _process(delta: float) -> void:

	# Sun pulsing
	sun_time += delta
	var pulse := (sin(sun_time * 2.0) + 1.0) / 2.0
	sun.scale = Vector2.ONE * lerp(0.49, 0.52, pulse)
	sun.modulate = Color(1.0, 1.0, 1.0).lerp(Color(1.0, 0.92, 0.65), pulse * 0.25)

	# Planets movement
	for planet in planets:
		var angle = planet["angle"]
		angle += planet["speed"] * delta
		var current_position = planet["center"] + Vector2(
			cos(angle) * planet["radius_x"],
			sin(angle) * planet["radius_y"]
		)
		# Scaling planet
		var t := scale_t_from_angle(angle)
		planet["planet"].scale = Vector2.ONE * lerp(planet["scale_min"], planet["scale_max"], t)

		if fmod(angle, 2 * PI) > PI and planet["forward"]:
			planet["forward"] = false
			planet["planet"].z_index = -1
		if fmod(angle, 2 * PI) < PI and not planet["forward"]:
			planet["forward"] = true
			planet["planet"].z_index = 1

		planet["angle"] = angle
		planet["planet"].position = current_position

# Function for smooth scaling of planets
func scale_t_from_angle(angle: float) -> float:
	var a := wrapf(angle, -PI / 2.0, PI * 1.5)
	var t: float

	if a <= PI / 2.0:
		t = inverse_lerp(-PI / 2.0, PI / 2.0, a)
	else:
		t = inverse_lerp(PI * 1.5, PI / 2.0, a)

	return smoothstep(0.0, 1.0, t)