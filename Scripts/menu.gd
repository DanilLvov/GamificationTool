extends Node2D

enum GameState {
	# Different states for different points of the game, when switched between states UI should be updated (f.E. disable some buttons etc.)
	START,
	CUTSCENE,
	MINIGAME,
	SPECIALIZATION_CHOICE,
	END
}

# TODO: game_sequence needs to be read from json
var game_sequence = {
	"start": { "state": GameState.START, "next_scene": "intro_cutscene" },
	"intro_cutscene": { "state": GameState.CUTSCENE, "next_scene": "specialisation_choice" },
	"specialisation_choice": { "state": GameState.SPECIALIZATION_CHOICE, "next_scene": "minigame_1"},
	"minigame_1": { "state": GameState.MINIGAME, "next_scene": "cutscene_1_success", "next_scene_fail": "cutscene_1_fail" },
	"cutscene_1_success": { "state": GameState.CUTSCENE, "next_scene": "end_cutscene"},
	"cutscene_1_fail": { "state": GameState.CUTSCENE, "next_scene": "end"},
	# TODO: ability to choose bad and good ending
	"end_cutscene": { "state": GameState.CUTSCENE, "next_scene": "end", "condition": 3,},
	"bad_end_cutscene": { "state": GameState.CUTSCENE, "next_scene": "end", "condition": 3},
	"end": { "state": GameState.END}
}
	

# Node variables, if changing node name, change it here:
#@onready var spaceship = $SpaceShip
@onready var cutscene_manager = $CutsceneDummy
@onready var minigame_manager = $MiniGame
@onready var start_button = $StartButton
@onready var restart_button = $RestartButton
@onready var restart_menu = $RestartMenu


var current_scene: String
var current_minigame: int

func _ready() -> void:
	# Connecting signals
	# Start button clicked
	start_button.button_down.connect(_next_game_step)
	# Finished Minigame or cutscene
	minigame_manager.finished.connect(_next_game_step) # TODO: add success or fail functions for minigame
	cutscene_manager.finished.connect(_next_game_step)
	current_scene = "start"

	_run_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# If failed a Minigame get fail cutscene
func _failed_minigame() -> void:
	current_scene = game_sequence.get(current_scene).get("next_scene_fail")
	_run_current_scene()

func _next_game_step() -> void:
	current_scene = game_sequence.get(current_scene).get("next_scene")
	_run_current_scene()

func _run_current_scene() -> void:
	#hidding all objects, to show only used for the current game step
	_hide_all_objects()

	match game_sequence.get(current_scene).get("state"):
		GameState.START:
			start_button.visible = true
		GameState.CUTSCENE:
			cutscene_manager.visible = true
			cutscene_manager._launch_scene(current_scene)
		GameState.MINIGAME:
			minigame_manager.visible = true
		GameState.SPECIALIZATION_CHOICE:
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