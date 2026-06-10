extends BaseQuestion
class_name DragAndDropQuestion

var dragging = false
var start = Vector2.ZERO
var offset = Vector2.ZERO
var answers_completed = 0
var _categorie_nodes = []

# extra contents from extra_object
var _categories_amount: int
var _categorie_names: Array

func draw_question() -> void:

    var id = 0
    for answer in _answers:
        var tmp := UIFactory.create_colored_panel_container(Vector2(150, 50))
        var root = tmp["root"]
        root.set_meta("category_id", _solution[id])
        _content.add_child(root)
        root.gui_input.connect(handle_answer.bind(root))
        _answers_amount += 1

        # Adding content
        var content = _draw_content(answer)
        root.add_child(content["root"])
        root.z_index = 1
        root.modulate.a = 0.0
        root.mouse_filter = Control.MOUSE_FILTER_IGNORE
         
        id += 1
				
    _content.get_child(0).modulate.a = 1.0
    _content.get_child(0).mouse_filter = Control.MOUSE_FILTER_STOP

    var footer = HBoxContainer.new()
    footer.add_theme_constant_override("separation", _margin_default)
    _footer.add_child(footer)

       

    # Categories for Drag and Drop
    #categories_amount = question.get("categories_amount")
    _categorie_nodes.resize(_categories_amount)
    var index = 0
    for categorie in _categorie_names:
        var tmp := UIFactory.create_colored_panel_container(Vector2(150, 150))
        var root = tmp["root"]
        root.set_meta("category_id", index)
        footer.add_child(root)

        _categorie_nodes[index] = root
        index += 1

        # Adding content
        var content = UIFactory.create_label(categorie)
        root.add_child(content["root"])


func handle_answer(event: InputEvent = null, root: Control = null) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        # Started dragging
        if event.pressed:
            start = root.global_position
            dragging = true
            offset = root.get_global_mouse_position() - root.global_position
        # Stopped dragging
        else:
            dragging = false

            # checking for intersection with any categorie
            var best_category: Control = null
            var best_overlap_ratio := 0.0
            var min_overlap_ratio := 0.25
            var answer_rect: Rect2 = root.get_global_rect()
            var answer_area := answer_rect.size.x * answer_rect.size.y
            for node in _categorie_nodes:
                var category_rect: Rect2 = node.get_global_rect()

                if answer_rect.intersects(category_rect):
                    var intersection: Rect2 = answer_rect.intersection(category_rect)
                    var overlap_area := intersection.size.x * intersection.size.y
                    var overlap_ratio := overlap_area / answer_area

                    if overlap_ratio > best_overlap_ratio and overlap_ratio >= min_overlap_ratio:
                        best_overlap_ratio = overlap_ratio
                        best_category = node

            
            if best_category == null:
                var tween := root.create_tween()
                tween.tween_property(root, "global_position", start, 0.1)
            elif best_category.get_meta("category_id") != root.get_meta("category_id"):
                var tween := root.create_tween()
                tween.tween_property(root, "global_position", start, 0.1)
                _shake_node(best_category)
                _answer_wrong()
            else:
                answers_completed += 1
                if answers_completed == _answers_amount:
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
                answers_completed += 1
                if answers_completed == _answers_amount:
                    _answer_correct()
                parent.remove_child(root)
                root.queue_free()


    elif event is InputEventMouseMotion and dragging:
        _drag_node_with_mouse(root, offset)

func handle_extra_objects() -> void:
    _categories_amount = _extra_objects["categories_amount"]
    _categorie_names = _extra_objects["categories"]
    
