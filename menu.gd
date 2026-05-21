extends Node2D

@onready var engine_room = $SpaceShip/Room1
@onready var kitchen_room = $SpaceShip/Room2
@onready var control_room = $SpaceShip/Room3

func _ready() -> void:
	# Connecting signals
	# Mouse entered
	engine_room.mouse_entered.connect(_on_room_mouse_entered.bind("engine"))
	kitchen_room.mouse_entered.connect(_on_room_mouse_entered.bind("kitchen"))
	control_room.mouse_entered.connect(_on_room_mouse_entered.bind("control"))
	# Mouse exited
	engine_room.mouse_exited.connect(_on_room_mouse_exited.bind("engine"))
	kitchen_room.mouse_exited.connect(_on_room_mouse_exited.bind("kitchen"))
	control_room.mouse_exited.connect(_on_room_mouse_exited.bind("control"))




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
