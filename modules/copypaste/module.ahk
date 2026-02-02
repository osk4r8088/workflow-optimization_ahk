#Requires AutoHotkey v2.0

global g_CopyPaste := { cfg:"", copy:"XButton1", paste:"XButton2", enabled:true }

CopyPaste_Init(cfgPath) {
    global g_CopyPaste
    g_CopyPaste.cfg := cfgPath
    g_CopyPaste.copy := IniRead(cfgPath, "CopyPaste", "CopyHotkey", "XButton1")
    g_CopyPaste.paste := IniRead(cfgPath, "CopyPaste", "PasteHotkey", "XButton2")

    Hotkey g_CopyPaste.copy,  (*) => Send("^c"), "Off"
    Hotkey g_CopyPaste.paste, (*) => Send("^v"), "Off"
}

CopyPaste_SetEnabled(enable) {
    global g_CopyPaste
    g_CopyPaste.enabled := !!enable
    Hotkey g_CopyPaste.copy,  enable ? "On" : "Off"
    Hotkey g_CopyPaste.paste, enable ? "On" : "Off"
}
