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
		"normal": preload("res://Assets/ui/simple_buttons/simple_button_normal.svg"),
		"hover": preload("res://Assets/ui/simple_buttons/simple_button_hover.svg"),
		"pressed": preload("res://Assets/ui/simple_buttons/simple_button_press.svg")
	},
	UIElementTypes.ROUND_BUTTON: {
		"normal": preload("res://Assets/ui/simple_buttons/simple_button_round_normal.svg"),
		"hover": preload("res://Assets/ui/simple_buttons/simple_button_round_hover.svg"),
		"pressed": preload("res://Assets/ui/simple_buttons/simple_button_round_press.svg")
	},
	UIElementTypes.ROUND_ARROW_BUTTON: {
		"normal": preload("res://Assets/ui/simple_buttons/simple_button_round_arrow_normal.svg"),
		"hover": preload("res://Assets/ui/simple_buttons/simple_button_round_arrow_hover.svg"),
		"pressed": preload("res://Assets/ui/simple_buttons/simple_button_round_arrow_press.svg")
	},
	UIElementTypes.ROUND_ARROW_BUTTON_MIRRORED: {
		"normal": preload("res://Assets/ui/simple_buttons/simple_button_round_arrow_normal_mirrored.svg"),
		"hover": preload("res://Assets/ui/simple_buttons/simple_button_round_arrow_hover_mirrored.svg"),
		"pressed": preload("res://Assets/ui/simple_buttons/simple_button_round_arrow_press_mirrored.svg")
	},
	UIElementTypes.RESET_BUTTON: {
		"normal": preload("res://Assets/ui/simple_buttons/simple_button_round_reset_normal.svg"),
		"hover": preload("res://Assets/ui/simple_buttons/simple_button_round_reset_hover.svg"),
		"pressed": preload("res://Assets/ui/simple_buttons/simple_button_round_reset_press.svg")
	},
	UIElementTypes.ANSWER_BACKGROUND: {
		"normal": preload("res://Assets/ui/frames/answers/answer_background.svg"),
		"hover": preload("res://Assets/ui/frames/answers/answer_background_hover.svg"),
		"pressed": preload("res://Assets/ui/frames/answers/answer_background_press.svg")
	}
}

# add all backgrounds here
const MINIGAME_BACKGROUNDS = {
	"Minigame1": preload("res://Assets/backgrounds/minigame_1.png"),
	"Minigame2": preload("res://Assets/backgrounds/minigame_2.png"),
	"Minigame3": preload("res://Assets/backgrounds/minigame_3.png"),
	"Minigame4": preload("res://Assets/backgrounds/minigame_4.png")
}
const CONTAINER_TEXTURE = preload("res://Assets/ui/frames/simple_question_frame.svg")

const SEQUENCE_CARDS = {
	"end_hover": preload("res://Assets/ui/sequence_cards/sequence_card_end_hover.svg"),
	"end": preload("res://Assets/ui/sequence_cards/sequence_card_end.svg"),
	"start_hover": preload("res://Assets/ui/sequence_cards/sequence_card_start_hover.svg"),
	"start": preload("res://Assets/ui/sequence_cards/sequence_card_start.svg"),
	"normal_hover": preload("res://Assets/ui/sequence_cards/sequence_card_hover.svg"),
	"normal": preload("res://Assets/ui/sequence_cards/sequence_card.svg")
}
	

static func create_label(text: String) -> Dictionary:
	var root := MarginContainer.new()
	root.add_theme_constant_override("margin_left", UIConst.MARGIN_DEFAULT)
	root.add_theme_constant_override("margin_top", UIConst.MARGIN_DEFAULT)
	root.add_theme_constant_override("margin_right", UIConst.MARGIN_DEFAULT)
	root.add_theme_constant_override("margin_bottom", UIConst.MARGIN_DEFAULT)
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
	margin.add_theme_constant_override("margin_left", UIConst.MARGIN_DEFAULT)
	margin.add_theme_constant_override("margin_top", UIConst.MARGIN_DEFAULT)
	margin.add_theme_constant_override("margin_right", UIConst.MARGIN_DEFAULT)
	margin.add_theme_constant_override("margin_bottom", UIConst.MARGIN_DEFAULT)
	root.add_child(margin)

	var style := StyleBoxFlat.new()
	style.bg_color = UIConst.COLOR_CODE_BG
	style.corner_radius_top_left = UIConst.CORNER_RADIUS_DEFAULT
	style.corner_radius_top_right = UIConst.CORNER_RADIUS_DEFAULT
	style.corner_radius_bottom_left = UIConst.CORNER_RADIUS_DEFAULT
	style.corner_radius_bottom_right = UIConst.CORNER_RADIUS_DEFAULT
	style.border_width_left = UIConst.CODE_SNIPPET_BORDER_WIDTH
	style.border_width_top = UIConst.CODE_SNIPPET_BORDER_WIDTH
	style.border_width_right = UIConst.CODE_SNIPPET_BORDER_WIDTH
	style.border_width_bottom = UIConst.CODE_SNIPPET_BORDER_WIDTH
	style.border_color = UIConst.COLOR_CODE_BORDER

	root.add_theme_stylebox_override("panel", style)

	var layout := VBoxContainer.new()
	margin.add_child(layout)

	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, UIConst.CODE_SNIPPET_HEADER_HEIGHT)
	layout.add_child(header)

	var title_label := Label.new()
	title_label.text = "</>  " + title
	title_label.add_theme_color_override("font_color", UIConst.COLOR_CODE_ACCENT)
	header.add_child(title_label)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	var file_label := Label.new()
	file_label.text = file_name
	file_label.add_theme_color_override("font_color", UIConst.COLOR_CODE_FILENAME)
	header.add_child(file_label)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(body)

	var line_numbers := Label.new()
	line_numbers.text = _make_line_numbers(code_text)
	line_numbers.add_theme_color_override("font_color", UIConst.COLOR_CODE_LINE_NUMBERS)
	line_numbers.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	line_numbers.custom_minimum_size = Vector2(UIConst.LINE_NUMBER_WIDTH, 0)
	body.add_child(line_numbers)

	var code_label := RichTextLabel.new()
	code_label.bbcode_enabled = true
	code_label.fit_content = true
	code_label.scroll_active = false
	code_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	code_label.text = "[font_size=%d][color=%s]" % [UIConst.CODE_SNIPPET_FONT_SIZE, UIConst.COLOR_CODE_TEXT] + _escape_bbcode(code_text) + "[/color][/font_size]"
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
static func create_texture_button(type: UIElementTypes, size: Vector2 = UIConst.BUTTON_SIZE_SMALL, text: String = "") -> Dictionary:
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
	margin.add_theme_constant_override("margin_left", UIConst.MARGIN_PANEL)
	margin.add_theme_constant_override("margin_top", UIConst.MARGIN_PANEL)
	margin.add_theme_constant_override("margin_right", UIConst.MARGIN_PANEL)
	margin.add_theme_constant_override("margin_bottom", UIConst.MARGIN_PANEL_BOTTOM)
	root.add_child(margin)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", UIConst.SEPARATION_DEFAULT)
	margin.add_child(layout)

	var header := VBoxContainer.new()
	#header.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var content := CenterContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var footer := VBoxContainer.new()
	

	layout.add_child(header)
	layout.add_child(content)
	layout.add_child(footer)	
	
	var style := StyleBoxTexture.new()
	style.texture = CONTAINER_TEXTURE
	style.texture_margin_left = UIConst.TEXTURE_MARGIN
	style.texture_margin_right = UIConst.TEXTURE_MARGIN
	style.texture_margin_top = UIConst.TEXTURE_MARGIN
	style.texture_margin_bottom = UIConst.TEXTURE_MARGIN
	root.add_theme_stylebox_override("panel", style)

	return {
		"root": root,
		"header": header,
		"content": content,
		"footer": footer
	}

static func create_ordering_container(size: Vector2 = UIConst.ORDERING_CARD_SIZE) -> Dictionary:

	var root = PanelContainer.new()
	root.custom_minimum_size = size

	var start = StyleBoxTexture.new()
	var middle = StyleBoxTexture.new()
	var end = StyleBoxTexture.new()
	var start_hover = StyleBoxTexture.new()
	var middle_hover = StyleBoxTexture.new()
	var end_hover = StyleBoxTexture.new()
	start.texture = SEQUENCE_CARDS.get("start")
	start_hover.texture = SEQUENCE_CARDS.get("start_hover")
	end.texture = SEQUENCE_CARDS.get("end")
	end_hover.texture = SEQUENCE_CARDS.get("end_hover")
	middle.texture = SEQUENCE_CARDS.get("normal")
	middle_hover.texture = SEQUENCE_CARDS.get("normal_hover")


	return {
		"root": root,
		"normal": [start, middle, end],
		"hover":  [start_hover, middle_hover, end_hover]
	}

static func create_colored_panel_container(
	size: Vector2 = UIConst.COLORED_PANEL_SIZE,
	bg_color: Color = UIConst.COLORED_PANEL_DEFAULT_COLOR,
	corner_radius: int = UIConst.COLORED_PANEL_DEFAULT_RADIUS,
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

	root.custom_minimum_size = UIConst.BG_SIZE
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	root.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

	return {
		"root": root
	}