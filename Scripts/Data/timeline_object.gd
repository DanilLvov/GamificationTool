class_name TimelineObject

enum GameState {
    # Different states for different points of the game, when switched between states UI should be updated (f.E. disable some buttons etc.)
    START,
    CUTSCENE,
    MINIGAME,
    SPECIALIZATION_CHOICE,
    END
} 

var _name: String
var _state: GameState
var _next_scene: int
var _resource_id: int     #used only for cutscene and minigame
var _next_scene_fail: int # used only for minigame

func _init(name: String, state: GameState, next_scene: int, resource_id: int, next_scene_fail: int) -> void:
    _name = name
    _state = state  
    _next_scene = next_scene
    _resource_id = resource_id
    _next_scene_fail = next_scene_fail

static func load_timeline_array(path: String) -> Array:

    if not FileAccess.file_exists(path):
        push_error("JSON file not found: %s" % path)
        return []
        
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("Cannot open JSON file: %s" % path)
        return []

    var json_text := file.get_as_text()
    var parsed = JSON.parse_string(json_text)

    if parsed == null:
        push_error("Invalid JSON in file: %s" % path)
        return []

    if typeof(parsed) != TYPE_DICTIONARY:
        push_error("Root JSON must be an object/dictionary")
        return []
    
    var array: Array[TimelineObject] = []
    
    for scene_id in parsed.keys():
        var scene_data = parsed[scene_id]
        var name
        var state
        var next_scene
        var resource_id = -1
        var next_scene_fail = -1

        if typeof(scene_data) != TYPE_DICTIONARY:
            push_error("Scene '%s' must be of Type Dictionary" % scene_id)
            continue

        if not scene_data.has("name"):
            push_error("Scene '%s' has no name" % scene_id)
            name = "empty"
        else:
            name = scene_data["name"]

        if not scene_data.has("state"):
            push_error("Scene '%s' has no state" % scene_id)
            continue
        
        state = scene_data["state"]
        if not GameState.has(state):
            push_error("Unknown state '%s' in scene '%s'" % [state, scene_id])
            continue
        state = GameState[state]

        if not scene_data.has("next_scene"):
            push_error("Scene '%s' has no next_scene" % scene_id)
        next_scene = scene_data["next_scene"]

        if scene_data.has("cutscene_id"):
            resource_id = scene_data["cutscene_id"]
            
        elif scene_data.has("minigame_id"):
            resource_id = scene_data["minigame_id"]
            if not scene_data.has("next_scene_fail"):
                push_error("Minigame '%s' has no next_scene_fail" % scene_id)
                continue
            next_scene_fail = scene_data["next_scene_fail"]

        
        array.append(TimelineObject.new(name, state, int(next_scene), int(resource_id), int(next_scene_fail)))

    return array

