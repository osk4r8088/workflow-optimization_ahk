#Requires AutoHotkey v2.0

CopyPaste_Init(cfgPath) {
    hkCopy  := IniRead(cfgPath, "CopyPaste", "CopyHotkey", "XButton1")
    hkPaste := IniRead(cfgPath, "CopyPaste", "PasteHotkey", "XButton2")

    Hotkey hkCopy,  (*) => Send("^c")
    Hotkey hkPaste, (*) => Send("^v")
}
