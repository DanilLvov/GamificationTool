extends BaseQuestion
class_name OrderQuestion

# var ordering_res = {
# 	"dragging": false,
# 	"offset": Vector2.ZERO,
# 	"positions_x": [],
# 	"y": 0,
# 	"nodes": [],
# 	"amount": 0,
# 	"order": []
# }

var dragging = false
var offset = Vector2.ZERO
var positions_x = []
var y = 0
var nodes = []
var order = []

func draw_question() -> void:
    var rows = HBoxContainer.new()
    nodes.resize(_answers_amount)
    order.resize(_answers_amount)
    positions_x.resize(_answers_amount)

    var i = 0
    for answer in _answers:
        var tmp := UIFactory.create_colored_panel_container(Vector2(180, 50))
        var root = tmp["root"]
        root.gui_input.connect(handle_answer.bind(root))
        nodes[i] = root
        order[i] = i
        rows.add_child(root)

        # Adding content
        var content = _draw_content(answer)
        root.add_child(content["root"])
        i += 1
			
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
    hBox.add_theme_constant_override("separation", _margin_default)
    _footer.add_child(hBox)
			

func handle_answer(event: InputEvent = null, root: Control = null) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        # if started dragging
        if event.pressed:
            #print(nodes)
            for i in _answers_amount:
                var id = order[i]
                positions_x[i] = nodes[id].global_position.x
            y = root.global_position.y
            dragging = true
            offset = root.get_global_mouse_position() - root.global_position
        # if stopped dragging
        else:
            root.z_index = 1
            dragging = false
            var tween := root.create_tween()

            # determine closest position to snap our node to 
            var min_dist = 10000
            var target_node_id
            var current_node_id
            
            for i in _answers_amount:
                var id = order[i]
                var dif = abs(root.global_position.x - positions_x[i])
                if dif < min_dist:
                    target_node_id = i
                    min_dist = dif
                if nodes[id] == root:
                    current_node_id = i
            
            # reorder all current containers
            var tmp = order[current_node_id]
            if target_node_id < current_node_id:
                for i in range(current_node_id - 1, target_node_id - 1, -1):
                    order[i + 1] = order[i]

            elif target_node_id > current_node_id:
                for i in range(current_node_id + 1, target_node_id + 1):
                    order[i - 1] = order[i]

            order[target_node_id] = tmp
            
            # move elements in new order
            for i in _answers_amount:
                var id = order[i]
                var targ = positions_x[i]
                tween.parallel().tween_property(nodes[id], "global_position", Vector2(targ, y), 0.1)
                    

    elif event is InputEventMouseMotion and dragging:
        _drag_node_with_mouse(root, offset)
# needs to be connected to input (button or signal) normaly inside of a draw_question

func _on_ordering_confirmed_pressed() -> void:
    if arrays_equal(order, _solution):
        _answer_correct()
    else:
        _answer_wrong()
        _on_ordering_retry_pressed()

func _on_ordering_retry_pressed() -> void:
    # TODO: reset order of elements 
    pass

# Help function for Order Minigame
func arrays_equal(a: Array, b: Array) -> bool:
    if a.size() != b.size():
        return false

    for i in range(a.size()):
        if a[i] != b[i]:
            return false

    return true