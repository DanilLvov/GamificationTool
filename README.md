# Gameification Tool

A space-themed, gamified recruiting tool built with **Godot 4.6**, designed to run at
trade fair booths (*Messebetrieb*). Prospective applicants pick a career path from an
interactive planet carousel, then fly through minigames and cutscenes that test basic
job-relevant competencies (e.g. code review / commit etiquette, marketing posts)
through single-choice, multi-choice, drag-and-drop, and ordering questions.

This project was built as part of *Softwareprojekt 2026, Thema 6* at TU Ilmenau.

## Demo

![Demo - game playthrough](Readme_Data/Game.gif)

## Tech stack

- **Engine**: Godot 4.6 (GDScript, GL Compatibility renderer)
- **Export target**: Web (HTML5/WASM)
- Game content (minigames, cutscenes, planets, timeline) is data-driven via JSON —
  no code changes needed to add/edit questions or cutscenes.

## Architecture

The app runs as a single main scene that embeds all sub-scenes (start screen, career
selection, cutscene handler, minigame controller, debug menu, restart/end screens),
toggling their visibility instead of loading new Godot scenes. This keeps scene
switches instant and avoids reload times during a fair-floor session.

- **Timeline & GameState** — a linear `Timeline` of entries (`state`, `next_scene`,
  `resource_id`, `next_scene_fail`) drives the whole flow. `state` is one of `START`,
  `SPECIALIZATION_CHOICE`, `CUTSCENE`, `MINIGAME`, `END`. Sub-scenes don't know what
  comes next — they just emit a signal (`finished`/`failed`), and the main scene
  advances the timeline.
- **Career selection** — an infinite, wraparound planet carousel (spacing, radius,
  scaling, and opacity falloff are all tunable script parameters); the centered planet
  is the selected career path.
- **Minigames & questions** — each minigame pulls a configurable number of questions
  for the chosen career path. Every question type (`SINGLECHOICE`, `MULTICHOICE`,
  `DRAG_AND_DROP`, `ORDER`) extends a common `BaseQuestion` class exposing
  `signal_correct`/`signal_wrong`, so the `MinigameController` never needs to know the
  concrete question type.
- **Cutscenes & animations** — a cutscene is a background + subtitle text + a list of
  (optionally animated) objects; animations interpolate position/scale/rotation or swap
  sprites between keyframes, with optional looping.
- **Debug / Restart / Idle systems** — a debug menu (dev/test only, gated by the
  `"debug"` config flag) can jump to any timeline entry or skip minigame questions; a
  restart flow lets the app be reset to the start screen on demand; an idle timer
  auto-resets the app after prolonged inactivity — both important for unattended
  trade-fair kiosk operation.
- **UI Factory** — a static helper class centralizing creation of buttons (with
  normal/hover/pressed textures), panels, labels, and fonts, so every scene gets a
  consistent look without duplicating UI-building code.

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
Each file has one clear responsibility:

| File | Responsibility |
|---|---|
| `timeline.json` | Application flow — the ordered sequence of scenes/states |
| `minigames.json` | Minigame definitions: questions, answers, and solutions |
| `cutscenes.json` | Cutscene content: background, subtitles, animated objects |
| `animations.json` | Keyframes (position/scale/rotation/image) for animated objects |
| `planets.json` | Selectable career paths and their carousel visuals |
| `config.json` | Global settings — debug flag, idle/restart timings, etc. |

The top level of each file is a dictionary keyed by string IDs (even where the ID is
numeric), so entries can be referenced and cross-linked without relying on array
order. See `Scripts/Data/minigame_object.gd` for the expected schema.

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

## Authors

Hüseyin Talip Akyüz, Nils Vincent Blechschmidt, Moritz Kaufmann, Danyil Lvov,
Dana Pietrzenuk, Max Seeber — *Softwareprojekt 2026, Thema 6*, TU Ilmenau.
