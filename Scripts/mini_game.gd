extends Node2D

signal finished
signal failed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#TODO: change to cuurrent project task
var richtigeAntwort = 1
var lifes = 3

func _on_button_a_pressed() -> void:
	$ButtonA.visible = false
	$ButtonB.visible = false
	var text
	if (richtigeAntwort == 0):
		text = "You are right!!!"
		$NextGameButton.visible = true
	else:
		text = "You are Wrong!!!"
		lifes -= 1
		if lifes <= 0:
			_failed()
		
		$ResetButton.visible = true
	$MiniGameRes.text = text
	$MiniGameRes.visible = true
	

func _on_button_b_pressed() -> void:
	$ButtonA.visible = false
	$ButtonB.visible = false
	var text
	if (richtigeAntwort == 1):
		text = "You are right!!!"
		$NextGameButton.visible = true
	else:
		text = "You are Wrong!!!"
		lifes -= 1
		if lifes <= 0:
			_failed()
		
		$ResetButton.visible = true
	$MiniGameRes.text = text
	$MiniGameRes.visible = true


func _on_reset_button_pressed() -> void:
	$ButtonA.visible = true
	$ButtonB.visible = true
	$MiniGameRes.text = ""
	$MiniGameRes.visible = false
	$ResetButton.visible = false


func _on_next_game_button_pressed() -> void:
	_on_reset_button_pressed()
	emit_signal("finished")

func _failed() -> void:
	_on_reset_button_pressed()
	emit_signal("failed")