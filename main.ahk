#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

global CONFIG := A_ScriptDir "\config.ini"
global MODDIR := A_ScriptDir "\modules"

; -----------------------------
; Load modules
; -----------------------------

#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk

; -----------------------------
; Init
; -----------------------------

InitModules()

InitModules() {

    cfg := CONFIG

    try Multitask_Init(cfg)
    try AutoClick_Init(cfg)
    try CopyPaste_Init(cfg)
    try StringPaste_Init(cfg)

    TraySetup()
}

TraySetup() {

    A_TrayMenu.Delete()

    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())

}
