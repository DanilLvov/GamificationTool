extends Control

var planets: Array
var current_index := 0

func _ready():
    planets = $Planets.get_children()
    print("Gefundene Planeten:", planets)
    print("Planets Node:", $Planets)
    print("Children:", $Planets.get_children())
    $left.pressed.connect(_on_left)
    $right.pressed.connect(_on_right)
    $select.pressed.connect(_on_select)

    _update_positions()

func _on_left():
    current_index = (current_index - 1 + planets.size()) % planets.size()
    _update_positions()

func _on_right():
    current_index = (current_index + 1) % planets.size()
    _update_positions()

func _on_select():
    var selected_planet = planets[current_index]
    print("Ausgewählt:", selected_planet.name)

func _update_positions():
    if planets.is_empty():
        return

    var center_x = size.x * 0.5
    var spacing = 200.0

    for i in range(planets.size()):
        var planet = planets[i]
        var offset = i - current_index

        var target_x = center_x + offset * spacing
        var is_center = offset == 0
        var target_scale = Vector2(1.3, 1.3) if is_center else Vector2(1, 1)
        var target_modulate = Color.WHITE if is_center else Color(0.7, 0.7, 0.7)

        var tween = create_tween()
        tween.tween_property(planet, "position:x", target_x, 0.3)
        tween.parallel().tween_property(planet, "scale", target_scale, 0.3)
        tween.parallel().tween_property(planet, "modulate", target_modulate, 0.3)
