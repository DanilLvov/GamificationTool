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
		"minigame_type": minigame_type.SINGLECHOICE,
		"minigame_content": minigame_content.NORMAL_QUESTION,
		"questions_amount": 3,
		"questions": 
			[{
				"text": "sosal?",
				"answers_amount": 4,
				"answers": {
					"0": {
						"text": "da",
						"correct": false
					},
					"1": {
						"text": "net",
						"correct": false
					},
					"2": {
						"text": "sosal.",
						"correct": true
					},
					"3": {
						"text": "ne znaiu",
						"correct": false
					}
				}
			},
			{
				"text": "sosal?",
				"answers_amount": 4,
				"answers": {
					"0": {
						"text": "da",
						"correct": false
					},
					"1": {
						"text": "net",
						"correct": false
					},
					"2": {
						"text": "sosal.",
						"correct": true
					},
					"3": {
						"text": "ne znaiu",
						"correct": false
					}
				}
			},
			{
				"text": "sosal?",
				"answers_amount": 4,
				"answers": {
					"0": {
						"text": "da",
						"correct": false
					},
					"1": {
						"text": "net",
						"correct": false
					},
					"2": {
						"text": "sosal.",
						"correct": true
					},
					"3": {
						"text": "ne znaiu",
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
	var minigame = minigames.get(str(id))

	# match minigame.get("minigame_type"):
	# 	minigame_type.SINGLECHOICE:

			
	
	var content = UIFactory.create_panel_container (Vector2(450, 600))
	var hbox = HBoxContainer.new()
	var button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(100,30), "Antwort A: Lorem ipsum")
	var button1 = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(100,30), "Antwort B: Lorem ipsum")
	var button2 = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(100,30), "Antwort C: Lorem ipsum")
	var question = UIFactory.create_label("First question: What do you eat eassa dddj saaf")
	var footer = UIFactory.create_label("easter eggs")
	content_container.add_child(content.get("root"))
	content.get("header").add_child(question)
	content.get("footer").add_child(footer)
	content.get("content").add_child(hbox)

	hbox.add_child(button1)
	hbox.add_child(button)
	hbox.add_child(button2)
	content.get("content").add_child(button2)
	
	

func _draw_content (question: Dictionary) -> void:
	pass



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
