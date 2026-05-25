extends Node2D

signal finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#timer funcs
var time_left = 0.0
var timer_running = false

func _start_timer(time: float) -> void:
	timer_running = true
	time_left = time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (timer_running): 
		time_left -= delta
		if (time_left <= 0.0):
			emit_signal("finished")
			timer_running = false
	pass

# Signaling that Cutscene is finished
func _launch_scene(scene_id: String) -> void:
	print("launched cutscene " + scene_id)
	_start_timer(2.0)
