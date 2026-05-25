class_name Cutscene
extends Node2D

## Dokumentation

var timeline_pointer = 0 # for Debug purposes

var is_current_scene_cutscene = false

var cutscenes = []
var animations = []
var timeline_objects = []

var _background
var _subtitles
var _continue


var current_cutscene = {
	"id": 0,
	"name": "",
	"subtitles": "",
	"background_image_path": "",
	"objects": []
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cutscenes = read_JSON("res://Database/cutscenes.json")
	#animations = read_JSON("res://Database/animations.json") #TODO animations structure hinzufügen und Funktionalität hinzufügen
	timeline_objects = read_JSON("res://Database/timeline.json")

	_background = $Background
	_subtitles = $UiElements/Subtitles
	_continue = $UiElements/ContinueTextureButton

	get_current_cutscene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func read_JSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish


func get_current_cutscene():
	if timeline_objects["timelineObjects"][timeline_pointer]["type"] != "Cutscene":
		is_current_scene_cutscene = false
		_continue.visible = true
		return

	is_current_scene_cutscene = true

	var current_cutscene_id = timeline_objects["timelineObjects"][timeline_pointer]["id"]

	for cutscene in cutscenes["cutscenes"]:
		if cutscene["id"] == current_cutscene_id:
			current_cutscene["id"] = current_cutscene_id
			current_cutscene["name"] = cutscene["name"]
			current_cutscene["subtitles"] = cutscene["subtitles"]
			current_cutscene["background_image_path"] = cutscene["backgroundImagePath"]
			current_cutscene["objects"] = cutscene["objects"]
			print(current_cutscene)
			break


func _on_continue_texture_button_pressed() -> void:
	if timeline_pointer < timeline_objects["timelineObjects"].size() - 1:
		timeline_pointer += 1

		_continue.visible = false

		get_current_cutscene()
		
		if is_current_scene_cutscene:
			play_cutscene()
		

func play_cutscene():
	_background.texture = load(current_cutscene["background_image_path"])

	var characters = current_cutscene["subtitles"].split()
	var text = ""
	_subtitles.text = text

	await get_tree().create_timer(0.05).timeout

	for character in characters:
		text += character
		_subtitles.text = text
		await get_tree().create_timer(0.05).timeout

	_continue.visible = true
