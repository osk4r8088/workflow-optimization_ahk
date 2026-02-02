#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
SetWorkingDir A_ScriptDir

global CFG_PATH := A_ScriptDir "\config.ini"
A_IconTip := "workflow-optimization_ahk (MAIN)"

#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk

global g_Modules := Map(
    "autoclick",   false,
    "multitask",   false,
    "copypaste",   false,
    "stringpaste", false
)

global g_ModMenu := Menu()

InitAll()

InitAll() {
    global CFG_PATH

    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; init modules (register hotkeys OFF in each module)
    SafeCall0("AutoClick_Init", CFG_PATH)
    SafeCall0("MultiTask_Init", CFG_PATH)
    SafeCall0("CopyPaste_Init", CFG_PATH)
    SafeCall0("StringPaste_Init", CFG_PATH)

    ; apply enabled flags
    Module_SetEnabled("autoclick",   IniRead(CFG_PATH, "Modules", "autoclick", "0") = "1")
    Module_SetEnabled("multitask",   IniRead(CFG_PATH, "Modules", "multitask", "1") = "1")
    Module_SetEnabled("copypaste",   IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1")
    Module_SetEnabled("stringpaste", IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1")

    TraySetup()
}

; call fnName(param) if it exists; ignore errors
SafeCall0(fnName, param) {
    try Func(fnName).Call(param)
    catch
        return
}

; call fnName(bool) if it exists; ignore errors
SafeCall1(fnName, param) {
    try Func(fnName).Call(param)
    catch
        return
}

Module_SetEnabled(name, enable) {
    global g_Modules, CFG_PATH
    g_Modules[name] := !!enable

    switch name {
        case "autoclick":   SafeCall1("AutoClick_SetEnabled", enable)
        case "multitask":   SafeCall1("MultiTask_SetEnabled", enable)
        case "copypaste":   SafeCall1("CopyPaste_SetEnabled", enable)
        case "stringpaste": SafeCall1("StringPaste_SetEnabled", enable)
    }

    IniWrite(enable ? "1" : "0", CFG_PATH, "Modules", name)
    TraySetup()
}

TraySetup() {
    global g_Modules, CFG_PATH, g_ModMenu

    A_TrayMenu.Delete()

    ; debug proof (optional but useful)
    A_TrayMenu.Add("Debug: show script path", (*) => MsgBox(A_ScriptFullPath))

    ; rebuild submenu (keep global reference)
    g_ModMenu.Delete()
    g_ModMenu.Add("AutoClick",   (*) => Module_SetEnabled("autoclick",   !g_Modules["autoclick"]))
    g_ModMenu.Add("MultiTask",   (*) => Module_SetEnabled("multitask",   !g_Modules["multitask"]))
    g_ModMenu.Add("CopyPaste",   (*) => Module_SetEnabled("copypaste",   !g_Modules["copypaste"]))
    g_ModMenu.Add("StringPaste", (*) => Module_SetEnabled("stringpaste", !g_Modules["stringpaste"]))

    if (g_Modules["autoclick"])   g_ModMenu.Check("AutoClick")
    if (g_Modules["multitask"])   g_ModMenu.Check("MultiTask")
    if (g_Modules["copypaste"])   g_ModMenu.Check("CopyPaste")
    if (g_Modules["stringpaste"]) g_ModMenu.Check("StringPaste")

    A_TrayMenu.Add("Modules", g_ModMenu)
    A_TrayMenu.Add()

    A_TrayMenu.Add("Open config.ini", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}
