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
@onready var minigame_manager := $MinigameController
@onready var cutscene_manager := $Cutscene
@onready var start_button := $StartScreen/StartButton
@onready var start_label: Node = $StartScreen/StartLabel
@onready var restart_button := $RestartButton
@onready var restart_menu := $RestartMenu
@onready var start_screen := $StartScreen
@onready var job_screen: Node = $JobSelection
@onready var restart_warning := $RestartWarning
@onready var end_screen := $GameEnd


# Restart timer vars:
# TODO: add important vars into config.json
var idle_timeout := 60.0
var restart_warning_time := 10.0
var warning_shown := false
var idle_time_left: float

var current_scene_id: int
var current_minigame: int
var timeline: Dictionary
var selected_job: String = "SOFTWAREENTWICKLUNG"

func _ready() -> void:
	#loading game sequence from json file
	timeline = _load_timeline("res://Database/timeline.json")

	# Connecting signals for finished minigame or cutscene
	minigame_manager.finished.connect(_next_game_step)
	minigame_manager.failed.connect(_failed_minigame)
	cutscene_manager.finished.connect(_next_game_step)
	job_screen.job_chosen.connect(_next_game_step)
	current_scene_id = 0
	current_minigame = 1

	_reset_idle_timer()
	_run_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	idle_time_left -= delta
	if idle_time_left < restart_warning_time:
		if not warning_shown:
			warning_shown = true
			restart_warning.visible = true
		if idle_time_left < 0.0:
			_on_idle_timeout()
	

# Parsing timeline json with all checks and errors
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
	start_button.visible = false
	start_label.visible = false
	var _waiter = await start_screen._start_pressed()
	_next_game_step()


# If failed a Minigame get fail cutscene
func _failed_minigame() -> void:
	# for timeline_object in game_sequence["timelineObjects"]:
	# 	if timeline_object["id"] == current_scene_id:
	# 		current_scene_id = timeline_object["next_scene_fail"]
	# 		break
	current_scene_id = timeline.get(str(current_scene_id)).get("next_scene_fail")
	print(current_scene_id)
	_run_current_scene()


func _next_game_step(jump_to_scene: bool = false, jump_id: int = 0, minigame_id: int = 0) -> void:
	# for timeline_object in game_sequence["timelineObjects"]:
	# 	if timeline_object["id"] == current_scene_id:
	# 		current_scene_id = timeline_object["next_scene"]
	# 		break
	if jump_to_scene:
		current_scene_id = jump_id
		if minigame_id != 0:
			current_minigame = minigame_id
	else:
		current_scene_id = timeline.get(str(current_scene_id)).get("next_scene")
	print(current_scene_id)
	_run_current_scene()


func _run_current_scene() -> void:
	print("running")
	# var current_scene_state
	# var cutscene_id
	#hidding all objects, to show only used for the current game step
	_hide_all_objects()
	# for timeline_object in game_sequence["timelineObjects"]:
	# 	if timeline_object["id"] == current_scene_id:
	# 		current_scene_state = timeline_object["state"]
	# 		if current_scene_state == "GameState.CUTSCENE":
	# 			cutscene_id = timeline_object["cutscene_id"]
	# 		break
	# print(current_scene_state)

	
	match timeline.get(str(current_scene_id)).get("state"):
		GameState.START:
			start_screen.visible = true
		GameState.CUTSCENE:
			cutscene_manager.visible = true
			cutscene_manager.get_current_cutscene(timeline.get(str(current_scene_id)).get("cutscene_id"))
		GameState.MINIGAME:
			minigame_manager.visible = true
			minigame_manager._draw_minigame(current_minigame)
		GameState.SPECIALIZATION_CHOICE:
			job_screen.visible = true
			#_next_game_step()
		GameState.END:
			end_screen.visible = true

# TODO: Add every new scene object to this function but we never hide restart button
func _hide_all_objects() -> void:
	end_screen.visible = false
	start_screen.visible = false
	minigame_manager.visible = false
	cutscene_manager.visible = false
	job_screen.visible = false

# Restart functionality 
func _restart_game() -> void:
	start_screen.process_mode = Node.PROCESS_MODE_DISABLED
	minigame_manager.process_mode = Node.PROCESS_MODE_DISABLED
	cutscene_manager.process_mode = Node.PROCESS_MODE_DISABLED
	job_screen.process_mode = Node.PROCESS_MODE_DISABLED
	restart_menu.visible = true

func _restart_menu_yes_pressed() -> void:
	get_tree().reload_current_scene()

func _restart_menu_no_pressed() -> void:
	start_screen.process_mode = Node.PROCESS_MODE_INHERIT
	minigame_manager.process_mode = Node.PROCESS_MODE_INHERIT
	cutscene_manager.process_mode = Node.PROCESS_MODE_INHERIT
	job_screen.process_mode = Node.PROCESS_MODE_INHERIT
	restart_menu.visible = false

# Idle Timer 
func _reset_idle_timer() -> void:
	warning_shown = false
	restart_warning.visible = false
	idle_time_left = idle_timeout

func _on_idle_timeout() -> void:
	_restart_menu_yes_pressed()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_reset_idle_timer()
	elif event is InputEventKey and event.pressed:
		_reset_idle_timer()
	elif event is InputEventScreenTouch and event.pressed:
		_reset_idle_timer()
	elif event is InputEventMouseMotion:
		_reset_idle_timer()

	# Handling escape Button and debug button
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("exit"):
			get_tree().quit()

