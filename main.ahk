#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir

#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk

global CFG_PATH := A_ScriptDir "\config.ini"
A_IconTip := "workflow-optimization_ahk"

global g_Modules := Map(
    "autoclick",   false,
    "multitask",   false,
    "copypaste",   false,
    "stringpaste", false
)

InitAll()

InitAll() {
    global CFG_PATH, g_Modules

    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; init modules (hotkeys registered OFF)
    AutoClick_Init(CFG_PATH)
    CopyPaste_Init(CFG_PATH)
    MultiTask_Init(CFG_PATH)
    StringPaste_Init(CFG_PATH)

    ; read enabled flags from config and apply
    g_Modules["autoclick"]   := IniRead(CFG_PATH, "Modules", "autoclick", "0") = "1"
    g_Modules["multitask"]   := IniRead(CFG_PATH, "Modules", "multitask", "1") = "1"
    g_Modules["copypaste"]   := IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1"
    g_Modules["stringpaste"] := IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1"

    ; apply enabled states
    AutoClick_SetEnabled(g_Modules["autoclick"])
    CopyPaste_SetEnabled(g_Modules["copypaste"])
    MultiTask_SetEnabled(g_Modules["multitask"])
    StringPaste_SetEnabled(g_Modules["stringpaste"])

    TraySetup()
}

Module_SetEnabled(name, enable) {
    global g_Modules, CFG_PATH
    g_Modules[name] := !!enable

    switch name {
        case "autoclick": AutoClick_SetEnabled(enable)
        case "copypaste": CopyPaste_SetEnabled(enable)
        case "multitask": MultiTask_SetEnabled(enable)
        case "stringpaste": StringPaste_SetEnabled(enable)
    }

    IniWrite(enable ? "1" : "0", CFG_PATH, "Modules", name)
    TraySetup()
}

TraySetup() {
    global g_Modules, CFG_PATH

    ; build modules submenu (new object each time to avoid Delete() crash)
    modMenu := Menu()
    modMenu.Add("AutoClick",   (*) => Module_SetEnabled("autoclick",   !g_Modules["autoclick"]))
    modMenu.Add("MultiTask",   (*) => Module_SetEnabled("multitask",   !g_Modules["multitask"]))
    modMenu.Add("CopyPaste",   (*) => Module_SetEnabled("copypaste",   !g_Modules["copypaste"]))
    modMenu.Add("StringPaste", (*) => Module_SetEnabled("stringpaste", !g_Modules["stringpaste"]))

    if g_Modules["autoclick"]
        modMenu.Check("AutoClick")
    if g_Modules["multitask"]
        modMenu.Check("MultiTask")
    if g_Modules["copypaste"]
        modMenu.Check("CopyPaste")
    if g_Modules["stringpaste"]
        modMenu.Check("StringPaste")

    ; rebuild tray (add items; duplicates update in place in AHK v2)
    A_TrayMenu.Add("Modules", modMenu)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Open config.ini", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}
