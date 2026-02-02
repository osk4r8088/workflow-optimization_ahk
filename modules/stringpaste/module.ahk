global g_StringPasteHK := ""

StringPaste_Init(cfgPath) {
    global g_StringPasteHK
    text := IniRead(cfgPath, "StringPaste", "Text", "paste")
    hk   := IniRead(cfgPath, "StringPaste", "Hotkey", "^!p")
    g_StringPasteHK := hk
    Hotkey hk, (*) => StringPaste_Do(text), "Off"
}

StringPaste_SetEnabled(enable) {
    global g_StringPasteHK
    Hotkey g_StringPasteHK, enable ? "On" : "Off"
}
