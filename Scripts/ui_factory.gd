extends RefCounted
class_name UIFactory

# TODO: Add Fonts here: 
# const FONT_MAIN

# TODO add UI Element types here
enum UIElementTypes {
	NORMAL_BUTTON,
	ROUND_BUTTON,
	RESET_BUTTON
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
	UIElementTypes.RESET_BUTTON: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_round_reset_normal.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_round_reset_hover.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_round_reset_press.svg")
	}

}

const CONTAINER_TEXTURE = preload("res://assets/ui/Frames/frame_0.1V2.svg")

static func create_label(text: String) -> MarginContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_right", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var label := Label.new()
	#label.custom_minimum_size = Vector2(50, 20)
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(label)

	# var font = _load_res(FONT_MAIN)
		# if font:
		# 	label.add_theme_font_override("font", font)

	return margin

# creates button with 3 textures (normal, hovered, pressed), consists of:
# root, button, and optional label (for normal text on button)
static func create_texture_button(type: UIElementTypes, size: Vector2 = Vector2(120, 50), text: String = "") -> Dictionary:

	var root = MarginContainer.new()
	var button : TextureButton = TextureButton.new()
	button.texture_normal = BUTTONS.get(type).get("normal")
	button.texture_hover = BUTTONS.get(type).get("hover")
	button.texture_pressed = BUTTONS.get(type).get("pressed")
	button.custom_minimum_size = size
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	
	root.add_child(button)

	if text != "":
		root.add_child(create_label(text))		


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
	margin.add_child(layout)

	var header := VBoxContainer.new()
	#header.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var content := CenterContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var footer := VBoxContainer.new()
	

	layout.add_child(header)
	layout.add_child(content)
	layout.add_child(footer)

	# TODO: fix CONTAINER_TEXTURE problem
	# var style := StyleBoxTexture.new()
	# style.texture = CONTAINER_TEXTURE
	# root.add_theme_stylebox_override("panel", style)

	return {
		"root": root,
		"header": header,
		"content": content,
		"footer": footer
	}