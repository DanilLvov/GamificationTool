@tool # for help https://www.youtube.com/watch?v=z6sUvOBYpT4
extends Node2D
class_name CarouselContainer

@export var spacing: float = 20.0 # pixel between planets

@export var wraparound_enabled: bool = false
@export var wraparound_radius: float = 300.0 # horizontal spacing between child nodes
@export var wraparound_height: float = 50.0 # height of children behind selected child

@export_range(0.0, 1.0) var opacity_strength: float = 0.35 # fadeout speed
@export_range(0.0, 1.0) var scale_strength: float = 0.25 # down scale speed
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1 # minimum size to which children can scale

@export var smoothing_speed: float = 5
@export var selected_index: int = 0 # which child is selected
@export var follow_button_focus: bool = false

@export var position_offset_node: Control = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return

	var selected_wrapped = posmod(selected_index, position_offset_node.get_child_count())

	for i in position_offset_node.get_children():
		var count = position_offset_node.get_child_count()
		var dist = get_wrap_distance(i.get_index(), selected_index, count)
		
		if wraparound_enabled:
			var offset = get_carousel_offset(i.get_index(), selected_index, count)

			var max_index_range = max(1, (count - 1) / 2.0)
			var angle = clamp((offset / max_index_range), -1.0, 1.0) * PI

			var x = sin(angle) * wraparound_radius
			var y = (cos(angle) - 1.0) * wraparound_height

			var target_pos = Vector2(x, y) - i.size / 2.0
			i.position = i.position.lerp(target_pos, smoothing_speed * delta)
		else:
			var item_width = i.size.x + spacing

			var target_pos = Vector2(
				dist * item_width - i.size.x / 2.0,
				-i.size.y / 2.0
			)
			i.position = i.position.lerp(target_pos, smoothing_speed * delta)

		i.pivot_offset = i.size / 2.0
		var target_scale = 1.0 - (scale_strength * abs(dist))
		target_scale = clamp(target_scale, scale_min, 1.0)
		#if i.get_index() == 0 or i.get_index() == 1 or i.get_index() == 29: print(target_scale)
		i.scale = i.scale.lerp(Vector2.ONE * target_scale, smoothing_speed * delta)

		var target_opacity = 1.0 - (opacity_strength * abs(dist))
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed * delta)

		if i.get_index() == selected_wrapped:
			i.z_index = 1
			i.mouse_filter = Control.MOUSE_FILTER_STOP # wenn für Controller support verwendet diese Zeile auskommentieren
			i.focus_mode = Control.FOCUS_ALL # wenn für Controller support verwendet diese Zeile auskommentieren
		else:
			i.z_index = - int(abs(dist))
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE # wenn für Controller support verwendet diese Zeile auskommentieren
			i.focus_mode = Control.FOCUS_NONE # wenn für Controller support verwendet diese Zeile auskommentieren
		
		#if follow_button_focus and i.has_focus():
		#	selected_index = i.get_index()		#für Controller support 
	
	if wraparound_enabled:
		position_offset_node.position.x = lerp(position_offset_node.position.x, 0.0, smoothing_speed * delta)
	else:
		var count = position_offset_node.get_child_count()
		if count > 0:
			var first_child = position_offset_node.get_child(0)
			var item_width = first_child.size.x + spacing
			var total_width = float(count) * item_width
			var visible_width = position_offset_node.size.x
			if visible_width <= 0.0:
				visible_width = total_width

			# center the selected item in the visible area
			var center_offset = (visible_width - item_width) / 2.0
			var target_x = - selected_wrapped * item_width + center_offset

			# clamp so the container doesn't slide everything out of view
			var min_x = min(0.0, visible_width - total_width)
			var max_x = 0.0
			target_x = clamp(target_x, min_x, max_x)

			position_offset_node.position.x = lerp(position_offset_node.position.x, target_x, smoothing_speed * delta)

func _left():
	selected_index -= 1
	selected_index = posmod(selected_index, position_offset_node.get_child_count())

	#if selected_index < 0:
		#selected_index = position_offset_node.get_child_count() - 1

func _right():
	selected_index += 1
	selected_index = posmod(selected_index, position_offset_node.get_child_count())

	#if selected_index > position_offset_node.get_child_count() - 1:
		#selected_index = 0


func get_carousel_offset(index: int, selected: int, count: int) -> int:
	var diff = index - selected

	while diff > count / 2.0:
		diff -= count

	while diff < -count / 2.0:
		diff += count

	return diff

func get_wrap_distance(index: int, selected: int, count: int) -> int:
	var selected_wrapped = posmod(selected, count)

	var diff = index - selected_wrapped

	if diff > count / 2.0:
		diff -= count
	elif diff < -count / 2.0:
		diff += count

	return diff
