extends Node2D

enum GameState {
	# Different states for different points of the game, when switched between states UI should be updated (f.E. disable some buttons etc.)
	START,
	CUTSCENE,
	MINIGAME,
	SPECIALIZATION_CHOICE,
	END
}

# Node variables, if changing node name, change it here:
@onready var minigame_manager = $MiniGame
@onready var cutscene_manager = $Cutscene
@onready var start_button = $StartButton
@onready var restart_button = $RestartButton
@onready var restart_menu = $RestartMenu


var current_scene_id: int
var current_minigame: int
var game_sequence

func _ready() -> void:
	#loading game sequence from json file
	game_sequence = read_JSON("res://Database/timeline.json")

	# Connecting signals for finished minigame or cutscene
	minigame_manager.finished.connect(_next_game_step)
	minigame_manager.failed.connect(_failed_minigame)
	cutscene_manager.finished.connect(_next_game_step)
	current_scene_id = 0

	game_sequence = _load_timeline("res://Database/timeline.json")
	print(game_sequence)
	_run_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Parsing json with all checks and errors
func _load_timeline(path: String) -> Dictionary:
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

	for scene_id in parsed.keys():
		var scene_data = parsed[scene_id]
		print(scene_data)
		if typeof(scene_data) != TYPE_DICTIONARY:
			push_error("Scene '%s' must be an object" % scene_id)
			continue

		if not scene_data.has("state"):
			push_error("Scene '%s' has no state" % scene_id)
			continue

		var state_name: String = scene_data["state"]

		if not GameState.has(state_name):
			push_error("Unknown state '%s' in scene '%s'" % [state_name, scene_id])
			continue
		
		scene_data["state"] = GameState[state_name]
		result[scene_id] = scene_data

	return result


func _on_start_button_pressed() -> void:
	print("pressed start button")
	_next_game_step()


# If failed a Minigame get fail cutscene
func _failed_minigame() -> void:
	for timeline_object in game_sequence["timelineObjects"]:
		if timeline_object["id"] == current_scene_id:
			current_scene_id = timeline_object["next_scene_fail"]
			break
	print(current_scene_id)
	_run_current_scene()


func _next_game_step() -> void:
	for timeline_object in game_sequence["timelineObjects"]:
		if timeline_object["id"] == current_scene_id:
			current_scene_id = timeline_object["next_scene"]
			break
	print(current_scene_id)
	_run_current_scene()


func _run_current_scene() -> void:
	var current_scene_state
	var cutscene_id

	#hidding all objects, to show only used for the current game step
	_hide_all_objects()

	for timeline_object in game_sequence["timelineObjects"]:
		if timeline_object["id"] == current_scene_id:
			current_scene_state = timeline_object["state"]
			if current_scene_state == "GameState.CUTSCENE":
				cutscene_id = timeline_object["cutscene_id"]
			break
	print(current_scene_state)

	match current_scene_state:
		"GameState.START":
			start_button.visible = true
		"GameState.CUTSCENE":
			cutscene_manager.visible = true
			cutscene_manager.get_current_cutscene(cutscene_id)
		"GameState.MINIGAME":
			minigame_manager.visible = true
		"GameState.SPECIALIZATION_CHOICE":
			#TODO: Nils: planet_choice elements need to be shown with: .visible = true
			_next_game_step()

# TODO: Add every new scene object to this function but we never hide restart button
func _hide_all_objects() -> void:
	start_button.visible = false
	minigame_manager.visible = false
	cutscene_manager.visible = false

# Restart functionality
func _restart_game() -> void:
	minigame_manager.process_mode = Node.PROCESS_MODE_DISABLED
	cutscene_manager.process_mode = Node.PROCESS_MODE_DISABLED
	restart_menu.visible = true

func _restart_menu_yes_pressed() -> void:
	get_tree().reload_current_scene()

func _restart_menu_no_pressed() -> void:
	minigame_manager.process_mode = Node.PROCESS_MODE_INHERIT
	cutscene_manager.process_mode = Node.PROCESS_MODE_INHERIT
	restart_menu.visible = false

# TODO: add reset on timer 
