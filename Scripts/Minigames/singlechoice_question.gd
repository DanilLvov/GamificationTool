extends BaseQuestion
class_name SinglechoiceQuestion

func draw_question():
    var vBox = VBoxContainer.new()
    var answers_row_1 = HBoxContainer.new()
    var answers_row_2 # Used only if more then 3 questions
    var answers_amount = _answers_amount
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
    if answers_amount > 3: # Two rows
        answers_row_2 = HBoxContainer.new()
        answers_row_2.add_theme_constant_override("separation", _margin_default)
        vBox.add_child(answers_row_2)
    var i = 0
    for answer in _answers:
        var tmp_button = UIFactory.create_texture_button(_answer_button, Vector2(200, 30), answer._text)
        button_button = tmp_button["button"]
        button_root = tmp_button["root"]

        @warning_ignore("integer_division")
        if _answers_amount > 3 and (i > (answers_amount + 1) / 2 - 1): # Two rows
            answers_row_2.add_child(button_root)

        else: answers_row_1.add_child(button_root)

        # Connecting buttons
        if _solution[i]:
            button_button.button_down.connect(_answer_correct)
        else:
            button_button.button_down.connect(_answer_wrong)

        i += 1

func handle_answer(_event: InputEvent = null, _root: Control = null):
    pass