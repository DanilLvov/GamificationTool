extends BaseQuestion
class_name MultichoiceQuestion

var buttons = []

func draw_question() -> void:
    var vBox = VBoxContainer.new()
    var answers_row_1 = HBoxContainer.new()
    var answers_row_2 # Used only if more then 3 questions
    var button_root
    var button_button
    

    # Styling created elements
    vBox.add_theme_constant_override("separation", _margin_default)
    answers_row_1.add_theme_constant_override("separation", _margin_default)
    
    # Adding created elements into root
    vBox.add_child(answers_row_1)
    _content.add_child(vBox)

    # Adding buttons and connecting their inputs
    # If we have more than 3 answers, add second row
    if _answers_amount > 3: # Two rows
        answers_row_2 = HBoxContainer.new()
        answers_row_2.add_theme_constant_override("separation", _margin_default)
        vBox.add_child(answers_row_2)
    
    var i = 0
    for answer in _answers:
        var tmp_button = UIFactory.create_texture_button(_normal_button, Vector2(200, 30), answer._text)
        button_button = tmp_button["button"]
        button_root = tmp_button["root"]
        button_button.toggle_mode = true
        buttons.append(button_button)


        if _answers_amount > 3 and (i > (_answers_amount + 1) / 2 - 1): # Two rows
            answers_row_2.add_child(button_root)
        
        else: answers_row_1.add_child(button_root)
        i += 1
    
        # TODO: make button labels available in JSON
    var confirm_button = UIFactory.create_texture_button(UIFactory.UIElementTypes.NORMAL_BUTTON, Vector2(150, 30), "Confirm")
    var hBox = HBoxContainer.new()
    hBox.add_child(confirm_button["root"])
    confirm_button["button"].button_down.connect(handle_answer)
    hBox.alignment = BoxContainer.ALIGNMENT_CENTER
    hBox.add_theme_constant_override("separation", _margin_default)
    _footer.add_child(hBox)

func handle_answer(event: InputEvent = null, root: Control = null):
    for i in _answers_amount:
        var is_pressed: bool = buttons[i].button_pressed

        if bool(_solution[i]) != is_pressed:
            _answer_wrong()
            for btn in buttons:
                btn.button_pressed = false

            return

    _answer_correct()