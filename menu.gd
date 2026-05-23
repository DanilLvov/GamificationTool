extends Node2D

enum GameState {
	# Different states for different points of the game, when switched between states UI should be updated (f.E. disable some buttons etc.)
	START,
	SPACESHIP,
	CUTSCENE,
	MINIGAME,
	FACH
}

signal finished #for finished cutscenes and minigames
# test
# TODO: game_sequence needs to be read from json
var game_sequence = [
	{ "type": "screen", "id": GameState.START },
	{ "type": "cutscene", "id": "intro" },
	{ "type": "screen", "id": GameState.FACH },
	{ "type": "screen", "id": GameState.SPACESHIP },
	{ "type": "minigame", "id": 1 },
	{ "type": "screen", "id": GameState.SPACESHIP },
	{ "type": "minigame", "id": 2 },
	{ "type": "screen", "id": GameState.SPACESHIP },
	{ "type": "minigame", "id": 3 },
	{ "type": "screen", "id": GameState.SPACESHIP },
	{ "type": "minigame", "id": 4 },
	{ "type": "screen", "id": GameState.SPACESHIP },
	{ "type": "minigame", "id": 5 },
	{ "type": "cutscene", "id": "end" },
]

# Node variables, if changing node name, change it here:
@onready var spaceship = $SpaceShip
@onready var engine_room = $SpaceShip/Room1
@onready var kitchen_room = $SpaceShip/Room2
@onready var control_room = $SpaceShip/Room3
@onready var start_button = $StartButton

var current_state: int
var current_minigame: int

func _ready() -> void:
	# Connecting signals
	# Mouse entered
	# TODO: add more rooms
	engine_room.mouse_entered.connect(_on_room_mouse_entered.bind(1))
	kitchen_room.mouse_entered.connect(_on_room_mouse_entered.bind(2))
	control_room.mouse_entered.connect(_on_room_mouse_entered.bind(3))
	# Mouse exited
	engine_room.mouse_exited.connect(_on_room_mouse_exited.bind(1))
	kitchen_room.mouse_exited.connect(_on_room_mouse_exited.bind(2))
	control_room.mouse_exited.connect(_on_room_mouse_exited.bind(3))
	# Mouse clicked
	engine_room.input_event.connect(_on_room_input_event.bind(1))
	kitchen_room.input_event.connect(_on_room_input_event.bind(2))
	control_room.input_event.connect(_on_room_input_event.bind(3))
	# Start button clicked
	start_button.button_down.connect(_next_step)
	# Finished Minigame or cutscene
	finished.connect(_next_step)

	current_state = -1
	current_minigame = 1

	_next_step()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _next_step() -> void:
	current_state += 1
	match game_sequence[current_state]["type"]:
		"screen":
			_change_game_state(game_sequence[current_state]["id"])
		"cutscene":
			_change_game_state(GameState.CUTSCENE)
			_do_cutscene(game_sequence[current_state]["id"])
		"minigame":
			_change_game_state(GameState.MINIGAME)
			_do_minigame(game_sequence[current_state]["id"])

	

	
# Hidding and showing game objects used in current state
func _change_game_state(new_state: GameState) -> void:
	match new_state:
		GameState.START:
			start_button.visible = true
			spaceship.visible = false
		GameState.SPACESHIP:
			start_button.visible = false
			spaceship.visible = true
		GameState.CUTSCENE:
			start_button.visible = false
			spaceship.visible = false
		GameState.MINIGAME:
			start_button.visible = false
			spaceship.visible = false
		GameState.FACH:
			start_button.visible = false
			#TODO: add buttons for Fach Auswahl
			_next_step()
	
# hover on rooms
func _on_room_mouse_entered(room_id: int) -> void:
	match room_id:
		1:
			engine_room.get_node("RoomHover").visible = true
		2:
			kitchen_room.get_node("RoomHover").visible = true
		3:
			control_room.get_node("RoomHover").visible = true
	pass # Replace with function body.

func _on_room_mouse_exited(room_id: int) -> void:
	match room_id:
		1:
			engine_room.get_node("RoomHover").visible = false
		2:
			kitchen_room.get_node("RoomHover").visible = false
		3:
			control_room.get_node("RoomHover").visible = false
	pass # Replace with function body.

func _on_room_input_event(viewport: Node, event: InputEvent, shape_idx: int, room_id: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				if room_id == current_minigame:
					_next_step()
				elif room_id > current_minigame:
					print("room_locked")
				else:
					print("room_completed")
				


# Dummy functions for minigames, cutscenes, etc
func _do_cutscene(id: String) -> void:
	print("playing cutscene " + id)
	await get_tree().create_timer(1.0).timeout
	emit_signal("finished")

# Dummy functions for minigames, cutscenes, etc
func _do_minigame(id: int) -> void:
	print("playing minigame " + str(id))
	await get_tree().create_timer(1.0).timeout
	current_minigame += 1
	emit_signal("finished")

func _restart_game() -> void:
	print("game_ended")