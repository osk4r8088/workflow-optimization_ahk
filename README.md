# workflow-optimization_ahk

A modular workflow automation toolkit for Windows built with AutoHotkey v2. Each module can be toggled on/off from the system tray and all settings are persisted in `config.ini`.

## Requirements

- **AutoHotkey v2.0+** — works with both the [Microsoft Store edition](https://apps.microsoft.com/detail/autohotkey-v2) and the [standard installer](https://www.autohotkey.com/)

## Quick Start

1. Clone or download this repo
2. Double-click `main.ahk`
3. Right-click the tray icon → **Modules** to enable/disable features

## Keybinds

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

### Tray Menu

| Action | Description |
|--------|-------------|
| Tray → Modules → AutoClick | Enable / Disable AutoClick |
| Tray → Modules → MultiTask | Enable / Disable MultiTask |
| Tray → Modules → CopyPaste | Enable / Disable CopyPaste |
| Tray → Modules → StringPaste | Enable / Disable StringPaste |
| Tray → Open config.ini | Edit configuration |
| Tray → Reload | Reload script after config changes |

## Configuration

All hotkeys, paths, and settings live in `config.ini` (editable via tray → **Open config.ini**). Changes take effect after a reload.

```ini
[Modules]
autoclick=0
multitask=1
copypaste=1
stringpaste=1

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
```

## Project Structure

```
workflowahk/
├── main.ahk                          # Entry point, tray menu, module framework
├── config.ini                        # All user settings
├── README.md
└── modules/
    ├── autoclick/module.ahk          # Auto-clicker
    ├── copypaste/module.ahk          # Mouse button copy/paste
    ├── multitask/module.ahk          # Utility hotkeys & app launchers
    └── stringpaste/module.ahk        # Quick text paste
```

## Known Issues & Store Edition Compatibility

This project was developed and tested with the **AutoHotkey v2 Microsoft Store edition**, which has quirks compared to the standard installer:

- **`A_TrayMenu.Delete()` crashes the Store edition** — the tray menu is built by creating a fresh `Menu()` object on each rebuild instead of calling `.Delete()` on the existing one
- **`Persistent` directive is required** — without it the script exits immediately since hotkeys start in the "Off" state and don't keep the script alive on their own
- **The Store edition launcher can fail with certain file paths** — if you get a `launcher.ahk` error about `FileRead(ScriptPath)`, move the project to a simpler path like `C:\Users\<you>\Documents\`

These workarounds are already applied. The script is fully compatible with both the Store and standard editions of AHK v2.

## License

MIT
