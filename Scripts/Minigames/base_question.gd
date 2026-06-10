@abstract
extends Control 
class_name BaseQuestion

enum ContentType {
    CODE_SNIPPET,
    NORMAL_QUESTION,
    IMAGE
}

class Answer:
    var _text: String
    var _type: ContentType = ContentType.NORMAL_QUESTION

    func _init(text: String, type: ContentType):
        _text = text
        _type = type

signal signal_correct
signal signal_wrong

var _margin_default  := 20
var _normal_button = UIFactory.UIElementTypes.NORMAL_BUTTON

var _question: String
var _job: String
var _extra_content_text: String
var _extra_content_type: ContentType
var _answers_amount: int
var _solution: Array
var _answers: Array[Answer]

var _question_container
var _header: Control
var _content: Control
var _footer: Control

func _init(
    question: String,
    job: String,
    answers_amount: int,
    solution: Array,
    answers: Array[Answer],
    extra_content_text: String,
    extra_content_type: ContentType
) -> void:
    _question = question
    _job = job
    _answers_amount = answers_amount
    _solution = solution
    _answers = answers

    # don't forget to check if this are empty
    _extra_content_text = extra_content_text
    _extra_content_type = extra_content_type 

func draw(minigame_base: Control) -> void:
    # Clear container for next minigame
    if _question_container != null:
        _question_container["root"].queue_free()


    # _next_button = UIFactory.create_texture_button(_normal_button, Vector2(150, 30), "Next")
    # _next_button["button"].button_down.connect(_on_next_button_pressed)
    # Question container and header
    _question_container = UIFactory.create_panel_container(Vector2(450, 600))
    var question_text = UIFactory.create_label(_question)
    _header = _question_container.get("header")
    _content = _question_container.get("content")
    _footer = _question_container.get("footer")

    # adding extra content in header if available
    if _extra_content_text != "":
        var vbox = VBoxContainer.new()
        _question_container.get("header").add_child(vbox)
        vbox.add_child(question_text.get("root"))
        var extra_content = _draw_content(Answer.new(_extra_content_text, _extra_content_type))
        vbox.add_child(extra_content.get("root"))
    else:
        _question_container.get("header").add_child(question_text.get("root"))

    # calling draw function 
    draw_question()
    minigame_base.add_child(_question_container.get("root"))
    
func _draw_content(content: Answer) -> Dictionary:
    match content._type:
        ContentType.NORMAL_QUESTION:
            return UIFactory.create_label(content._text)
        ContentType.CODE_SNIPPET:
            return UIFactory.create_code_snippet(content._text)
        _:
            return {}

# emits a signal if answer was correct
func _answer_correct() -> void:
    emit_signal("signal_correct")
   
# emits a signal if answer was wrong
func _answer_wrong() -> void:
    emit_signal("signal_wrong")

@abstract func draw_question()
# used to draw question related UI inside of UIFactory panelcontainer

@abstract func handle_answer(event: InputEvent = null, root: Control = null)
# needs to be connected to input (button or signal) normaly inside of a draw_question


# Help function that shakes received Node
static func _shake_node(root: Control) -> void:
    var start_pos := root.global_position
    var shake_power := 8.0
    var step_time := 0.04

    var tween := root.create_tween()

    tween.tween_property(root, "global_position", start_pos + Vector2(shake_power, 0), step_time)
    tween.tween_property(root, "global_position", start_pos + Vector2(-shake_power, 0), step_time)
    tween.tween_property(root, "global_position", start_pos + Vector2(shake_power * 0.6, 0), step_time)
    tween.tween_property(root, "global_position", start_pos + Vector2(-shake_power * 0.6, 0), step_time)
    tween.tween_property(root, "global_position", start_pos, step_time)


# function that allows to drag any Control Node with mouse, offset is optional
func _drag_node_with_mouse(root: Control, offset: Vector2 = Vector2.ZERO) -> void:
    root.z_index = 2
    var new_pos: Vector2 = root.get_global_mouse_position() - offset

    var viewport_size: Vector2 = root.get_viewport_rect().size
    var root_size: Vector2 = root.size

    new_pos.x = clamp(new_pos.x, 0.0, viewport_size.x - root_size.x)
    new_pos.y = clamp(new_pos.y, 0.0, viewport_size.y - root_size.y)

    root.global_position = new_pos

