#Requires AutoHotkey v2.0

MultiTask_Init(cfgPath) {
    ; hotkeys
    hkPlain := IniRead(cfgPath, "MultiTask", "PlainPaste", "^+v")
    hkDT    := IniRead(cfgPath, "MultiTask", "DateTime",   "NumpadMult")
    hkFS    := IniRead(cfgPath, "MultiTask", "FileStamp",  "NumpadSub")
    hkEdge  := IniRead(cfgPath, "MultiTask", "Edge",       "Numpad7")
    hkNpp   := IniRead(cfgPath, "MultiTask", "NotepadPP",  "Numpad8")
    hkTeams := IniRead(cfgPath, "MultiTask", "Teams",      "Numpad9")
    hkOutl  := IniRead(cfgPath, "MultiTask", "Outlook",    "NumpadAdd")

    ; paths
    pEdge   := IniRead(cfgPath, "MultiTask.Paths", "edge",      "")
    pNpp    := IniRead(cfgPath, "MultiTask.Paths", "notepadpp", "C:\Program Files\Notepad++\notepad++.exe")
    pTeams  := IniRead(cfgPath, "MultiTask.Paths", "teams",     "")
    pOutl   := IniRead(cfgPath, "MultiTask.Paths", "outlook",   "")

    Hotkey hkPlain, (*) => MultiTask_PlainPaste()
    Hotkey hkDT,    (*) => SendText(FormatTime(, "dd.MM.yyyy HH:mm"))
    Hotkey hkFS,    (*) => SendText(FormatTime(, "yyyy-MM-dd_HHmm"))

    Hotkey hkEdge,  (*) => MultiTask_Launch(pEdge,  "msedge.exe")
    Hotkey hkNpp,   (*) => MultiTask_Launch(pNpp,   "notepad.exe")
    Hotkey hkTeams, (*) => MultiTask_Launch(pTeams, "teams.exe")
    Hotkey hkOutl,  (*) => MultiTask_Launch(pOutl,  "outlook.exe")
}

MultiTask_PlainPaste() {
    save := ClipboardAll()
    try {
        txt := A_Clipboard
        A_Clipboard := txt
        ClipWait 0.3
        Send "^v"
    } catch {
        TrayTip "Plain paste failed"
    } finally {
        A_Clipboard := save
    }
}

MultiTask_Launch(path, fallbackExe) {
    try {
        if (path != "" && FileExist(path))
            Run('"' path '"')
        else
            Run(fallbackExe)
    } catch {
        TrayTip "Launch failed: " (path != "" ? path : fallbackExe)
    }
}
