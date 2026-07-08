# Gameification Tool

A space-themed, gamified onboarding tool built with **Godot 4.6**. Players fly through
minigames, cutscenes, and a job-selection sequence that teach basic workplace concepts
(e.g. code review / commit etiquette, marketing posts) through interactive
single-choice, multi-choice, drag-and-drop, and ordering questions.

This project was built as part of *Softwareprojekt 2026, Thema 6* at TU Ilmenau.
## Demo

![Demo - game playthrough](Readme_Data/Game.gif)
## Tech stack

- **Engine**: Godot 4.6 (GDScript, GL Compatibility renderer)
- **Export target**: Web (HTML5/WASM)
- Game content (minigames, cutscenes, planets, timeline) is data-driven via JSON —
  no code changes needed to add/edit questions or cutscenes.

## Project structure

```
Assets/       Textures, fonts, shaders, UI graphics (lowercase snake_case naming)
Scenes/       Godot scenes (.tscn)
Scripts/      GDScript source
Database/     JSON content: minigames.json, cutscenes.json, planets.json, timeline.json, config.json
Export/       Build output (gitignored, regenerate via export)
```

## Getting started

1. Install [Godot 4.6](https://godotengine.org/download) (or use the engine binary
   already checked out under `.godot/`, if present).
2. Open `project.godot` in the Godot editor.
3. Press **F5** (or the Play button) to run the game.

## Exporting

The project has a "Web" export preset configured in `export_presets.cfg`.

**Via the editor**: Project → Export... → select "Web" → Export Project.

**Via command line**, from the project root:

```powershell
.\.godot\Godot_v4.6.2-stable_win64.exe --headless --path . --export-release "Web" "<output-dir>\Gameification_Tool.html"
```

Replace `<output-dir>` with an existing directory. Godot does not create the target
folder automatically — create it first if it doesn't exist.

## Content editing

Most gameplay content lives in `Database/*.json` and is loaded at runtime — editing
questions, solutions, or cutscene steps there does not require touching GDScript.
See `Scripts/Data/minigame_object.gd` for the expected schema.

## Web admin panel

A small browser-based single-page app (`AdminPanel/`) for managing the game without
needing the Godot editor. Run it with:

```powershell
python AdminPanel/server.py
```

Then open `http://localhost:8000`. Features:

- **Launch Game** button — opens the exported Web build from `Export/`.
- **Edit content JSONs** (`animations.json`, `config.json`, `cutscenes.json`,
  `minigames.json`, `planets.json`, `timeline.json`) as an expandable tree; click
  **Edit** on any value to change it via a prompt, then **Save** to write it back to
  `Database/`.
- More admin/QA features to be added over time.

Notes:
- Stdlib-only Python server, no external dependencies.
- Requires an existing export in `Export/` (see [Exporting](#exporting)) for the
  Launch Game button to work.
- Saving a file reformats it (standard 2-space JSON indent) and normalizes numbers
  through JavaScript, so whole-number floats like `10.0` become `10` — the first save
  of any given file will show as a full-file diff.
