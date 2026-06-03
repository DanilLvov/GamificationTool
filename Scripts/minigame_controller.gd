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
var minigames :={
	  "0": {
		"name": "Minigame1",
		"questions_amount": 4,
		# TODO: add win/loose message
		"questions": 
			[{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.SINGLECHOICE,
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
				"question": "Was sollte mit diesem Commit passieren?",
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
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.ORDER,
				"answers_amount": 5,
				"solution": [3, 2, 4, 0, 1],
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"content_type": content_type.NORMAL_QUESTION
					},
					"4": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"content_type": content_type.NORMAL_QUESTION
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.DRAG_AND_DROP,
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
			}]
		}
	 
}



signal failed
signal finished
var current_question: int
var current_minigame: Dictionary
var content_body
var margin_default := 20
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

@onready var minigame_container := $MinigameContent
@onready var next_button := $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_question = 3
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw_minigame(id: int) -> void:
	# TODO: my idea is to make a minigame flow control here, smth like:
	# draw first question, if answer was correct, draw second, if not play explosion animation and try again
	# probably possible to do via await, or via two functions _answer_correct and answer_wrong at the bottom of the script

	#minigame_container.add_child(UIFactory.create_dragable_container())
	current_minigame = minigames.get(str(id))
	_draw_question(current_minigame.get("questions")[current_question])
	

func _draw_question(question: Dictionary) -> void:
	# Clear container for next minigame
	if content_body != null:
		minigame_container.remove_child(content_body.get("root"))

	# Question container and header
	content_body = UIFactory.create_panel_container (Vector2(450, 600))
	var question_text = UIFactory.create_label(question.get("question"))
	
	# adding extra content in header if available
	if question.has("extra_content"):
		var vbox = VBoxContainer.new()
		content_body.get("header").add_child(vbox)
		vbox.add_child(question_text.get("root"))
		var extra_content = _draw_content(question.get("extra_content"))
		vbox.add_child(extra_content.get("root"))
	else:
		content_body.get("header").add_child(question_text.get("root"))

	# Question content, switch through all question types
	# TODO: add support to different question content types (like code snippets)
	match question.get("question_type"):
		minigame_type.SINGLECHOICE:
			var content = VBoxContainer.new()

			content.add_theme_constant_override("separation", margin_default)
			content_body.get("content").add_child(content)
			
			var answers_amount = question.get("answers_amount")
			var answers_row_1 = HBoxContainer.new()
			answers_row_1.add_theme_constant_override("separation", margin_default)
			content.add_child(answers_row_1)

			var button

			# Adding buttons and connecting their inputs
			# If we have more than 3 answers, add second row
			if answers_amount > 3:
				var answers_row_2 = HBoxContainer.new()
				answers_row_2.add_theme_constant_override("separation", margin_default)
				content.add_child(answers_row_2)
				
				for i in answers_amount:
					button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(200,30), question.get("answers").get(str(i)).get("text"))
					if (i > (answers_amount + 1) / 2 - 1):
						answers_row_2.add_child(button.get("root"))
					else:
						answers_row_1.add_child(button.get("root"))

					if question.get("answers").get(str(i)).get("correct"):
						button.get("button").button_down.connect(_answer_correct)
					else:
						button.get("button").button_down.connect(_answer_wrong)
			else:
				for i in answers_amount:
					button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(200,30), question.get("answers").get(str(i)).get("text"))
					answers_row_1.add_child(button.get("root"))
					if question.get("answers").get(str(i)).get("correct"):
						button.get("button").button_down.connect(_answer_correct)
					else:
						button.get("button").button_down.connect(_answer_wrong)
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
				var root := PanelContainer.new()
				root.custom_minimum_size = Vector2 (150, 50)
				root.set_meta("category_id", answer["answer"])
				content_body.get("content").add_child(root)
				root.gui_input.connect(_handle_drag_and_drop.bind(root))
				drag_and_drop_res["answers_amount"] += 1
				

			var footer = HBoxContainer.new()
			footer.add_theme_constant_override("separation", margin_default)
			content_body.get("footer").add_child(footer)

			# Categories for Drag and Drop
			drag_and_drop_res["categories_amount"] = question.get("categories_amount")
			drag_and_drop_res["categories"].resize(drag_and_drop_res["categories_amount"])
			var index = 0
			for categorie in question.get("categories"):
				var root := PanelContainer.new()
				root.custom_minimum_size = Vector2 (150, 150)
				#print(categorie)
				root.set_meta("category_id", categorie)
				footer.add_child(root)

				drag_and_drop_res["categories"][index] = root
				index += 1
		minigame_type.ORDER:
			var answers_amount = question.get("answers_amount")
			var rows = HBoxContainer.new()
			ordering_res["nodes"].resize(answers_amount)
			ordering_res["order"].resize(answers_amount)
			ordering_res["positions_x"].resize(answers_amount)
			ordering_res["amount"] = answers_amount

			for i in answers_amount:
				var root := PanelContainer.new()
				root.custom_minimum_size = Vector2 (50, 50)
				root.gui_input.connect(_handle_ordering.bind(root))
				ordering_res.get("nodes")[i] = root
				ordering_res.get("order")[i] = i
				rows.add_child(root)
			
			content_body.get("content").add_child(rows)
		minigame_type.CONNECT:
			pass
	
	
	minigame_container.add_child(content_body.get("root"))
	

# creates content to use inside of any other container	
func _draw_content(content: Dictionary) -> Dictionary:
	match content.get("content_type"):
		content_type.NORMAL_QUESTION:
			return UIFactory.create_label(content.get("text"))
		content_type.CODE_SNIPPET:
			pass
	return {}


# inputs handling

func _handle_drag_and_drop(event: InputEvent, root: Control) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Started dragging
		if event.pressed:
			drag_and_drop_res["start"] = root.global_position
			drag_and_drop_res["dragging"] = true
			drag_and_drop_res["offset"] = root.get_global_mouse_position() - root.global_position
		# Stopped dragging
		else:
			
			var tween := root.create_tween()
			drag_and_drop_res["dragging"] = false

			# checking for intersection with any categorie
			var best_category: Control = null
			var best_overlap_ratio := 0.0
			var min_overlap_ratio := 0.25
			var answer_rect : Rect2 = root.get_global_rect()
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
				tween.tween_property(root, "global_position", drag_and_drop_res["start"], 0.1)
			elif best_category.get_meta("category_id") != root.get_meta("category_id"):
				tween.tween_property(root, "global_position", drag_and_drop_res["start"], 0.1)
				_shake_node(best_category)
			else:
				drag_and_drop_res["answers_completed"] += 1
				if drag_and_drop_res["answers_completed"] == drag_and_drop_res["answers_amount"]:
					_answer_correct()
				var target = best_category.global_position + best_category.size / 2.0  
				tween.tween_property(root, "global_position", target, 0.2)
				tween.parallel().tween_property(root, "scale", Vector2.ZERO, 0.2)


		
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

func _drag_node_with_mouse(root: Control, offset: Vector2) -> void:
	var new_pos: Vector2 = root.get_global_mouse_position() - offset

	var viewport_size: Vector2 = root.get_viewport_rect().size
	var root_size: Vector2 = root.size

	new_pos.x = clamp(new_pos.x, 0.0, viewport_size.x - root_size.x)
	new_pos.y = clamp(new_pos.y, 0.0, viewport_size.y - root_size.y)

	root.global_position = new_pos

func _on_next_button_pressed() -> void:
	next_button.visible = false
	current_question += 1
	if current_question == current_minigame.get("questions_amount"):
		print("game ended")
		emit_signal("finished")
	else: 
		_draw_question(current_minigame.get("questions")[current_question])
	

func _failed() -> void:
	#_on_reset_button_pressed()
	emit_signal("failed")

func _load_minigame() -> void:
	pass

# Handling of correct answer
func _answer_correct() -> void:
	# TODO: add full handling
	# Show button: NEXT
	next_button.visible = true
	print("Correct!")

# Handling of correct answer
func _answer_wrong() -> void:
	# TODO: add full handling
	# show retry button
	print("WROOOONG!")
