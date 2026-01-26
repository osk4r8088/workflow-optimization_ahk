; This script binds open "program" to "button", automatically creates and paste's timestamps on keybind, gives the option to plain paste 
; settings / configuration for this script can be adjusted under cfg.hk and paths for programs under cfg.paths

#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
SetWorkingDir A_ScriptDir

cfg := {
    paths: {
        edge:      "",                                            ; e.g. "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
        notepadpp: "C:\Program Files\Notepad++\notepad++.exe",
        teams:     "",                                            ; e.g. "C:\Program Files\Microsoft\Teams\current\Teams.exe"
        outlook:   ""                                             ; e.g. "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
    },
    hk: {
        PlainPaste: "^+v",
        DateTime:   "NumpadMult",
        FileStamp:  "NumpadSub",
        Edge:       "Numpad7",
        NotepadPP:  "Numpad8",
        Teams:      "Numpad9",
        Outlook:    "NumpadAdd"
    }
}

Hotkey cfg.hk.PlainPaste, PlainPaste
Hotkey cfg.hk.DateTime,   (*) => SendText(FormatTime(, "dd.MM.yyyy HH:mm"))
Hotkey cfg.hk.FileStamp,  (*) => SendText(FormatTime(, "yyyy-MM-dd_HHmm"))

Hotkey cfg.hk.Edge,      (*) => Launch(cfg.paths.edge,      "msedge.exe")
Hotkey cfg.hk.NotepadPP, (*) => Launch(cfg.paths.notepadpp, "notepad.exe")
Hotkey cfg.hk.Teams,     (*) => Launch(cfg.paths.teams,     "teams.exe")
Hotkey cfg.hk.Outlook,   (*) => Launch(cfg.paths.outlook,   "outlook.exe")

PlainPaste(*) {
    save := ClipboardAll()
    try {
        txt := A_Clipboard
        A_Clipboard := txt
        ClipWait(0.3)
        Send("^v")
    } catch {
        TrayTip("Plain paste failed")
    } finally {
        A_Clipboard := save
    }
}

Launch(path, fallbackExe) {
    try {
        if (path && FileExist(path))
            Run('"' path '"')
        else
            Run(fallbackExe)
    } catch {
        TrayTip("Launch failed: " (path ? path : fallbackExe))
    }
}


