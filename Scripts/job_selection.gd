extends Node2D

var planets: Dictionary
var _left_arrow_button
var _right_arrow_button

@onready var select_button = $SelectButton
var _show_select_button := true

enum Job {
	# Jobs for specialization choice, determine minigame content
	SOFTWAREENTWICKLUNG,
	MARKETING,
	PROJEKTMANAGEMENT
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_left_arrow_button = UIFactory.create_texture_button(UIFactory.UIElementTypes.ROUND_ARROW_BUTTON_MIRRORED, Vector2(876, 889))
	_right_arrow_button = UIFactory.create_texture_button(UIFactory.UIElementTypes.ROUND_ARROW_BUTTON, Vector2(876, 889))

	_left_arrow_button["button"].pressed.connect(_on_left_pressed)
	_right_arrow_button["button"].pressed.connect(_on_right_pressed)
	
	_left_arrow_button["button"].scale = Vector2(0.2, 0.1)
	_right_arrow_button["button"].scale = Vector2(0.1, 0.1)
	_left_arrow_button["root"].scale = Vector2(0.1, 0.1)
	_right_arrow_button["root"].scale = Vector2(0.1, 0.1)


	_left_arrow_button["root"].position = Vector2(20, 540)
	_right_arrow_button["root"].position = Vector2(1810, 540)

	add_child(_left_arrow_button["root"])
	add_child(_right_arrow_button["root"])


	planets = _load_JSON("res://Database/planets.json")
	_add_planets_to_carousel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass # Replace with function body.


func _load_JSON(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("JSON file not found: %s" % path)
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Cannot open JSON file: %s" % path)
		return {}

	var json_text := file.get_as_text()
	var parsed = JSON.parse_string(json_text)

	if parsed == null:
		push_error("Invalid JSON in file: %s" % path)
		return {}

	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Root JSON must be an object/dictionary")
		return {}
	
	var result: Dictionary = {}

	for id in parsed.keys():
		var data = parsed[id]
		if typeof(data) != TYPE_DICTIONARY:
			push_error("Scene '%s' must be an object" % id)
			continue
	
		result[id] = data

	return result

signal job_chosen

func _add_planets_to_carousel():
	for planet in planets.values():
		var panel = Panel.new()
		panel.position = - panel.size / 2 + Vector2(20, 0)
		panel.name = planet["name"]
		panel.custom_minimum_size = Vector2(250, 250)
		panel.size = Vector2(250, 250)
		var empty_style := StyleBoxEmpty.new()
		panel.add_theme_stylebox_override("panel", empty_style)

		var texture_rect = TextureRect.new()
		texture_rect.texture = load(planet["path"])
		texture_rect.scale = Vector2(planet["scale_x"], planet["scale_y"])
		texture_rect.anchor_right = 1.0
		texture_rect.anchor_bottom = 1.0

		var label = Label.new()
		label.text = planet["name"]

		label.anchor_left = 0.5
		label.anchor_right = 0.5
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

		var label_gap := 130.0
		label.position.y = panel.size.y * float(planet["scale_y"]) + label_gap
		label.custom_minimum_size.y = 40

		panel.add_child(texture_rect)
		panel.add_child(label)

		panel.gui_input.connect(

			func(event):
				if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					var selected_job = panel.name.to_upper()
					if not Job.has(selected_job):
						push_error("Unknown Job '%s' in planets.json" % [selected_job])
						return
					var game = get_parent()
					game.selected_job = selected_job
					print("Selected job: ", game.selected_job)
					emit_signal("job_chosen")
		)
	
		$CarouselContainer.position_offset_node.add_child(panel)

func _on_left_pressed() -> void:
	$CarouselContainer._left()


func _on_right_pressed() -> void:
	$CarouselContainer._right()

func _on_select_button_pressed() -> void:
	var start_pos: Vector2 = select_button.position
	var button_tween := create_tween()
	button_tween.tween_property(select_button, "position", start_pos + Vector2(0, -20), 0.1)
	button_tween.tween_property(select_button, "position", start_pos + Vector2(0, 400), 0.4)

	
	await button_tween.finished
	emit_signal("job_chosen")

func _on_node_shown() -> void:
	if visible && select_button != null && _show_select_button: 
		_show_select_button = false
		var start_pos: Vector2 = select_button.position
		var button_tween := create_tween()
		button_tween.tween_property(select_button, "position", start_pos + Vector2(0, -420), 0.3)
		button_tween.tween_property(select_button, "position", start_pos + Vector2(0, -400), 0.1)
