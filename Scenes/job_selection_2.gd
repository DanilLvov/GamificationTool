extends Control

@onready var planets = $Planets.get_children()
var current_index := 0

func _ready():
    _update_positions()
    print("Planeten:", planets)
    $left.pressed.connect(_on_left)
    $right.pressed.connect(_on_right)
    $select.pressed.connect(_on_select)

func _on_left():
    current_index = (current_index - 1 + planets.size()) % planets.size()
    _update_positions()

func _on_right():
    current_index = (current_index + 1) % planets.size()
    _update_positions()

func _on_select():
    var selected_planet = planets[current_index]
    print("Ausgewählt:", selected_planet.name)
    # Hier kannst du eine Szene laden, Daten übergeben, etc.

func _update_positions():
    var center_x = size.x / 2
    var spacing = 200

    for i in range(planets.size()):
        var planet = planets[i]
        var offset = i - current_index

        var target_x = center_x + offset * spacing
        var target_scale = offset == 0 if Vector2(1.3, 1.3) else Vector2(1, 1)
        var target_modulate = offset == 0 if Color.WHITE else Color(0.7, 0.7, 0.7)

        var tween = create_tween()
        tween.tween_property(planet, "position:x", target_x, 0.3)
        tween.parallel().tween_property(planet, "scale", target_scale, 0.3)
        tween.parallel().tween_property(planet, "modulate", target_modulate, 0.3)