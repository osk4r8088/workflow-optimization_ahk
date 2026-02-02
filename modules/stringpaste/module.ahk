#Requires AutoHotkey v2.0

global g_StringPaste := { hk: "", text: "" }

StringPaste_Init(cfgPath) {
    global g_StringPaste
    g_StringPaste.text := IniRead(cfgPath, "StringPaste", "Text", "paste")
    g_StringPaste.hk   := IniRead(cfgPath, "StringPaste", "Hotkey", "^!p")
    Hotkey g_StringPaste.hk, StringPaste_Handler, "Off"
}

StringPaste_SetEnabled(enable) {
    global g_StringPaste
    Hotkey g_StringPaste.hk, enable ? "On" : "Off"
}

StringPaste_Handler(*) {
    global g_StringPaste
    saved := ClipboardAll()
    try {
        A_Clipboard := ""
        A_Clipboard := g_StringPaste.text
        ClipWait 0.5
        Send "^v"
    } finally {
        A_Clipboard := saved
    }
}
