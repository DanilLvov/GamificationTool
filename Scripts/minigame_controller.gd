extends Control

enum minigame_type {
	SINGLECHOICE,
	MULTICHOICE,
	DRAG_AND_DROP,
	ORDER,
	CONNECT
}

enum content_type {
	CODE_SNIPPET,
	NORMAL_QUESTION,
	IMAGE
}

var minigames := {
	  "0": {
		"name": "Minigame1",
		"questions_amount": 4,
		# TODO: add win/loose message
		"questions":
			[ {
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.SINGLECHOICE,
				"job": "SOFTWAREENTWICKLUNG",
				"extra_content": {
					"text": "Ein Paar total unwichtige aenderungen",
					"content_type": content_type.NORMAL_QUESTION,
				},
				"answers_amount": 4,
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": true
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					}
				}
			},
			{
				"question": "Wie sollte der Post veröffentlicht werden?",
				"question_type": minigame_type.SINGLECHOICE,
				"job": "MARKETING",
				"extra_content": {
					"text": "Neues Feature",
					"content_type": content_type.NORMAL_QUESTION,
				},
				"answers_amount": 4,
				"answers": {
					"0": {
						"text": "Instagram, weil es am schnellsten ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": true
					},
					"1": {
						"text": "Facebook, weil es die größte Reichweite hat.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"2": {
						"text": "Twitter, weil es die beste Plattform für Content ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"3": {
						"text": "Den Post nicht veröffentlichen, weil das Feature noch nicht fertig ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren?",
				"job": "SOFTWAREENTWICKLUNG",
				"question_type": minigame_type.SINGLECHOICE,
				"answers_amount": 6,
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": true
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"4": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"5": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					}
				}
			},
			{
				"question": "Wie sollte der Post veröffentlicht werden?",
				"question_type": minigame_type.SINGLECHOICE,
				"job": "MARKETING",
				"extra_content": {
					"text": "Neues Feature",
					"content_type": content_type.NORMAL_QUESTION,
				},
				"answers_amount": 6,
				"answers": {
					"0": {
						"text": "Instagram, weil es am schnellsten ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": true
					},
					"1": {
						"text": "Facebook, weil es die größte Reichweite hat.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"2": {
						"text": "Twitter, weil es die beste Plattform für Content ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"3": {
						"text": "Den Post nicht veröffentlichen, weil das Feature noch nicht fertig ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"4": {
						"text": "Discord, weil für Gamer.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					},
					"5": {
						"text": "LinkedIn, weil es die beste Plattform für B2B ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"correct": false
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren? antwort ist 3,2,4,0,1",
				"question_type": minigame_type.ORDER,
				"job": "SOFTWAREENTWICKLUNG",
				"answers_amount": 5,
				"solution": [3, 2, 4, 0, 1],
				"answers": {
					"0": {
						"text": "0 Direkt mergen, ohne ihn weiter zu prüfen.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"1": {
						"text": "1 Ablehnen, weil Tests deaktiviert wurden.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"2": {
						"text": "2 Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"3": {
						"text": "3 Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"4": {
						"text": "4 Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION
					}
				}
			},
			{
				"question": "Welche Reihenfolge ist korrekt? antwort ist 3,2,4,0,1",
				"question_type": minigame_type.ORDER,
				"job": "MARKETING",
				"answers_amount": 5,
				"solution": [3, 2, 4, 0, 1],
				"answers": {
					"0": {
						"text": "0 Überprüfen.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"1": {
						"text": "1 Posten.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"2": {
						"text": "2 Bilder erstellen.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"3": {
						"text": "3 Post Text schreiben.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"4": {
						"text": "4 Collab hinzufügen.	",
						"content_type": content_type.NORMAL_QUESTION
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.DRAG_AND_DROP,
				"job": "SOFTWAREENTWICKLUNG",
				"answers_amount": 5,
				"categories_amount": 3,
				"categories": {
					"1": "gut",
					"2": "naja",
					"3": "nein"
				},
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "1"
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "2"
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "3"
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "3"
					},
					"4": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "2"
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.DRAG_AND_DROP,
				"job": "MARKETING",
				"answers_amount": 5,
				"categories_amount": 3,
				"categories": {
					"1": "gut",
					"2": "naja",
					"3": "nein"
				},
				"answers": {
					"0": {
						"text": "Instagram",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "1"
					},
					"1": {
						"text": "Facebook",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "2"
					},
					"2": {
						"text": "Twitter",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "1"
					},
					"3": {
						"text": "LinkedIn",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "2"
					},
					"4": {
						"text": "Discord",
						"content_type": content_type.NORMAL_QUESTION,
						"answer": "3"
					}
				}
			},
			]
		}
	 
}

@onready var _event_feedback_frame = $EventFeedbackFrame
@onready var _event_feedback_frame_panel = $EventFeedbackFrame/EventFeedbackFramePanel
@onready var _texture_progress_bar = $TextureProgressBar
@onready var _lives_hbox_container = $LivesHBoxContainer

var lives = 3

var selected_job
var filtered_questions = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_question = 0

	_event_feedback_frame.visible = false
	_event_feedback_frame_panel.set_anchors_preset(Control.PRESET_FULL_RECT)

	_texture_progress_bar.value = 0

	for live in lives:
		var heart = TextureRect.new()
		heart.texture = preload("res://Assets/Objects/heart.png")
		_lives_hbox_container.add_child(heart)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# GLOBAL VARIABLES
signal failed
signal finished
var current_question: int
var current_minigame: Dictionary
var margin_default := 20
var _normal_button = UIFactory.UIElementTypes.NORMAL_BUTTON


# nodes
var _question_container
var _header: Control
var _content: Control
var _footer: Control
@onready var _minigame_container := $MinigameContent

var _next_button


var ordering_res = {
	"dragging": false,
	"offset": Vector2.ZERO,
	"positions_x": [],
	"y": 0,
	"nodes": [],
	"amount": 0,
	"order": []
}
var drag_and_drop_res = {
	"dragging": false,
	"offset": Vector2.ZERO,
	"start": Vector2.ZERO,
	"categories": [],
	"categories_amount": 0,
	"answers_completed": 0,
	"answers_amount": 0
}


# MINIGAME CREATION
# splitted into 3 levels: (minigame, question, content)
# minigame (whole minigame from start to finish)
func _draw_minigame(id: int) -> void:
	var game = get_parent()
	selected_job = game.selected_job
	# TODO: my idea is to make a minigame flow control here, smth like:
	# draw first question, if answer was correct, draw second, if not play explosion animation and try again
	# probably possible to do via await, or via two functions _answer_corre unknown ct and answer_wrong at the bottom of the script
	#_minigame_container.add_child(UIFactory.create_dragable_container())
	current_minigame = minigames.get(str(id))
	_texture_progress_bar.max_value = current_minigame.get("questions_amount")

	filtered_questions.clear()
	print("selected_job = ", selected_job)
	for question in current_minigame.get("questions"):
		if question.get("job") == selected_job:
			filtered_questions.append(question)
	if filtered_questions.size() != current_minigame.get("questions_amount"):
		push_error("Not enough questions for job %s in minigame %s" % [selected_job, id])

	if filtered_questions.size() > 0:
		_draw_question(filtered_questions[current_question])

# question (one question of a minigame)
func _draw_question(question: Dictionary) -> void:
	# Clear container for next minigame
	if _question_container != null:
		_question_container["root"].queue_free()


	_next_button = UIFactory.create_texture_button(_normal_button, Vector2(150, 30), "Next")
	_next_button["button"].button_down.connect(_on_next_button_pressed)
	# Question container and header
	_question_container = UIFactory.create_panel_container(Vector2(450, 600))
	var question_text = UIFactory.create_label(question.get("question"))
	_header = _question_container.get("header")
	_content = _question_container.get("content")
	_footer = _question_container.get("footer")
	
	# adding extra content in header if available
	if question.has("extra_content"):
		var vbox = VBoxContainer.new()
		_question_container.get("header").add_child(vbox)
		vbox.add_child(question_text.get("root"))
		var extra_content = _draw_content(question.get("extra_content"))
		vbox.add_child(extra_content.get("root"))
	else:
		_question_container.get("header").add_child(question_text.get("root"))


	# QUESTION TYPE SPECIFIC BLOCK
	# Question content, match through all possible question types
	match question.get("question_type"):
		minigame_type.SINGLECHOICE:
			# All vars go here
			var vBox = VBoxContainer.new()
			var answers_row_1 = HBoxContainer.new()
			var answers_row_2 # Used only if more then 3 questions
			var answers_amount = question.get("answers_amount")
			var button_root
			var button_button

			# Styling created elements
			vBox.add_theme_constant_override("separation", margin_default)
			answers_row_1.add_theme_constant_override("separation", margin_default)
			
			# Adding created elements into root
			vBox.add_child(answers_row_1)
			_content.add_child(vBox)

			# Adding buttons and connecting their inputs
			# If we have more than 3 answers, add second row
			if answers_amount > 3: # Two rows
				answers_row_2 = HBoxContainer.new()
				answers_row_2.add_theme_constant_override("separation", margin_default)
				vBox.add_child(answers_row_2)
				
			for i in answers_amount:
				var question_answer = question.get("answers").get(str(i))
				var tmp_button = UIFactory.create_texture_button(_normal_button, Vector2(200, 30), question_answer.get("text"))
				button_button = tmp_button["button"]
				button_root = tmp_button["root"]

				if answers_amount > 3 and (i > (answers_amount + 1) / 2 - 1): # Two rows
					answers_row_2.add_child(button_root)
				
				else: answers_row_1.add_child(button_root)
			
				# Connecting buttons
				if question_answer.get("correct"):
					button_button.button_down.connect(_answer_correct)
				else:
					button_button.button_down.connect(_answer_wrong)

		minigame_type.MULTICHOICE:
			# TODO: similar aproach as Single choice, but different button behaviour (like remain pressed?) or different button type
			# use footer to add confirm and cancel buttons smth like:
			# container.get("footer").add_child(hBox)
			# hBox.add_child(confirm)
			# when confirm is pressed check for selected buttons if they match our answer if yes, call _answer_correct
			pass
		minigame_type.DRAG_AND_DROP:
			for answer_key in question.get("answers"):
				var answer = question["answers"][answer_key]
				var tmp := UIFactory.create_colored_panel_container(Vector2(150, 50))
				var root = tmp["root"]
				root.set_meta("category_id", answer["answer"])
				_content.add_child(root)
				root.gui_input.connect(_handle_drag_and_drop.bind(root))
				drag_and_drop_res["answers_amount"] += 1

				# Adding content
				var content = _draw_content(answer)
				root.add_child(content["root"])
				root.z_index = 1
				root.modulate.a = 0.0
				root.mouse_filter = Control.MOUSE_FILTER_IGNORE
				
			_content.get_child(0).modulate.a = 1.0
			_content.get_child(0).mouse_filter = Control.MOUSE_FILTER_STOP

			var footer = HBoxContainer.new()
			footer.add_theme_constant_override("separation", margin_default)
			_footer.add_child(footer)

			# Categories for Drag and Drop
			drag_and_drop_res["categories_amount"] = question.get("categories_amount")
			drag_and_drop_res["categories"].resize(drag_and_drop_res["categories_amount"])
			var index = 0
			for categorie_key in question.get("categories"):
				var root := PanelContainer.new()
				root.custom_minimum_size = Vector2(150, 150)
				#print(categorie)
				root.set_meta("category_id", categorie_key)
				footer.add_child(root)

				drag_and_drop_res["categories"][index] = root
				index += 1

				# Adding content
				var content = UIFactory.create_label(question["categories"][categorie_key])
				root.add_child(content["root"])

		minigame_type.ORDER:
			var answers_amount = question.get("answers_amount")
			var rows = HBoxContainer.new()
			ordering_res["nodes"].resize(answers_amount)
			ordering_res["order"].resize(answers_amount)
			ordering_res["positions_x"].resize(answers_amount)
			ordering_res["amount"] = answers_amount

			for i in answers_amount:
				var tmp := UIFactory.create_colored_panel_container(Vector2(180, 50))
				var root = tmp["root"]
				root.gui_input.connect(_handle_ordering.bind(root))
				ordering_res.get("nodes")[i] = root
				ordering_res.get("order")[i] = i
				rows.add_child(root)

				# Adding content
				var answer = question["answers"][str(i)]
				var content = _draw_content(answer)
				root.add_child(content["root"])
			
			_content.add_child(rows)

			# TODO: make button labels available in JSON
			var confirm_button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(150, 30), "Confirm")
			var retry_button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(150, 30), "Retry")
			var hBox = HBoxContainer.new()
			hBox.add_child(retry_button["root"])
			retry_button["button"].button_down.connect(_on_ordering_retry_pressed)
			hBox.add_child(confirm_button["root"])
			confirm_button["button"].button_down.connect(_on_ordering_confirmed_pressed)
			hBox.alignment = BoxContainer.ALIGNMENT_CENTER
			hBox.add_theme_constant_override("separation", margin_default)
			_footer.add_child(hBox)
			
		minigame_type.CONNECT:
			pass
	
	
	_minigame_container.add_child(_question_container.get("root"))
	
# content (creates content to use inside of question blocks)
func _draw_content(content: Dictionary) -> Dictionary:
	match content.get("content_type"):
		content_type.NORMAL_QUESTION:
			return UIFactory.create_label(content.get("text"))
		content_type.CODE_SNIPPET:
			# TODO: add creation of different content types 
			return {}
		_:
			return {}


# INPUTS HANDLING
func _handle_drag_and_drop(event: InputEvent, root: Control) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Started dragging
		if event.pressed:
			drag_and_drop_res["start"] = root.global_position
			drag_and_drop_res["dragging"] = true
			drag_and_drop_res["offset"] = root.get_global_mouse_position() - root.global_position
		# Stopped dragging
		else:
			print("sssdsds")
			drag_and_drop_res["dragging"] = false

			# checking for intersection with any categorie
			var best_category: Control = null
			var best_overlap_ratio := 0.0
			var min_overlap_ratio := 0.25
			var answer_rect: Rect2 = root.get_global_rect()
			var answer_area := answer_rect.size.x * answer_rect.size.y
			for category in drag_and_drop_res["categories"]:
				var category_rect: Rect2 = category.get_global_rect()

				if answer_rect.intersects(category_rect):
					var intersection: Rect2 = answer_rect.intersection(category_rect)
					var overlap_area := intersection.size.x * intersection.size.y
					var overlap_ratio := overlap_area / answer_area

					if overlap_ratio > best_overlap_ratio and overlap_ratio >= min_overlap_ratio:
						best_overlap_ratio = overlap_ratio
						best_category = category

			
			if best_category == null:
				var tween := root.create_tween()
				tween.tween_property(root, "global_position", drag_and_drop_res["start"], 0.1)
			elif best_category.get_meta("category_id") != root.get_meta("category_id"):
				var tween := root.create_tween()
				tween.tween_property(root, "global_position", drag_and_drop_res["start"], 0.1)
				_shake_node(best_category)
				_answer_wrong()
			else:
				drag_and_drop_res["answers_completed"] += 1
				if drag_and_drop_res["answers_completed"] == drag_and_drop_res["answers_amount"]:
					_answer_correct()
		
				var target = best_category.global_position + best_category.size / 2.0
				var tween := root.create_tween()
				tween.tween_property(root, "global_position", target, 0.2)
				tween.parallel().tween_property(root, "scale", Vector2.ZERO, 0.2)
				
					
				# # Deleting parent, showing new question
				var parent = root.get_parent()
				var new_child: Node = parent.get_child(1)
				if new_child != null:
					new_child.scale = Vector2.ZERO
					new_child.modulate.a = 1.0
					new_child.mouse_filter = Control.MOUSE_FILTER_STOP
					tween.parallel().tween_property(new_child, "scale", Vector2.ONE, 0.2)
					#tween.parallel().tween_property(root, "global_position", target, 0.2)
				
				await tween.finished
				parent.remove_child(root)
				root.queue_free()


	elif event is InputEventMouseMotion and drag_and_drop_res["dragging"]:
		_drag_node_with_mouse(root, drag_and_drop_res["offset"])
		
func _handle_ordering(event: InputEvent, root: Control) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# if started dragging
		if event.pressed:
			#print(ordering_res.get("nodes"))
			for i in ordering_res.get("amount"):
				var id = ordering_res.get("order")[i]
				ordering_res["positions_x"][i] = ordering_res.get("nodes")[id].global_position.x
			ordering_res["y"] = root.global_position.y
			ordering_res["dragging"] = true
			ordering_res["offset"] = root.get_global_mouse_position() - root.global_position
		# if stopped dragging
		else:
			ordering_res["dragging"] = false
			var tween := root.create_tween()

			# determine closest position to snap our node to 
			var min_dist = 10000
			var target_node_id
			var current_node_id
			
			for i in ordering_res.get("amount"):
				var id = ordering_res.get("order")[i]
				var dif = abs(root.global_position.x - ordering_res.get("positions_x")[i])
				if dif < min_dist:
					target_node_id = i
					min_dist = dif
				if ordering_res["nodes"][id] == root:
					current_node_id = i
			
			# reorder all current containers
			var tmp = ordering_res["order"][current_node_id]
			if target_node_id < current_node_id:
				for i in range(current_node_id - 1, target_node_id - 1, -1):
					ordering_res["order"][i + 1] = ordering_res["order"][i]

			elif target_node_id > current_node_id:
				for i in range(current_node_id + 1, target_node_id + 1):
					ordering_res["order"][i - 1] = ordering_res["order"][i]

			ordering_res["order"][target_node_id] = tmp
			
			# move elements in new order
			for i in ordering_res.get("amount"):
				var id = ordering_res.get("order")[i]
				var targ = ordering_res.get("positions_x")[i]
				tween.parallel().tween_property(ordering_res["nodes"][id], "global_position", Vector2(targ, ordering_res["y"]), 0.1)
				

	elif event is InputEventMouseMotion and ordering_res["dragging"]:
		_drag_node_with_mouse(root, ordering_res["offset"])

func _on_next_button_pressed() -> void:
	current_question += 1
	if current_question == current_minigame.get("questions_amount"):
		_texture_progress_bar.value = 0
		emit_signal("finished")
	else:
		if current_question >= filtered_questions.size():
			push_error("Not enough questions for job %s in minigame %s" % [selected_job, current_minigame.get("name")])
			emit_signal("finished")
			return
		_draw_question(filtered_questions[current_question])

func _on_ordering_confirmed_pressed() -> void:
	if arrays_equal(ordering_res["order"], filtered_questions[current_question]["solution"]):
		_answer_correct()
	else:
		_answer_wrong()
		_on_ordering_retry_pressed()

func _on_ordering_retry_pressed() -> void:
	# TODO: reset order of elements 
	pass

# function for handling failed minigame
func _failed() -> void:
	emit_signal("failed")

# Handling of correct answer
func _answer_correct() -> void:
	_event_feedback_frame.visible = true

	var style = _event_feedback_frame_panel.get_theme_stylebox("panel") as StyleBoxFlat
	style.border_color = Color.GREEN

	_texture_progress_bar.value += 1

	await get_tree().create_timer(0.5).timeout
	_event_feedback_frame.visible = false

	for child in _content.get_children():
		child.queue_free()
	
	_on_next_button_pressed()

# Handling of wrong answer
func _answer_wrong() -> void:
	_event_feedback_frame.visible = true

	var style = _event_feedback_frame_panel.get_theme_stylebox("panel") as StyleBoxFlat
	style.border_color = Color.RED

	await get_tree().create_timer(0.5).timeout
	_event_feedback_frame.visible = false

	lives -= 1

	_lives_hbox_container.get_child(lives).texture = preload("res://Assets/Objects/broken_heart.png")
	_shake_node(_lives_hbox_container.get_child(lives))

	await get_tree().create_timer(0.5).timeout

	if lives < 1:
		_failed()
		return
	

# HELP FUNCTIONS GO HERE
# Help function that shakes received Node
func _shake_node(root: Control) -> void:
	var start_pos := root.global_position
	var shake_power := 8.0
	var step_time := 0.04

	var tween := root.create_tween()

	tween.tween_property(root, "global_position", start_pos + Vector2(shake_power, 0), step_time)
	tween.tween_property(root, "global_position", start_pos + Vector2(-shake_power, 0), step_time)
	tween.tween_property(root, "global_position", start_pos + Vector2(shake_power * 0.6, 0), step_time)
	tween.tween_property(root, "global_position", start_pos + Vector2(-shake_power * 0.6, 0), step_time)
	tween.tween_property(root, "global_position", start_pos, step_time)

# Help function for Order Minigame
func arrays_equal(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false

	for i in range(a.size()):
		if a[i] != b[i]:
			return false

	return true

# Help function for dragging objects with mouth
func _drag_node_with_mouse(root: Control, offset: Vector2) -> void:
	var new_pos: Vector2 = root.get_global_mouse_position() - offset

	var viewport_size: Vector2 = root.get_viewport_rect().size
	var root_size: Vector2 = root.size

	new_pos.x = clamp(new_pos.x, 0.0, viewport_size.x - root_size.x)
	new_pos.y = clamp(new_pos.y, 0.0, viewport_size.y - root_size.y)

	root.global_position = new_pos
