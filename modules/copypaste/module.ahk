#Requires AutoHotkey v2.0

global g_CopyPaste := { copy: "XButton1", paste: "XButton2" }

CopyPaste_Init(cfgPath) {
    global g_CopyPaste
    g_CopyPaste.copy  := IniRead(cfgPath, "CopyPaste", "CopyHotkey",  "XButton1")
    g_CopyPaste.paste := IniRead(cfgPath, "CopyPaste", "PasteHotkey", "XButton2")
    Hotkey g_CopyPaste.copy,  (*) => Send("^c"), "Off"
    Hotkey g_CopyPaste.paste, (*) => Send("^v"), "Off"
}

CopyPaste_SetEnabled(enable) {
    global g_CopyPaste
    Hotkey g_CopyPaste.copy,  enable ? "On" : "Off"
    Hotkey g_CopyPaste.paste, enable ? "On" : "Off"
}
