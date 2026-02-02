#Requires AutoHotkey v2.0

AutoClick_Init(cfgPath) {
    hk := IniRead(cfgPath, "AutoClick", "Hotkey", "XButton1")
    delay := Integer(IniRead(cfgPath, "AutoClick", "DelayMs", "30"))
    button := IniRead(cfgPath, "AutoClick", "Button", "Left")

    Hotkey hk, (*) => AutoClick_WhileHeld(hk, delay, button), "On"
}

AutoClick_WhileHeld(hk, delayMs, button) {
    while GetKeyState(hk, "P") {
        Click button
        Sleep delayMs
    }
}
