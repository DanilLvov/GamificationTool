class_name Cutscene
extends Node2D

## Dokumentation
#TODO add Documentation

signal finished

var cutscenes: Dictionary
var animations: Dictionary

var timer = 0.0

# Node variables, if changing node name, change it here:
@onready var _background = $Background
@onready var _subtitles = $UiElements/Subtitles
@onready var _animation_objects = $AnimationObjects
var _continue
#@onready var _ui_elements = $UiElements

# Subtitles box position/size as authored in the scene, used whenever a
# cutscene doesn't specify its own subtitles_position_x/y or subtitles_width/height.
var _default_subtitles_position: Vector2
var _default_subtitles_size: Vector2

# Global cutscene structure variable
var current_cutscene = {
	"id": 0,
	"name": "",
	"subtitles": "",
	"subtitles_position_x": null,
	"subtitles_position_y": null,
	"subtitles_width": null,
	"subtitles_height": null,
	"background_image_path": "",
	"objects": []
}

var animation_object_connections = []

# Set while the subtitle typewriter is running; a mouse click sets this to
# reveal the rest of the text immediately instead of waiting it out.
var _skip_typing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load cutscene and animation data from JSON files
	cutscenes = _load_JSON("res://Database/cutscenes.json")
	animations = _load_JSON("res://Database/animations.json")

	_default_subtitles_position = _subtitles.position
	_default_subtitles_size = _subtitles.size

	_continue = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(200, 30), "Continue")
	_continue["button"].pressed.connect(_on_continue_texture_button_pressed)
	_continue["root"].position = Vector2(1700, 930)

	add_child(_continue["root"])
	_continue["root"].visible = false


# A mouse click skips the rest of the subtitle typewriter effect
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_skip_typing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update timer for keyframes and update aniamtion objects if they have an animation connected
	timer += delta
	for animation_object in _animation_objects.get_children():
		_update_animation_object(animation_object)


# Parsing json with all checks and errors
func _load_JSON(path: String) -> Dictionary:
	var is_cutscene = false

	if not FileAccess.file_exists(path):
		push_error("JSON file not found: %s" % path)
		return {}
	
	if path.contains("cutscene"):
		is_cutscene = true

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

		if is_cutscene:
			if not data.has("name"):
				push_error("Scene '%s' has no name" % id)

			if not data.has("subtitles"):
				push_error("Scene '%s' has no subtitles" % id)
		else:
			# Animation entries: is_loop defaults to false when not specified
			data["is_loop"] = data.get("is_loop", false)

		result[id] = data

	return result


# Get the data for the cutscene that is going to be played from the dictionary
func get_current_cutscene(current_cutscene_id: int):
	var cutscene = cutscenes.get(str(current_cutscene_id))
	if cutscene == null:
		push_error("Cutscene not found: %s" % current_cutscene_id)
		return

	current_cutscene["id"] = current_cutscene_id
	current_cutscene["name"] = cutscene.get("name", "")
	current_cutscene["subtitles"] = cutscene.get("subtitles", "")
	current_cutscene["subtitles_position_x"] = cutscene.get("subtitles_position_x")
	current_cutscene["subtitles_position_y"] = cutscene.get("subtitles_position_y")
	current_cutscene["subtitles_width"] = cutscene.get("subtitles_width")
	current_cutscene["subtitles_height"] = cutscene.get("subtitles_height")
	current_cutscene["background_image_path"] = cutscene.get("backgroundImagePath", "")
	current_cutscene["objects"] = cutscene.get("objects", [])
		
	play_cutscene()


# Button to finish scene and continue
func _on_continue_texture_button_pressed() -> void:
		# Hide continue button after pressing
		_continue["root"].visible = false

		# Animation objects are left in place here on purpose: menu.gd fades
		# the screen to black before starting the next scene, and only then
		# calls get_current_cutscene() again, which is where play_cutscene()
		# clears them. Freeing them here would pop the cutscene away before
		# the fade has covered the screen.
		emit_signal("finished")
		

# Load background image, animation objects and play scene with subtitles
func play_cutscene():
	timer = 0.0
	_continue["root"].visible = false

	# Clear the previous cutscene's animation objects now: this always runs
	# after the screen has already been faded to black by menu.gd, so the
	# swap is never visible.
	for child in _animation_objects.get_children():
		child.queue_free()
	animation_object_connections.clear()

	var background_image_path = current_cutscene["background_image_path"]

	# Background is optional: no path means no background image. Always reset
	# the texture so a previous cutscene's background doesn't linger.
	_background.texture = null
	if background_image_path != "":
		if ResourceLoader.exists(background_image_path):
			_background.texture = load(background_image_path)
		else:
			push_error("Background image not found: %s" % background_image_path)

	var objects = current_cutscene["objects"]

	# Position/size the subtitles box, falling back to the scene's authored
	# defaults if the cutscene doesn't specify its own
	_subtitles.position = Vector2(
		_numeric_or_default(current_cutscene["subtitles_position_x"], _default_subtitles_position.x),
		_numeric_or_default(current_cutscene["subtitles_position_y"], _default_subtitles_position.y)
	)
	_subtitles.size = Vector2(
		_numeric_or_default(current_cutscene["subtitles_width"], _default_subtitles_size.x),
		_numeric_or_default(current_cutscene["subtitles_height"], _default_subtitles_size.y)
	)

	# Load every animation object
	for object in objects:
		if typeof(object) != TYPE_DICTIONARY:
			push_error("Cutscene object must be a dictionary")
			continue

		var object_path = object.get("path", "")
		var position_x = object.get("position_x")
		var position_y = object.get("position_y")
		var object_rotation_value = object.get("rotation")
		var scale_value = object.get("scale")

		# Validate object rotation
		if typeof(object_rotation_value) not in [TYPE_INT, TYPE_FLOAT]:
			push_error("Invalid or missing rotation for object '%s'" % object.get("name"))
			continue
		var object_rotation = float(object_rotation_value)

		# Check if object image path is valid
		if typeof(object_path) != TYPE_STRING or object_path == "" or not ResourceLoader.exists(object_path):
			push_error("Object image not found or path missing: %s" % object_path)
			continue

		# Check if scale/position are valid
		if typeof(position_x) not in [TYPE_INT, TYPE_FLOAT] or typeof(position_y) not in [TYPE_INT, TYPE_FLOAT] or typeof(scale_value) not in [TYPE_INT, TYPE_FLOAT]:
			push_error("Invalid or missing position/scale for object '%s'" % object.get("name"))
			continue

		# Create a new unique Sprite2D node for every animation object in scene as child of animation objects parent node
		var animation_object = Sprite2D.new()
		animation_object.name = object.get("name", "")
		animation_object.texture = load(object_path)
		animation_object.rotation_degrees = object_rotation
		animation_object.global_position = Vector2(position_x, position_y)
		animation_object.scale = Vector2(scale_value, scale_value)
		if object.has("z_index"):
			animation_object.z_index = int(object.get("z_index"))

		# Add to the tree first: if another object already used this name,
		# Godot renames this node to stay unique among siblings. Reading
		# .name only after add_child() ensures the connection matches the
		# object's actual final name.
		_animation_objects.add_child(animation_object)

		if object.get("hasAnimation", false) == true and object.has("animationId"):
			animation_object_connections.append({
			"object_name": animation_object.name,
			"animation_id": object.get("animationId"),
			"base_position": animation_object.global_position,
			"base_scale": scale_value,
			"base_rotation": object_rotation
			})

	# Animate every character in subtitles string; a mouse click skips
	# straight to the full text instead of waiting out the rest
	var characters = current_cutscene["subtitles"].split()
	var text = ""
	_subtitles.text = text
	_skip_typing = false

	await get_tree().create_timer(0.05).timeout

	for character in characters:
		if _skip_typing:
			break
		text += character
		_subtitles.text = text
		await get_tree().create_timer(0.05).timeout

	if _skip_typing:
		_subtitles.text = current_cutscene["subtitles"]

	# Show continue button at end of cutscene
	_continue["root"].visible = true


# If aniamtion exists, call update functions for position, scale, rotation and alternate image.
# Keyframes in animations.json are offsets from the object's own spawn
# position/scale/rotation (its first keyframe is always 0), not absolute
# values, so the same animation can be reused by objects placed anywhere.
func _update_animation_object(animation_object: Sprite2D):
	#print("Update:", animation_object.name)

	var connection = _get_connection(animation_object.name)
	if connection == null:
		return

	var animation_data = animations.get(str(connection["animation_id"]))

	if animation_data == null:
		push_error("Animation not found: " + str(connection["animation_id"]))
		return

	_update_position(animation_object, animation_data, connection["base_position"])
	_update_scale(animation_object, animation_data, connection["base_scale"])
	_update_rotation(animation_object, animation_data, connection["base_rotation"])
	_update_alternate_image(animation_object, animation_data)


# Get the connection entry (animation id + base transform) for an animation
# object by its name from the connections list
func _get_connection(object_name: String):
	for connection in animation_object_connections:
		if connection["object_name"] == object_name:
			return connection
	return null


# Update position of animation object: interpolate the keyframe offsets and
# add them to the object's base position
func _update_position(animation_object: Sprite2D, animation_data: Dictionary, base_position: Vector2):
	var positions = animation_data.get("position", [])

	if positions.size() < 2:
		return

	var current_time = timer

	if animation_data.get("is_loop", false):
		var last_time = float(positions[positions.size() - 1]["time"])
		if last_time > 0:
			current_time = fmod(timer, last_time)

	for i in range(positions.size() - 1):
		var start_key = positions[i]
		var end_key = positions[i + 1]

		var start_time = float(start_key["time"])
		var end_time = float(end_key["time"])

		if current_time >= start_time and current_time <= end_time:
			var progress = (current_time - start_time) / (end_time - start_time)

			var start_offset = Vector2(
				start_key["coordinates"][0],
				start_key["coordinates"][1]
			)

			var end_offset = Vector2(
				end_key["coordinates"][0],
				end_key["coordinates"][1]
			)

			animation_object.global_position = base_position + start_offset.lerp(
				end_offset,
				progress
			)

			return


# Update scale of animation object: interpolate the keyframe offsets and add
# them to the object's base scale
func _update_scale(animation_object: Sprite2D, animation_data: Dictionary, base_scale: float):
	#print("SCALE", timer)
	var scales = animation_data.get("scale", [])

	if scales.size() < 2:
		return

	var last_time = float(scales[scales.size() - 1]["time"])
	var current_time = timer

	if animation_data.get("is_loop", false):
		current_time = fmod(timer, last_time)

	for i in range(scales.size() - 1):
		var start_key = scales[i]
		var end_key = scales[i + 1]

		var start_time = float(start_key["time"])
		var end_time = float(end_key["time"])

		if current_time >= start_time and current_time <= end_time:
			var progress = (current_time - start_time) / (end_time - start_time)

			var offset = lerpf(
				float(start_key["scale"]),
				float(end_key["scale"]),
				progress
			)

			var value = base_scale + offset
			animation_object.scale = Vector2(value, value)

			return


# Update rotation of animation object: interpolate the keyframe offsets and
# add them to the object's base rotation
func _update_rotation(animation_object: Sprite2D, animation_data: Dictionary, base_rotation: float):
	var rotations = animation_data.get("rotation", [])

	if rotations.size() < 2:
		return

	var last_time = float(rotations[rotations.size() - 1]["time"])
	var current_time = timer

	if animation_data.get("is_loop", false):
		current_time = fmod(timer, last_time)

	for i in range(rotations.size() - 1):
		var start_key = rotations[i]
		var end_key = rotations[i + 1]

		var start_time = float(start_key["time"])
		var end_time = float(end_key["time"])

		if current_time >= start_time and current_time <= end_time:
			var progress = (current_time - start_time) / (end_time - start_time)

			var offset = lerpf(
				float(start_key["rotation"]),
				float(end_key["rotation"]),
				progress
			)

			animation_object.rotation_degrees = base_rotation + offset

			return


# Update alternate image of animation object 
func _update_alternate_image(animation_object: Sprite2D, animation_data: Dictionary):
	var images = animation_data.get("alternate_image", [])

	if images.is_empty():
		return

	var current_time = timer

	if animation_data.get("is_loop", false):
		var last_time = float(images[images.size() - 1]["time"])
		if last_time > 0:
			current_time = fmod(timer, last_time)

	for image_data in images:
		if current_time >= float(image_data["time"]):
			var path = image_data.get("path", "")

			if path != "" and ResourceLoader.exists(path):
				animation_object.texture = load(path)

# Returns value as a float if it's a valid number, otherwise the given default
func _numeric_or_default(value, default: float) -> float:
	if typeof(value) in [TYPE_INT, TYPE_FLOAT]:
		return float(value)
	return default