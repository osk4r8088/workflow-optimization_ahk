# MACROHUB-OS AHK Multiscript
A modular workflow automation toolkit for Windows built with AutoHotkey v2. Each module can be toggled on/off from the system tray and all settings are persisted in `config.ini`.

## Targets for future improvement / goals
- ~~Conflict detection: warns if choosen hotkeys overlap before applying. (within and across modules)~~ ✅ Done (basic): a warning dialog lists any hotkey/abbreviation registered by two or more enabled modules, at startup and when enabling a module from the tray.
- easy accessibility settings UI: small GUI for toggles, keybinds, text lists. (no INI editing required)
- “Safe Defaults” profile: a preset that avoids common conflicts and uses conservative hotkeys.
- One-click restore: Reset to defaults + Backup/Restore config from tray.

- Auto-register modules: main script discovers modules/*/module.ahk and reads manifest to build tray + settings UI automatically.
- Per-module enable/disable without reload (where possible): hotkey enable/disable live; reload only when required.

- Module manifest standard: each module provides metadata (name, description, defaults, hotkeys used, conflicts, settings schema).
- Central logging: optional log file (errors + key events) with “Open logs” in tray.

- Separate documentation: a short “Adding expansions & typo fixes” guide with examples + troubleshooting.
- Admin-friendly docs: “Deploy to a team” page: where config lives, how to lock settings, how to push updates
- README stays high-level: what it does, how to run, how to toggle modules.
- User Guide (separate): “Common tasks” with screenshots (tray menu, settings UI).
- Power-user Guide: hotkey customization, profiles, per-app rules.

## Requirements

- **AutoHotkey v2.0+** — works with both the [Microsoft Store edition](https://apps.microsoft.com/detail/9plqfdg8hh9d) and the [standard installer](https://www.autohotkey.com/)

## Quick Start

1. Clone or download this repo
2. Double-click `main.ahk`
3. Right-click the tray icon → **Modules** to enable/disable features

test.ahk can be ignored or used for testing Autohotkey availability and functionality.

## Modules & Keybinds

### CopyPaste

| Hotkey | Action |
|--------|--------|
| `XButton1` (Mouse4) | Copy (`Ctrl+C`) |
| `XButton2` (Mouse5) | Paste (`Ctrl+V`) |

### AutoClick

| Hotkey | Action |
|--------|--------|
| `Ctrl + Left Click` (hold) | Auto-click repeatedly |

Configurable delay (`DelayMs`) and button in `config.ini`.

### MultiTask

| Hotkey | Action |
|--------|--------|
| `Ctrl+Shift+V` | Plain text paste (strips formatting) |
| `Numpad *` | Type current date/time (`dd.MM.yyyy HH:mm`) |
| `Numpad -` | Type file-safe timestamp (`yyyy-MM-dd_HHmm`) |
| `Numpad 7` | Launch Microsoft Edge |
| `Numpad 8` | Launch Notepad++ (falls back to Notepad) |
| `Numpad 9` | Launch Microsoft Teams |
| `Numpad +` | Launch Outlook |

### StringPaste

| Hotkey | Action |
|--------|--------|
| `Ctrl+Alt+P` | Paste preconfigured text |

Set the text in `config.ini` under `[StringPaste]` → `Text=`.

### TextExpander

Type an abbreviation and it auto-expands into the full text. Define abbreviations in `config.ini` under `[TextExpander]`.

| Example Abbreviation | Expands To |
|----------------------|------------|
| `@@` | `example@email.com` |
| `addr` | `123 Example Street, City` |
| `sig` | `Best regards, Your Name` |
| `btw` | `by the way` |

Add your own: `abbreviation=expansion` in the `[TextExpander]` section.

Expansion triggers after you type an ending character (space, Enter, or punctuation) — so abbreviations never fire in the middle of a longer word (typing `address` won't trigger `addr`).

### MediaKeys

Map numpad keys to media controls — useful for keyboards without dedicated media keys.

| Default Hotkey | Action |
|----------------|--------|
| `Numpad 0` | Play / Pause |
| `Numpad 6` | Next Track |
| `Numpad 4` | Previous Track |
| `Numpad 2` | Volume Up |
| `Numpad 5` | Volume Down |
| `Numpad 1` | Mute |

> **Note:** MediaKeys and MultiTask both use numpad keys by default. Enable only one at a time, or remap one of them in `config.ini` to avoid conflicts.

### AutoReplace

Automatically fixes common typos as you type. Define corrections in `config.ini` under `[AutoReplace]`.

| Typo | Corrected To |
|------|-------------|
| `teh` | `the` |
| `recieve` | `receive` |
| `definately` | `definitely` |
| `adn` | `and` |
| `dont` | `don't` |

Add your own: `typo=correction` in the `[AutoReplace]` section.

Corrections are case-sensitive: `teh` is fixed, but `Teh` is left alone (this also keeps intentional all-caps like `IM` from being rewritten).

### ClipHistory

Keeps the last 15 text clips you copied (configurable via `MaxItems`).

| Hotkey | Action |
|--------|--------|
| `Ctrl+Alt+H` | Open the history menu — click a clip (or press `1`–`9`) to paste it |

The chosen clip stays on the clipboard afterwards, like Windows' own Win+V. "Clear history" wipes the list.

### WindowTools

| Hotkey | Action |
|--------|--------|
| `Ctrl+Alt+T` | Toggle always-on-top for the active window |
| `Ctrl+Alt+M` | Move the active window to the next monitor (keeps relative position, re-maximizes) |
| `Ctrl+Alt+C` | Center the active window on its monitor |

> Word users: `Ctrl+Alt+C` is Word's © shortcut — remap `Center=` in `config.ini` if you need that.

### QuickNote

| Hotkey | Action |
|--------|--------|
| `Ctrl+Alt+N` | Append the selected text to `notes.txt` with a timestamp; with nothing selected, a small input box asks for the note |

The file location is configurable (`File=`, relative paths resolve next to `main.ahk`). Optionally set `OpenHotkey=` to get a hotkey that opens the notes file.

### SearchSelection

| Hotkey | Action |
|--------|--------|
| `Ctrl+Alt+S` | Google the selected text in your default browser |

The search engine is a URL template (`URL=` with `%s` as the placeholder), so DeepL, LEO, DuckDuckGo etc. work too — e.g. `URL=https://duckduckgo.com/?q=%s`.

> **German keyboards:** AltGr equals Ctrl+Alt, but none of the default letters (h/t/m/c/n/s/p) are AltGr characters, so normal typing is unaffected.

### Tray Menu

| Item | Description |
|------|-------------|
| Open | Show the script's main window (variables/debug info) |
| Modules → *module* | Enable / Disable any module — the submenu reopens after each click so you can toggle several in a row, silently (checkmark = feedback) |
| Window Spy | AHK's window inspector — shows title, `ahk_class`, `ahk_exe`, control names of the window under the mouse (useful for writing per-app rules) |
| Open Config | Edit `config.ini` in Notepad |
| Hotkey Settings | Rebind any module hotkey by **pressing** the new combo — no INI editing or key-name lookup. Also assigns per-module toggle hotkeys. |
| Pause Script | Pause / resume the whole script |
| Suspend Hotkeys | Temporarily disable all hotkeys/hotstrings |
| Reload Script | Full reload — needed after changing hotkeys or word lists |
| Reload Modules | Re-read the `[Modules]` on/off flags from `config.ini` and apply them live (no full reload) |
| Help | Open the AutoHotkey v2 documentation |
| Exit | Quit |

The menu is fully custom — AHK's standard tray items are removed at startup so nothing appears twice.

### Hotkey Settings & toggle hotkeys

**Hotkey Settings** (tray) lists every rebindable function. Select a row, press the new key combo in the capture box (or type it manually for Win-/mouse-key combos like `#c` or `XButton1`), Apply, then Save & Reload. Invalid combos are rejected and duplicates warn before assigning.

The list also contains a **"Toggle module: …"** row per module — bind one (e.g. `Ctrl+Alt+F1`) to switch that module on/off from the keyboard. Hotkey toggles show a TrayTip so you know the state; tray-menu toggles are silent.

```ini
[ToggleHotkeys]
cliphistory=^!F1
autoreplace=^!F2
```

## Configuration

All hotkeys, paths, and settings live in `config.ini` (editable via tray → **Open config.ini**). Changes take effect after a reload.

```ini
[Modules]
autoclick=0
multitask=1
copypaste=1
stringpaste=1
textexpander=0
mediakeys=0
autoreplace=0
cliphistory=1
windowtools=1
quicknote=1
searchselection=1

[ClipHistory]
Hotkey=^!h
MaxItems=15

[WindowTools]
AlwaysOnTop=^!t
NextMonitor=^!m
Center=^!c

[QuickNote]
Hotkey=^!n
OpenHotkey=
File=notes.txt

[SearchSelection]
Hotkey=^!s
URL=https://www.google.com/search?q=%s

[AutoClick]
DelayMs=30
Button=Left

[CopyPaste]
CopyHotkey=XButton1
PasteHotkey=XButton2

[MultiTask]
PlainPaste=^+v
DateTime=NumpadMult
FileStamp=NumpadSub
Edge=Numpad7
NotepadPP=Numpad8
Teams=Numpad9
Outlook=NumpadAdd

[MultiTask.Paths]
edge=
notepadpp=C:\Program Files\Notepad++\notepad++.exe
teams=
outlook=

[StringPaste]
Hotkey=^!p
Text=paste

[TextExpander]
@@=example@email.com
addr=123 Example Street, City
sig=Best regards, Your Name
btw=by the way
omw=on my way

[MediaKeys]
PlayPause=Numpad0
Next=Numpad6
Prev=Numpad4
VolUp=Numpad2
VolDown=Numpad5
Mute=Numpad1

[AutoReplace]
teh=the
recieve=receive
definately=definitely
seperate=separate
occured=occurred
adn=and
dont=don't
cant=can't
wont=won't
im=I'm
```

## Project Structure

```
workflowahk/
├── main.ahk                            # Entry point, tray menu, module framework
├── settings.ahk                         # Hotkey Settings GUI (press-to-bind)
├── config.ini                           # All user settings
├── README.md
└── modules/
    ├── autoclick/module.ahk             # Auto-clicker
    ├── autoreplace/module.ahk           # Typo auto-correction
    ├── cliphistory/module.ahk           # Clipboard history with paste menu
    ├── copypaste/module.ahk             # Mouse button copy/paste
    ├── mediakeys/module.ahk             # Numpad media controls
    ├── multitask/module.ahk             # Utility hotkeys & app launchers
    ├── quicknote/module.ahk             # Append notes/selections to a text file
    ├── searchselection/module.ahk       # Web-search the selected text
    ├── stringpaste/module.ahk           # Quick text paste
    ├── textexpander/module.ahk          # Abbreviation expander
    └── windowtools/module.ahk           # Always-on-top, move to monitor, center
```

## Changelog

### 2026-07 — Hotkey Settings GUI & tray polish
- **New: Hotkey Settings** (tray) — rebind any module hotkey by pressing the combo; capture box + manual field for Win/mouse keys; validation and duplicate warnings included
- **New: per-module toggle hotkeys** (`[ToggleHotkeys]`) — switch a module on/off from the keyboard, with TrayTip feedback
- Tray module toggles are now **silent** and the Modules submenu **reopens after each click**, so toggling several modules no longer means reopening the menu every time
- "Reload Modules" shows one summary TrayTip instead of one per module

### 2026-07 — tray menu overhaul
- Removed AHK's standard tray items (duplicate Exit/Reload, Edit Script) — the menu is now fully custom: Open / Modules / Window Spy / Open Config / Pause / Suspend / Reload Script / Reload Modules / Help / Exit
- **New: "Reload Modules"** — re-reads the `[Modules]` flags from `config.ini` and applies them without restarting the script

### 2026-07 — four new modules
- **ClipHistory**: last 15 text clips, `Ctrl+Alt+H` opens a paste menu
- **WindowTools**: always-on-top toggle, move-to-next-monitor, center window
- **QuickNote**: append selected text (or a typed note) to `notes.txt` with a timestamp
- **SearchSelection**: select text, `Ctrl+Alt+S`, Google (or any engine via URL template) opens in the browser

### 2026-07 maintenance pass
- **Fixed:** disabling TextExpander/AutoReplace after use no longer silently deletes typed abbreviations (hotstrings are now properly toggled Off instead of firing with an empty action)
- **Fixed:** TextExpander abbreviations no longer trigger mid-word (`addr` used to make typing `address` impossible)
- **Fixed:** clipboard-restore race in StringPaste and plain paste — the original clipboard was restored before the target app read the pasted text
- **Fixed:** an invalid hotkey in `config.ini` no longer crashes startup — the module shows a TrayTip and the rest keeps working
- **New:** hotkey conflict detection — a warning lists any key/abbreviation claimed by two or more enabled modules (at startup and on tray toggle)
- Shipped `config.ini` now matches the documented safe defaults (only MultiTask, CopyPaste, StringPaste on)

## Known Issues & Store Edition Compatibility

This project was developed and tested with the fuckass **AutoHotkey v2 Microsoft Store edition**, which has so many weird "quirks" compared to the standard installer.
That I ran into multiple stability issues so severe that I started vibecoding the following fixes / workarounds using Claude:

- **`A_TrayMenu.Delete()` crashes the Store edition** — the tray menu is built once at startup instead of being rebuilt on each toggle. Checkmarks are updated in place.
- **`Persistent` directive is required** — without it the script exits immediately since hotkeys start in the "Off" state and don't keep the script alive on their own
- **The Store edition launcher can fail with certain file paths** — if you get a `launcher.ahk` error about `FileRead(ScriptPath)`, move the project to a simpler path like `C:\Users\<you>\Documents\`
These workarounds are already applied. The script is fully compatible with both the Store and standard editions of AHK v2.

## License

MIT (= Do whatever you want with it, just credit me when republishing or making additions)
