extends Control

enum minigame_type {
	SINGLECHOICE,
	MULTICHOICE,
	DRAG_AND_DROP,
	ORDER
}

enum minigame_content {
	CODE_SNIPPET,
	NORMAL_QUESTION
}
var minigames :={
	  "0": {
		"name": "Minigame1",
		"questions_amount": 3,
		"questions": 
			[{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.SINGLECHOICE,
				"minigame_content": minigame_content.NORMAL_QUESTION,
				"answers_amount": 4,
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"correct": false
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"correct": true
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"correct": false
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"correct": false
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.SINGLECHOICE,
				"minigame_content": minigame_content.NORMAL_QUESTION,
				"answers_amount": 6,
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"correct": false
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"correct": true
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"correct": false
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"correct": false
					},
					"4": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"correct": false
					},
					"5": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"correct": false
					}
				}
			},
			{
				"question": "Was sollte mit diesem Commit passieren?",
				"question_type": minigame_type.SINGLECHOICE,
				"minigame_content": minigame_content.NORMAL_QUESTION,
				"answers_amount": 5,
				"answers": {
					"0": {
						"text": "Direkt mergen, ohne ihn weiter zu prüfen.",
						"correct": false
					},
					"1": {
						"text": "Ablehnen, weil Tests deaktiviert wurden.",
						"correct": true
					},
					"2": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"correct": false
					},
					"3": {
						"text": "Ignorieren, weil es nur ein kleiner Hotfix ist.",
						"correct": false
					},
					"4": {
						"text": "Nur die Commit-Nachricht ändern und dann mergen.",
						"correct": false
					}
				}
			}]
		}
	 
}



signal failed
signal finished

@onready var content_container := $MinigameContent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw_minigame(id: int) -> void:
	_draw_content(minigames.get("0").get("questions")[2])
	
	

func _draw_content (question: Dictionary) -> void:
	# Question container
	var container = UIFactory.create_panel_container (Vector2(450, 600))
	var question_text = UIFactory.create_label(question.get("question"))
	container.get("header").add_child(question_text)

	# Question content
	match question.get("question_type"):
		minigame_type.SINGLECHOICE:
			var content = VBoxContainer.new()
			container.get("content").add_child(content)
			
			var answers_amount = question.get("answers_amount")
			var answers_row_1 = HBoxContainer.new()
			content.add_child(answers_row_1)

			var button

			# Adding buttons and connecting their inputs
			# If we have more than 3 answers, add second row
			if answers_amount > 3:
				var answers_row_2 = HBoxContainer.new()
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
			
	
	
	content_container.add_child(container.get("root"))
	
	#container.get("footer").add_child(footer)



func _on_next_game_button_pressed() -> void:
	#_on_reset_button_pressed()
	emit_signal("finished")

func _failed() -> void:
	#_on_reset_button_pressed()
	emit_signal("failed")

func _load_minigame() -> void:
	pass
func _load_singlechoice() -> void:
	pass

# Handling of correct answer
func _answer_correct() -> void:
	# TODO: add full handling
	print("Correct!")

# Handling of correct answer
func _answer_wrong() -> void:
	# TODO: add full handling
	print("WROOOONG!")
