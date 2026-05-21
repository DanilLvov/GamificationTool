extends Node2D

enum GameState {
	# Different states for different points of the game, when switched between states UI should be updated (f.E. disable some buttons etc.)
	START,
	SPACESHIP,
	CUTSCENE,
	MINIGAME,
	FACH
}

@onready var engine_room = $SpaceShip/Room1
@onready var kitchen_room = $SpaceShip/Room2
@onready var control_room = $SpaceShip/Room3
@onready var start_button = $StartButton

var current_state: GameState

func _ready() -> void:
	current_state = GameState.START
	# Connecting signals
	# Mouse entered
	engine_room.mouse_entered.connect(_on_room_mouse_entered.bind("engine"))
	kitchen_room.mouse_entered.connect(_on_room_mouse_entered.bind("kitchen"))
	control_room.mouse_entered.connect(_on_room_mouse_entered.bind("control"))
	# Mouse exited
	engine_room.mouse_exited.connect(_on_room_mouse_exited.bind("engine"))
	kitchen_room.mouse_exited.connect(_on_room_mouse_exited.bind("kitchen"))
	control_room.mouse_exited.connect(_on_room_mouse_exited.bind("control"))
	# Mouse clicked
	engine_room.input_event.connect(_on_room_input_event.bind("engine"))
	kitchen_room.input_event.connect(_on_room_input_event.bind("kitchen"))
	control_room.input_event.connect(_on_room_input_event.bind("control"))
	# Button Clicked
	start_button.button_down.connect(_on_start_button_pressed)
	
	_change_game_state(GameState.START)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _change_game_state(new_state: GameState) -> void:
	match new_state:
		GameState.START:
			start_button.visible = true
			$SpaceShip.visible = false
			pass
		GameState.SPACESHIP:
			start_button.visible = false
			$SpaceShip.visible = true
			pass
		GameState.CUTSCENE:
			pass
		GameState.MINIGAME:
			pass
		GameState.FACH:
			pass
	
# hover on rooms
func _on_room_mouse_entered(room_id: String) -> void:
	match room_id:
		"engine":
			engine_room.get_node("RoomHover").visible = true
		"kitchen":
			kitchen_room.get_node("RoomHover").visible = true
		"control":
			control_room.get_node("RoomHover").visible = true
	pass # Replace with function body.

func _on_room_mouse_exited(room_id: String) -> void:
	match room_id:
		"engine":
			engine_room.get_node("RoomHover").visible = false
		"kitchen":
			kitchen_room.get_node("RoomHover").visible = false
		"control":
			control_room.get_node("RoomHover").visible = false
	pass # Replace with function body.

func _on_room_input_event(viewport: Node, event: InputEvent, shape_idx: int, room_id: String) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			if event.pressed:
				match room_id:
					"engine":
						print("clicked on engine room")
					"kitchen":
						print("clicked on kitchen")
					"control":
						print("clicked on control room")
	pass # Replace with function body.

func _on_start_button_pressed() -> void:
	_change_game_state(GameState.SPACESHIP)