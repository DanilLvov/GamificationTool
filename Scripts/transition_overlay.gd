class_name TransitionOverlay
extends ColorRect

## Full-screen fade effect, driven by named presets instead of a case/match
## ladder. Add a new transition by adding a new dictionary entry.
var presets := {
	"fade_in": {"from": 1.0, "to": 0.0},
	"black_out": {"from": 0.0, "to": 1.0},
}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


# Plays a named transition and waits for it to finish. Snaps to the preset's
# starting alpha first, so the result doesn't depend on whatever alpha the
# overlay was left at.
func play(transition_name: String, duration: float = 0.6) -> void:
	var preset = presets.get(transition_name)
	if preset == null:
		push_error("Transition not found: " + transition_name)
		return

	color.a = preset["from"]

	var tween := create_tween()
	tween.tween_property(self, "color:a", preset["to"], duration)
	await tween.finished
