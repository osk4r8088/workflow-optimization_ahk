#Requires AutoHotkey v2.0

global g_AutoClick := { delay: 30, button: "Left" }

AutoClick_Init(cfgPath) {
    global g_AutoClick
    g_AutoClick.delay := Integer(IniRead(cfgPath, "AutoClick", "DelayMs", "30"))
    g_AutoClick.button := IniRead(cfgPath, "AutoClick", "Button", "Left")
    Hotkey "^LButton", AutoClick_Handler, "Off"
}

AutoClick_SetEnabled(enable) {
    Hotkey "^LButton", enable ? "On" : "Off"
}

AutoClick_Handler(*) {
    global g_AutoClick
    while GetKeyState("Ctrl", "P") && GetKeyState("LButton", "P") {
        Click g_AutoClick.button
        Sleep g_AutoClick.delay
    }
}
