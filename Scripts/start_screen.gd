extends Node2D

# Variables for smooth transition 
var transition_speed := 1.0
var start_transition = false
var finished_transition = false

var sun_time := 0.0
var sun_transition_target := Vector2 (2020, 380)
var sun_scale = Vector2 (0.5, 0.5)
@onready var sun = $Sun1

# All changes to planets behaviour go here
@onready var planets = [ 
{	"center": Vector2(960, 525),
	"radius_x": 180.0,
	"radius_y": 70.0,
	"angle":  PI * 5.0 / 6.0,
	"speed": 0.5,
	"forward": true,			# used to determine if is behind or in front of the sun
	"planet": $Planet1_1NoBlur, # Don't forget to change when renaming Scene objects
	"scale_min": 0.1,			
	"scale_max": 0.2,
	"target_position": Vector2(710, 560),
	"target_scale": Vector2(0.3, 0.3)

},
{	"center": Vector2(960, 525),
	"radius_x": 250.0,
	"radius_y": 115.0,
	"angle": PI / 6.0,
	"speed": 0.5,
	"forward": true,
	"planet": $Planet2_1,
	"scale_min": 0.1,
	"scale_max": 0.2,
	"target_position": Vector2(1210, 560),
	"target_scale": Vector2(0.3, 0.3)
},
{	"center": Vector2(960, 525),
	"radius_x": 290.0,
	"radius_y": 140.0,
	"angle": 3 * PI/2,
	"speed": 0.5,
	"forward": true,
	"planet": $Planet3_1,
	"scale_min": 0.08,
	"scale_max": 0.15,
	"target_position": Vector2(960, 560),
	"target_scale": Vector2(0.3, 0.3)
}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_process(0)	
	pass # Replace with function body.


func _process(delta: float) -> void:
	# Sun pulsing

	if not start_transition:
		# Sun pulsing
		sun_time += delta
		var pulse := (sin(sun_time * 2.0) + 1.0) / 2.0
		sun.scale = Vector2.ONE * lerp(sun_scale.x - 0.02, sun_scale.x + 0.02 , pulse)
		sun.modulate = Color(1.0, 1.0, 1.0).lerp(Color(1.0, 0.92, 0.65), pulse * 0.25)
		if not finished_transition:
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

				# changing z of planet if in front or behind the sun
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

func _start_pressed() -> bool:
	start_transition = true 
	var tween = create_tween()
	# tween.set_trans(Tween.TRANS_SINE)
	# tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(sun, "position", sun_transition_target, transition_speed)
	sun_scale = Vector2 (1.2, 1.2)

	tween.parallel().tween_property(sun, "scale", sun_scale, transition_speed)	
	for planet in planets:
		tween.parallel().tween_property(planet["planet"], "position", planet["target_position"], transition_speed)
		tween.parallel().tween_property(planet["planet"], "scale", planet["target_scale"], transition_speed)

	await tween.finished
	start_transition = false
	finished_transition = true
	return true