# workflow-optimization_ahk

A modular workflow automation toolkit for Windows built with AutoHotkey v2. Each module can be toggled on/off from the system tray and all settings are persisted in `config.ini`.

## Requirements

- **AutoHotkey v2.0+** — works with both the [Microsoft Store edition]([https://apps.microsoft.com/detail/autohotkey-v2](https://apps.microsoft.com/detail/9plqfdg8hh9d)) and the [standard installer](https://www.autohotkey.com/)

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

### Tray Menu

| Action | Description |
|--------|-------------|
| Tray → Modules → *module* | Enable / Disable any module |
| Tray → Open config.ini | Edit configuration |
| Tray → Reload | Reload script after config changes |

A TrayTip notification appears when toggling modules.

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
├── config.ini                           # All user settings
├── README.md
└── modules/
    ├── autoclick/module.ahk             # Auto-clicker
    ├── autoreplace/module.ahk           # Typo auto-correction
    ├── copypaste/module.ahk             # Mouse button copy/paste
    ├── mediakeys/module.ahk             # Numpad media controls
    ├── multitask/module.ahk             # Utility hotkeys & app launchers
    ├── stringpaste/module.ahk           # Quick text paste
    └── textexpander/module.ahk          # Abbreviation expander
```

## Known Issues & Store Edition Compatibility

This project was developed and tested with the **AutoHotkey v2 Microsoft Store edition**, which has quirks compared to the standard installer:

- **`A_TrayMenu.Delete()` crashes the Store edition** — the tray menu is built once at startup instead of being rebuilt on each toggle. Checkmarks are updated in place.
- **`Persistent` directive is required** — without it the script exits immediately since hotkeys start in the "Off" state and don't keep the script alive on their own
- **The Store edition launcher can fail with certain file paths** — if you get a `launcher.ahk` error about `FileRead(ScriptPath)`, move the project to a simpler path like `C:\Users\<you>\Documents\`

These workarounds are already applied. The script is fully compatible with both the Store and standard editions of AHK v2.

## License

MIT (= Do whatever you want with it, just credit me when republishing or making additions)
