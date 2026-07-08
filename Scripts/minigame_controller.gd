extends Control  

@onready var _event_feedback_frame = $EventFeedbackFrame
@onready var _event_feedback_frame_panel = $EventFeedbackFrame/EventFeedbackFramePanel
@onready var _texture_progress_bar = $TextureProgressBar
@onready var _lives_hbox_container = $LivesHBoxContainer

# const values used throughout controller, better to read from separate file
const _life_texture_path = preload("res://Assets/objects/astronaut_life.png")
const _life_lost_texture_path = preload("res://Assets/objects/astronaut_life_lost.png")
const _default_minigame_timer = 0.5
const debug = true
const _win_color = Color.GREEN
const _loose_color = Color.RED

# GLOBAL VARIABLES
signal failed
signal finished
var current_question: int
var current_minigame: MinigameObject
const margin_default  := 20

# nodes
@onready var _minigame_container := $MinigameContent

var minigames: Array[MinigameObject]

var lives = 3

var selected_job
var filtered_questions = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for live in lives:
		var heart = TextureRect.new()
		heart.texture = _life_texture_path
		heart.scale = Vector2(0.25, 0.25)
		_lives_hbox_container.add_child(heart)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func load_minigames(minigame_json_path):
	minigames = MinigameObject.load_minigame_array(minigame_json_path)


# MINIGAME CREATION
# splitted into 3 levels: (minigame, question, content)
# minigame (whole minigame from start to finish)
func _draw_minigame(id: int) -> void:
	for child in _minigame_container.get_children():
		child.queue_free()

	var bg_path = minigames[id]._background_image_path
	var minigame_bg = UIFactory.create_background(bg_path)

	_minigame_container.add_child(minigame_bg["root"])
	var game = get_parent()
	selected_job = game.selected_job
	current_question = 0

	_event_feedback_frame.visible = false
	_event_feedback_frame_panel.set_anchors_preset(Control.PRESET_FULL_RECT)

	_texture_progress_bar.value = 0
	
	# TODO: my idea is to make a minigame flow control here, smth like:
	# draw first question, if answer was correct, draw second, if not play explosion animation and try again
	# probably possible to do via await, or via two functions _answer_corre unknown ct and answer_wrong at the bottom of the script
	current_minigame = minigames[id]
	_texture_progress_bar.max_value = current_minigame._questions_amount
	filtered_questions.clear()
	if debug: print("selected_job = ", selected_job)
	for question in current_minigame._questions:
		if question._job == selected_job:
			filtered_questions.append(question)
	if filtered_questions.size() != current_minigame._questions_amount:
		if debug: push_error("Not enough questions for job %s in minigame %s" % [selected_job, id])

	if filtered_questions.size() > 0:
		filtered_questions[current_question].draw(_minigame_container)
		filtered_questions[current_question].signal_wrong.connect(_answer_wrong)
		filtered_questions[current_question].signal_correct.connect(_answer_correct)


func _on_next_button_pressed() -> void:
	current_question += 1
	if current_question == current_minigame.get("questions_amount"):
		_texture_progress_bar.value = 0
		_completed()
	else:
		if current_question >= filtered_questions.size():
			if debug: push_error("Not enough questions for job %s in minigame %s" % [selected_job, current_minigame.get("name")])
			_completed()
			return
		filtered_questions[current_question].draw(_minigame_container)
		filtered_questions[current_question].signal_wrong.connect(_answer_wrong)
		filtered_questions[current_question].signal_correct.connect(_answer_correct)



# functions for handling failed or completed minigame
func _failed() -> void:
	emit_signal("failed")

func _completed() -> void:
	emit_signal("finished")


# Handling of correct answer
func _answer_correct() -> void:
	_event_feedback_frame.visible = true

	var style = _event_feedback_frame_panel.get_theme_stylebox("panel") as StyleBoxFlat
	style.border_color = _win_color

	_texture_progress_bar.value += 1

	await get_tree().create_timer(_default_minigame_timer).timeout
	_event_feedback_frame.visible = false
	
	filtered_questions[current_question].delete()
	_on_next_button_pressed()

# Handling of wrong answer
func _answer_wrong() -> void:
	_event_feedback_frame.visible = true

	var style = _event_feedback_frame_panel.get_theme_stylebox("panel") as StyleBoxFlat
	style.border_color = _loose_color

	await get_tree().create_timer(_default_minigame_timer).timeout
	_event_feedback_frame.visible = false

	lives -= 1

	_lives_hbox_container.get_child(lives).texture = _life_lost_texture_path
	BaseQuestion._shake_node(_lives_hbox_container.get_child(lives))

	await get_tree().create_timer(_default_minigame_timer).timeout

	if lives < 1:
		_failed()
		return


# used for debug purposes
func _skip_answer() -> void:
	filtered_questions[current_question].delete()
	_on_next_button_pressed()