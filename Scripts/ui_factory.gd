extends RefCounted
class_name UIFactory

# TODO: Add Fonts here: 
# const FONT_MAIN

# TODO add UI Element types here
enum UIElementTypes {
	NORMAL_BUTTON,
	ROUND_BUTTON,
	ROUND_ARROW_BUTTON,
	ROUND_ARROW_BUTTON_MIRRORED,
	RESET_BUTTON,
	ANSWER_BACKGROUND
}
# TODO(optional): load list of resources from directory
const BUTTONS = {
	UIElementTypes.NORMAL_BUTTON: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_normal.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_hover.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_press.svg")
	},
	UIElementTypes.ROUND_BUTTON: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_round_normal.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_round_hover.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_round_press.svg")
	},
	UIElementTypes.ROUND_ARROW_BUTTON: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_round_arrow_normal.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_round_arrow_hover.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_round_arrow_press.svg")
	},
	UIElementTypes.ROUND_ARROW_BUTTON_MIRRORED: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_round_arrow_normal_mirrored.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_round_arrow_hover_mirrored.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_round_arrow_press_mirrored.svg")
	},
	UIElementTypes.RESET_BUTTON: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_round_reset_normal.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_round_reset_hover.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_round_reset_press.svg")
	},
	UIElementTypes.ANSWER_BACKGROUND: {
		"normal": preload("res://assets/ui/frames/answers/answer_background.svg"),
		"hover": preload("res://assets/ui/frames/answers/answer_background_hover.svg"),
		"pressed": preload("res://assets/ui/frames/answers/answer_background_press.svg")
	}
}

# add all backgrounds here
const MINIGAME_BACKGROUNDS = {
	"Minigame1": preload("res://Assets/Backgrounds/Minigame_1.PNG"),
	"Minigame2": preload("res://Assets/Backgrounds/Minigame_2.PNG")
}
const CONTAINER_TEXTURE = preload("res://assets/ui/frames/simple_Question_Frame.svg")

static var _margin_default  := 20

static func create_label(text: String) -> Dictionary:
	var root := MarginContainer.new()
	root.add_theme_constant_override("margin_left", 15)
	root.add_theme_constant_override("margin_top", 15)
	root.add_theme_constant_override("margin_right", 15)
	root.add_theme_constant_override("margin_bottom", 15)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var label := Label.new()
	#label.custom_minimum_size = Vector2(50, 20)
	label.text = text
	label.add_theme_color_override("font_color", Color.BLACK)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(label)

	# var font = _load_res(FONT_MAIN)
		# if font:
		# 	label.add_theme_font_override("font", font)

	return {
		"root": root
	}

static func create_code_snippet(
	code_text: String,
	file_name: String = "code.txt",
	title: String = "Code-Snippet"
) -> Dictionary:
	var root := PanelContainer.new()
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_right", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	root.add_child(margin)

	var style := StyleBoxFlat.new()
	style.bg_color = Color8(18, 22, 38)
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color8(55, 65, 95)

	root.add_theme_stylebox_override("panel", style)

	var layout := VBoxContainer.new()
	margin.add_child(layout)

	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 42)
	layout.add_child(header)

	var title_label := Label.new()
	title_label.text = "</>  " + title
	title_label.add_theme_color_override("font_color", Color8(0, 216, 177))
	header.add_child(title_label)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	var file_label := Label.new()
	file_label.text = file_name
	file_label.add_theme_color_override("font_color", Color8(170, 175, 195))
	header.add_child(file_label)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(body)

	var line_numbers := Label.new()
	line_numbers.text = _make_line_numbers(code_text)
	line_numbers.add_theme_color_override("font_color", Color8(130, 135, 155))
	line_numbers.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	line_numbers.custom_minimum_size = Vector2(36, 0)
	body.add_child(line_numbers)

	var code_label := RichTextLabel.new()
	code_label.bbcode_enabled = true
	code_label.fit_content = true
	code_label.scroll_active = false
	code_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	code_label.text = "[font_size=16][color=#d8e0ff]" + _escape_bbcode(code_text) + "[/color][/font_size]"
	body.add_child(code_label)

	return {
		"root": root,
		"code_label": code_label
	}

static func _make_line_numbers(code_text: String) -> String:
	var lines := code_text.split("\n")
	var result := ""

	for i in range(lines.size()):
		result += str(i + 1)
		if i < lines.size() - 1:
			result += "\n"

	return result


static func _escape_bbcode(text: String) -> String:
	return text \
		.replace("[", "\\[") \
		.replace("]", "\\]")
# creates button with 3 textures (normal, hovered, pressed), consists of:
# root, button, and optional label (for normal text on button)
# call example:
static func create_texture_button(type: UIElementTypes, size: Vector2 = Vector2(120, 50), text: String = "") -> Dictionary:
	var root = MarginContainer.new()
	var button: TextureButton = TextureButton.new()
	button.texture_normal = BUTTONS.get(type).get("normal")
	button.texture_hover = BUTTONS.get(type).get("hover")
	button.texture_pressed = BUTTONS.get(type).get("pressed")
	button.custom_minimum_size = size
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	
	root.add_child(button)

	if text != "":
		root.add_child(create_label(text).get("root"))


	return {
		"root": root,
		"button": button,
		# OPIONAL: add label access
	}


# Panel container consists of 4 parts: 
# root (used only for dding container into scene), header (for title text), content (for any content block you need), footer (for additional things)
static func create_panel_container(size: Vector2) -> Dictionary:
	var root := PanelContainer.new()
	root.custom_minimum_size = size
	root.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	root.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_bottom", 20)
	root.add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", _margin_default)
	margin.add_child(layout)

	var header := VBoxContainer.new()
	#header.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var content := CenterContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var footer := VBoxContainer.new()
	

	layout.add_child(header)
	layout.add_child(content)
	layout.add_child(footer)



	# var frame := NinePatchRect.new()
	# frame.texture = preload("res://assets/ui/your_frame.png")
	# frame.custom_minimum_size = Vector2(500, 300)

	
	
	var style := StyleBoxTexture.new()
	style.texture = CONTAINER_TEXTURE
	style.texture_margin_left = 35
	style.texture_margin_right = 35
	style.texture_margin_top = 35
	style.texture_margin_bottom = 35
	root.add_theme_stylebox_override("panel", style)

	return {
		"root": root,
		"header": header,
		"content": content,
		"footer": footer
	}

static func create_colored_panel_container(
	size: Vector2 = Vector2(50, 50),
	bg_color: Color = Color8(0, 216, 177),
	corner_radius: int = 10,
	border_width: int = 0,
	border_color: Color = Color.TRANSPARENT
) -> Dictionary:
	var root := PanelContainer.new()
	root.custom_minimum_size = size

	var style := StyleBoxFlat.new()
	style.bg_color = bg_color

	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius

	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.border_color = border_color

	root.add_theme_stylebox_override("panel", style)

	return {
		"root": root,
		"style": style
	}

static func create_background(path: String) -> Dictionary:
	var root := TextureRect.new()

	root.texture = MINIGAME_BACKGROUNDS.get(path)

	root.custom_minimum_size = Vector2(1920,1080)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	root.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

	return {
		"root": root
	}