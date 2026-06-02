extends RefCounted
class_name UIFactory

# TODO: Add Fonts here: 
# const FONT_MAIN

# TODO add
enum UIElementTypes {
	NORMAL_BUTTON

}
# TODO(optional): load list of resources from directory
const BUTTONS = {
	UIElementTypes.NORMAL_BUTTON: {
		"normal": preload("res://assets/ui/Simple_Buttons/simple_button_normal.svg"),
		"hover": preload("res://assets/ui/Simple_Buttons/simple_button_hover.svg"),
		"pressed": preload("res://assets/ui/Simple_Buttons/simple_button_press.svg")
	}

}

const CONTAINER_TEXTURE = preload("res://assets/ui/Frames/frame_0.1V2.svg")

static func create_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

static func create_texture_button(type: UIElementTypes, size: Vector2 = Vector2(120, 50), text: String = "") -> Control:


	var button : TextureButton = TextureButton.new()
	button.texture_normal = BUTTONS.get(type).get("normal")
	button.texture_hover = BUTTONS.get(type).get("hover")
	button.texture_pressed = BUTTONS.get(type).get("pressed")
	button.custom_minimum_size = size
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	


	if text != "":
		var label := Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.anchor_right = 1.0
		label.anchor_bottom = 1.0

		# var font = _load_res(FONT_MAIN)
		# if font:
		# 	label.add_theme_font_override("font", font)

		button.add_child(label)

	return button


static func create_panel_container(size: Vector2) -> Dictionary:
	var root := PanelContainer.new()
	root.custom_minimum_size = size
	root.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	root.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_top", 60)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_bottom", 60)
	root.add_child(margin)

	var layout := VBoxContainer.new()
	margin.add_child(layout)

	var header := CenterContainer.new()

	var content := CenterContainer.new()
	#content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var footer := CenterContainer.new()
	

	layout.add_child(header)
	layout.add_child(content)
	layout.add_child(footer)

	
	# var style := StyleBoxTexture.new()
	# style.texture = CONTAINER_TEXTURE
	# root.add_theme_stylebox_override("panel", style)

	return {
		"root": root,
		"header": header,
		"content": content,
		"footer": footer
	}