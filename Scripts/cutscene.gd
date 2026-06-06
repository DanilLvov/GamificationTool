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

# Global cutscene structure variable
var current_cutscene = {
	"id": 0,
	"name": "",
	"subtitles": "",
	"background_image_path": "",
	"objects": []
}

var animation_object_connections = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load cutscene and animation data from JSON files
	cutscenes = _load_JSON("res://Database/cutscenes.json")
	animations = _load_JSON("res://Database/animations.json")

	_continue = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(200, 30), "Continue")
	_continue["button"].pressed.connect(_on_continue_texture_button_pressed)
	_continue["root"].position = Vector2(1700, 930)

	add_child(_continue["root"])
	_continue["root"].visible = false

	
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

			if not data.has("backgroundImagePath"):
				push_error("Scene '%s' has no background image path" % id)

			
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
	current_cutscene["background_image_path"] = cutscene.get("backgroundImagePath", "")
	current_cutscene["objects"] = cutscene.get("objects", [])
		
	play_cutscene()


# Button to finish scene and continue
func _on_continue_texture_button_pressed() -> void:
		# Hide continue button after pressing
		_continue["root"].visible = false

		# Delete all animation objects
		for child in _animation_objects.get_children():
			child.queue_free()

		animation_object_connections.clear()

		# Emit signal, so next scene can be played 
		emit_signal("finished")
		

# Load background image, animation objects and play scene with subtitles
func play_cutscene():
	timer = 0.0
	_continue["root"].visible = false

	var background_image_path = current_cutscene["background_image_path"]

	# Check if path to background image is valid
	if background_image_path == "" or not FileAccess.file_exists(background_image_path):
		push_error("Background image not found or path is missing: %s" % background_image_path)
		return

	# Load background image into scene
	_background.texture = load(background_image_path)

	var objects = current_cutscene["objects"]

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
		if typeof(object_path) != TYPE_STRING or object_path == "" or not FileAccess.file_exists(object_path):
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

		if object.get("hasAnimation") == true and object.has("animationId"):
			animation_object_connections.append({
			"object_name": animation_object.name,
			"animation_id": object.get("animationId")
			})

		_animation_objects.add_child(animation_object)

	# Animate every character in subtitles string
	var characters = current_cutscene["subtitles"].split()
	var text = ""
	_subtitles.text = text

	await get_tree().create_timer(0.05).timeout

	for character in characters:
		text += character
		_subtitles.text = text
		await get_tree().create_timer(0.05).timeout

	# Show continue button at end of cutscene
	_continue["root"].visible = true


# If aniamtion exists, call update functions for position, scale, rotation and alternate image
func _update_animation_object(animation_object: Sprite2D):
	print("Update:", animation_object.name)

	var animation_id = _get_animation_id(animation_object.name)
	if animation_id == null:
		return

	var animation_data = animations.get(str(animation_id))

	if animation_data == null:
		push_error("Animation not found: " + str(animation_id))
		return

	_update_position(animation_object, animation_data)
	_update_scale(animation_object, animation_data)
	_update_rotation(animation_object, animation_data)
	_update_alternate_image(animation_object, animation_data)
	

# Get the animation id for an animation object by its name from the connections list
func _get_animation_id(object_name: String):
	for connection in animation_object_connections:
		if connection["object_name"] == object_name:
			return connection["animation_id"]
	return null


# Update position of animation object and interpolate between keyframes, if there are any
func _update_position(animation_object: Sprite2D, animation_data: Dictionary):
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

			var start_pos = Vector2(
				start_key["coordinates"][0],
				start_key["coordinates"][1]
			)

			var end_pos = Vector2(
				end_key["coordinates"][0],
				end_key["coordinates"][1]
			)

			animation_object.global_position = start_pos.lerp(
				end_pos,
				progress
			)

			return


# Update scale of animation object and interpolate between keyframes, if there are any
func _update_scale(animation_object: Sprite2D, animation_data: Dictionary):
	print("SCALE", timer)
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

			var value = lerpf(
				float(start_key["scale"]),
				float(end_key["scale"]),
				progress
			)

			animation_object.scale = Vector2(value, value)

			return


# Update rotation of animation object and interpolate between keyframes, if there are any
func _update_rotation(animation_object: Sprite2D, animation_data: Dictionary):
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

			animation_object.rotation_degrees = lerpf(
				float(start_key["rotation"]),
				float(end_key["rotation"]),
				progress
			)

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

			if path != "" and FileAccess.file_exists(path):
				animation_object.texture = load(path)