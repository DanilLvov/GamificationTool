extends Node2D

signal finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Signaling that Cutscene is finished
func _launch_scene(scene_id: String) -> void:
	print("launched cutscene " + scene_id)
	await get_tree().create_timer(1.0).timeout
	emit_signal("finished")
