extends Node2D

const CONFIG_PATH = "res://Database/config.json"

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
@onready var debug_menu := $DebugMenu
@onready var skip_minigame: = $"DebugMenu/Skip minigame"
@onready var _transition: TransitionOverlay = $TransitionOverlay

var idle_timeout: float
var restart_warning_time: float
var warning_shown := false
var idle_time_left: float
var debug: bool

var current_scene_id: int
var timeline: Array[TimelineObject]
var selected_job: String
var timeleine_json_path: String
var minigame_json_path: String

func _load_config() -> void:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if not file:
		push_error("config.json not found at: " + CONFIG_PATH)
		return
	var cfg: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()

	debug               = cfg.get("debug", false)
	idle_timeout        = cfg.get("idle_timeout_sec", 60.0)
	restart_warning_time = cfg.get("restart_warning_sec", 10.0)
	selected_job        = cfg.get("default_job", "SOFTWAREENTWICKLUNG")
	timeleine_json_path = cfg.get("timeline_path", "res://Database/timeline.json")
	minigame_json_path  = cfg.get("minigame_path", "res://Database/minigames.json")

func _ready() -> void:
	# config stores values like display resolution, debug_mode, other json pathes
	_load_config()

	#loading game sequence from json file


	timeline = TimelineObject.load_timeline_array(timeleine_json_path)
	minigame_manager.load_minigames(minigame_json_path)

	# Connecting signals for finished minigame or cutscene
	minigame_manager.finished.connect(_next_game_step)
	minigame_manager.failed.connect(_failed_minigame)
	cutscene_manager.finished.connect(_next_game_step)
	job_screen.job_chosen.connect(_next_game_step)
	current_scene_id = 0

	# Debuf specific staff
	if debug:
		debug_menu.visible = true
	else:
		debug_menu.visible = false
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
	


func _on_start_button_pressed() -> void:
	var start_pos: Vector2 = start_button.position
	var button_tween := create_tween()
	button_tween.tween_property(start_button, "position", start_pos + Vector2(0, -20), 0.1)
	button_tween.tween_property(start_button, "position", start_pos + Vector2(0, 400), 0.4)

	
	var _waiter = await start_screen._start_pressed()
	start_button.visible = false
	_next_game_step()


# If failed a Minigame get fail cutscene
func _failed_minigame() -> void:
	current_scene_id = timeline[current_scene_id]._next_scene_fail
	_run_current_scene()


func _next_game_step(jump_to_scene: bool = false, jump_id: int = 0) -> void:
	# used only for debug purposes to jump to any scene id
	if jump_to_scene:
		current_scene_id = jump_id
	# normaly jumping to next scene stored in _next_scene 
	else:
		current_scene_id = timeline[current_scene_id]._next_scene
	
	if debug: print("Current scene is: " + str(current_scene_id))
	_run_current_scene()


func _run_current_scene() -> void:
	if timeline[current_scene_id]._has_transition_at_start:
		await _transition.play("black_out")

	_hide_all_objects()

	match timeline[current_scene_id]._state:
		TimelineObject.GameState.START:
			start_screen.visible = true
		TimelineObject.GameState.CUTSCENE:
			cutscene_manager.visible = true
			cutscene_manager.get_current_cutscene(timeline[current_scene_id]._resource_id)
		TimelineObject.GameState.MINIGAME:
			if debug: skip_minigame.visible = true
			minigame_manager.visible = true
			minigame_manager._draw_minigame(timeline[current_scene_id]._resource_id)
		TimelineObject.GameState.SPECIALIZATION_CHOICE:
			job_screen.visible = true
		TimelineObject.GameState.END:
			end_screen.visible = true

	if timeline[current_scene_id]._has_transition_at_start:
		await _transition.play("fade_in")

# TODO: Add every new scene object to this function but we never hide restart button
func _hide_all_objects() -> void:
	# all  debug related things go here
	if debug: skip_minigame.visible = false
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
		if Input.is_action_just_pressed("debug") and debug:
			debug_menu._on_show_debug_menu_pressed()
