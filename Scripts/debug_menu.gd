extends Control

@onready var debug_menu_button = $ShowDebugButton
@onready var return_button = $Return
@onready var menu_grid = $CenterContainer/Grid
@onready var grid_center_container = $CenterContainer
var first_use: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
 
func _on_show_debug_menu_pressed() -> void:
	if (first_use):
		first_use = false
		var id = 0
		var timeline: Array[TimelineObject] = get_parent().timeline
		menu_grid.columns = int(sqrt(timeline.size()))
		for object in timeline:
			var text = object._name

			var button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(120, 50), text)
			button["button"].button_down.connect(_grid_button_pressed.bind(id)) 
			menu_grid.add_child(button["root"])
			id += 1

	debug_menu_button.visible = false
	return_button.visible = true
	grid_center_container.visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_skip_minigame_pressed() -> void:
	get_parent().minigame_manager._skip_answer()
	pass

func _on_show_return_button() -> void:
	debug_menu_button.visible = true
	return_button.visible = false
	grid_center_container.visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _grid_button_pressed(timeline_id: int) -> void:
	get_parent()._next_game_step(true, timeline_id)
	_on_show_return_button()

