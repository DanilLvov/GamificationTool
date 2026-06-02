extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var selected_carousel_node = $CarouselContainer.position_offset_node.get_child($CarouselContainer.selected_index)
	print(selected_carousel_node.name)
	print("test")


func _on_left_pressed() -> void:
	$CarouselContainer._left()
	print("???")


func _on_right_pressed() -> void:
	$CarouselContainer._right()
	print("??")