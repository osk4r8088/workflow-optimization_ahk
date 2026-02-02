#Requires AutoHotkey v2.0

StringPaste_Init(cfgPath) {
    text := IniRead(cfgPath, "StringPaste", "Text", "paste")
    hk   := IniRead(cfgPath, "StringPaste", "Hotkey", "NumpadAdd")

    Hotkey hk, (*) => StringPaste_Do(text), "On"
}

StringPaste_Do(text) {
    saved := ClipboardAll()
    try {
        A_Clipboard := ""
        A_Clipboard := text
        ClipWait 0.5
        Send "^v"
        Sleep 30
    } finally {
        A_Clipboard := saved
    }
}
