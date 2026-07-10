#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir

#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk
#Include %A_ScriptDir%\modules\textexpander\module.ahk
#Include %A_ScriptDir%\modules\mediakeys\module.ahk
#Include %A_ScriptDir%\modules\autoreplace\module.ahk
#Include %A_ScriptDir%\modules\cliphistory\module.ahk
#Include %A_ScriptDir%\modules\windowtools\module.ahk
#Include %A_ScriptDir%\modules\quicknote\module.ahk
#Include %A_ScriptDir%\modules\searchselection\module.ahk
#Include %A_ScriptDir%\settings.ahk

global CFG_PATH := A_ScriptDir "\config.ini"
A_IconTip := "MACROHUB-OS"

global g_Modules := Map(
    "autoclick",   false,
    "multitask",   false,
    "copypaste",   false,
    "stringpaste",  false,
    "textexpander", false,
    "mediakeys",    false,
    "autoreplace",  false,
    "cliphistory",  false,
    "windowtools",  false,
    "quicknote",    false,
    "searchselection", false
)

; module display names mapped to internal names
global g_ModNames := Map(
    "autoclick",   "AutoClick",
    "multitask",   "MultiTask",
    "copypaste",   "CopyPaste",
    "stringpaste",  "StringPaste",
    "textexpander", "TextExpander",
    "mediakeys",    "MediaKeys",
    "autoreplace",  "AutoReplace",
    "cliphistory",  "ClipHistory",
    "windowtools",  "WindowTools",
    "quicknote",    "QuickNote",
    "searchselection", "SearchSelection"
)

global g_ModMenu := Menu()

; canonical module order (menus, settings GUI, toggle-hotkey registration)
global g_ModOrder := ["autoclick", "multitask", "copypaste", "stringpaste", "textexpander",
    "mediakeys", "autoreplace", "cliphistory", "windowtools", "quicknote", "searchselection"]

; hotkey/abbreviation → list of modules that registered it (conflict detection)
global g_HotkeyOwners := Map()

InitAll()

InitAll() {
    global CFG_PATH, g_Modules, g_ModOrder

    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; init modules (hotkeys registered OFF)
    AutoClick_Init(CFG_PATH)
    CopyPaste_Init(CFG_PATH)
    MultiTask_Init(CFG_PATH)
    StringPaste_Init(CFG_PATH)
    TextExpander_Init(CFG_PATH)
    MediaKeys_Init(CFG_PATH)
    AutoReplace_Init(CFG_PATH)
    ClipHistory_Init(CFG_PATH)
    WindowTools_Init(CFG_PATH)
    QuickNote_Init(CFG_PATH)
    SearchSelection_Init(CFG_PATH)

    ; read enabled flags from config and apply
    g_Modules["autoclick"]   := IniRead(CFG_PATH, "Modules", "autoclick", "0") = "1"
    g_Modules["multitask"]   := IniRead(CFG_PATH, "Modules", "multitask", "1") = "1"
    g_Modules["copypaste"]   := IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1"
    g_Modules["stringpaste"]  := IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1"
    g_Modules["textexpander"] := IniRead(CFG_PATH, "Modules", "textexpander", "0") = "1"
    g_Modules["mediakeys"]    := IniRead(CFG_PATH, "Modules", "mediakeys", "0") = "1"
    g_Modules["autoreplace"]  := IniRead(CFG_PATH, "Modules", "autoreplace", "0") = "1"
    g_Modules["cliphistory"]  := IniRead(CFG_PATH, "Modules", "cliphistory", "1") = "1"
    g_Modules["windowtools"]  := IniRead(CFG_PATH, "Modules", "windowtools", "1") = "1"
    g_Modules["quicknote"]    := IniRead(CFG_PATH, "Modules", "quicknote", "1") = "1"
    g_Modules["searchselection"] := IniRead(CFG_PATH, "Modules", "searchselection", "1") = "1"

    ; apply enabled states
    AutoClick_SetEnabled(g_Modules["autoclick"])
    CopyPaste_SetEnabled(g_Modules["copypaste"])
    MultiTask_SetEnabled(g_Modules["multitask"])
    StringPaste_SetEnabled(g_Modules["stringpaste"])
    TextExpander_SetEnabled(g_Modules["textexpander"])
    MediaKeys_SetEnabled(g_Modules["mediakeys"])
    AutoReplace_SetEnabled(g_Modules["autoreplace"])
    ClipHistory_SetEnabled(g_Modules["cliphistory"])
    WindowTools_SetEnabled(g_Modules["windowtools"])
    QuickNote_SetEnabled(g_Modules["quicknote"])
    SearchSelection_SetEnabled(g_Modules["searchselection"])

    ; always-active per-module toggle hotkeys ([ToggleHotkeys] modulename=hotkey)
    for name in g_ModOrder {
        thk := Trim(IniRead(CFG_PATH, "ToggleHotkeys", name, ""))
        if (thk = "")
            continue
        try {
            Hotkey thk, ToggleModuleHotkey.Bind(name), "On"
            HK_Track("ModuleToggles", thk)
        } catch {
            TrayTip "Toggle hotkey failed: " thk " (" name ")"
        }
    }

    TrayBuild()
    HK_WarnConflicts()
}

; called by modules during Init for every hotkey/abbreviation they register
HK_Track(modName, hk) {
    global g_HotkeyOwners
    key := StrLower(Trim(hk))
    if (key = "")
        return
    if !g_HotkeyOwners.Has(key)
        g_HotkeyOwners[key] := []
    g_HotkeyOwners[key].Push(modName)
}

; warn if two or more ENABLED modules registered the same hotkey/abbreviation
HK_WarnConflicts() {
    global g_HotkeyOwners, g_Modules, g_ModNames
    msg := ""
    for key, owners in g_HotkeyOwners {
        active := []
        for modName in owners {
            ; owners that aren't modules (e.g. "ModuleToggles") are always active
            if !g_Modules.Has(modName)
                active.Push(modName)
            else if g_Modules[modName]
                active.Push(g_ModNames[modName])
        }
        if (active.Length > 1) {
            names := ""
            for label in active
                names .= (names = "" ? "" : ", ") label
            msg .= key "  ->  " names "`n"
        }
    }
    if (msg != "")
        MsgBox "Hotkey conflicts between enabled modules:`n`n" msg "`nThe module loaded last wins. Remap or disable one in config.ini.", "MACROHUB-OS - hotkey conflicts", "Icon!"
}

; notify=false keeps it silent (used for tray-menu clicks where the checkmark
; is feedback enough); hotkey toggles and other callers get a TrayTip
Module_SetEnabled(name, enable, notify := true) {
    global g_Modules, g_ModMenu, g_ModNames, CFG_PATH
    g_Modules[name] := !!enable

    switch name {
        case "autoclick":   AutoClick_SetEnabled(enable)
        case "copypaste":   CopyPaste_SetEnabled(enable)
        case "multitask":   MultiTask_SetEnabled(enable)
        case "stringpaste":  StringPaste_SetEnabled(enable)
        case "textexpander": TextExpander_SetEnabled(enable)
        case "mediakeys":    MediaKeys_SetEnabled(enable)
        case "autoreplace":  AutoReplace_SetEnabled(enable)
        case "cliphistory":  ClipHistory_SetEnabled(enable)
        case "windowtools":  WindowTools_SetEnabled(enable)
        case "quicknote":    QuickNote_SetEnabled(enable)
        case "searchselection": SearchSelection_SetEnabled(enable)
    }

    IniWrite(enable ? "1" : "0", CFG_PATH, "Modules", name)

    ; update checkmark
    label := g_ModNames[name]
    if enable
        g_ModMenu.Check(label)
    else
        g_ModMenu.Uncheck(label)

    if notify {
        state := enable ? "ON" : "OFF"
        TrayTip label " " state, "MACROHUB-OS", 1
    }

    ; enabling a module may introduce a conflict with an already-enabled one
    if enable
        HK_WarnConflicts()
}

; toggle from the tray menu: silent (checkmark is the feedback) and the
; submenu reopens so several modules can be toggled in a row
TrayToggleModule(name) {
    global g_Modules, g_ModMenu
    Module_SetEnabled(name, !g_Modules[name], false)
    g_ModMenu.Show()
}

; toggle via a [ToggleHotkeys] hotkey: with no menu on screen, the TrayTip
; is the only feedback, so keep it
ToggleModuleHotkey(name, *) {
    global g_Modules
    Module_SetEnabled(name, !g_Modules[name], true)
}

; build tray menu once
TrayBuild() {
    global g_Modules, g_ModMenu, CFG_PATH

    ; build modules submenu (silent toggles, menu reopens after each click)
    g_ModMenu.Add("AutoClick",   (*) => TrayToggleModule("autoclick"))
    g_ModMenu.Add("MultiTask",   (*) => TrayToggleModule("multitask"))
    g_ModMenu.Add("CopyPaste",   (*) => TrayToggleModule("copypaste"))
    g_ModMenu.Add("StringPaste",  (*) => TrayToggleModule("stringpaste"))
    g_ModMenu.Add("TextExpander", (*) => TrayToggleModule("textexpander"))
    g_ModMenu.Add("MediaKeys",    (*) => TrayToggleModule("mediakeys"))
    g_ModMenu.Add("AutoReplace",  (*) => TrayToggleModule("autoreplace"))
    g_ModMenu.Add("ClipHistory",  (*) => TrayToggleModule("cliphistory"))
    g_ModMenu.Add("WindowTools",  (*) => TrayToggleModule("windowtools"))
    g_ModMenu.Add("QuickNote",    (*) => TrayToggleModule("quicknote"))
    g_ModMenu.Add("SearchSelection", (*) => TrayToggleModule("searchselection"))

    ; set initial checkmarks
    if g_Modules["autoclick"]
        g_ModMenu.Check("AutoClick")
    if g_Modules["multitask"]
        g_ModMenu.Check("MultiTask")
    if g_Modules["copypaste"]
        g_ModMenu.Check("CopyPaste")
    if g_Modules["stringpaste"]
        g_ModMenu.Check("StringPaste")
    if g_Modules["textexpander"]
        g_ModMenu.Check("TextExpander")
    if g_Modules["mediakeys"]
        g_ModMenu.Check("MediaKeys")
    if g_Modules["autoreplace"]
        g_ModMenu.Check("AutoReplace")
    if g_Modules["cliphistory"]
        g_ModMenu.Check("ClipHistory")
    if g_Modules["windowtools"]
        g_ModMenu.Check("WindowTools")
    if g_Modules["quicknote"]
        g_ModMenu.Check("QuickNote")
    if g_Modules["searchselection"]
        g_ModMenu.Check("SearchSelection")

    ; build tray: strip AHK's standard items once, then rebuild fully custom.
    ; one-time Delete() at startup is fine; only per-toggle rebuilds crashed the
    ; Store edition (see README) — guarded anyway so the menu stays usable.
    try A_TrayMenu.Delete()

    A_TrayMenu.Add("Open", TrayOpen)
    A_TrayMenu.Add("Modules", g_ModMenu)
    A_TrayMenu.Add("Window Spy", TrayWindowSpy)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Open Config", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add("Hotkey Settings", HotkeySettings_Show)
    A_TrayMenu.Add("Pause Script", TrayPause)
    A_TrayMenu.Add("Suspend Hotkeys", TraySuspend)
    A_TrayMenu.Add("Reload Script", (*) => Reload())
    A_TrayMenu.Add("Reload Modules", TrayReloadModules)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Help", (*) => Run("https://www.autohotkey.com/docs/v2/"))
    A_TrayMenu.Add("Exit", (*) => ExitApp())
    A_TrayMenu.Default := "Open"
}

; shows the script's main window (same as AHK's built-in Open)
TrayOpen(*) {
    ListVars
}

; launches WindowSpy.ahk from the AutoHotkey install (inspects windows under
; the mouse: title, ahk_class, ahk_exe, control names — needed for per-app rules)
TrayWindowSpy(*) {
    SplitPath A_AhkPath, , &dir
    for cand in [dir "\WindowSpy.ahk", dir "\..\WindowSpy.ahk", dir "\UX\WindowSpy.ahk"] {
        if FileExist(cand) {
            try Run '"' A_AhkPath '" "' cand '"'
            return
        }
    }
    TrayTip "WindowSpy.ahk not found next to " A_AhkPath, "MACROHUB-OS", 1
}

TrayPause(*) {
    willPause := !A_IsPaused
    Pause -1
    if willPause
        A_TrayMenu.Check("Pause Script")
    else
        A_TrayMenu.Uncheck("Pause Script")
}

TraySuspend(*) {
    Suspend -1
    if A_IsSuspended
        A_TrayMenu.Check("Suspend Hotkeys")
    else
        A_TrayMenu.Uncheck("Suspend Hotkeys")
}

; re-reads the [Modules] on/off flags from config.ini and applies them live.
; (changed hotkeys/word lists still need Reload Script — they bind at startup)
TrayReloadModules(*) {
    global CFG_PATH, g_Modules
    changed := 0
    for name, cur in g_Modules.Clone() {
        want := IniRead(CFG_PATH, "Modules", name, cur ? "1" : "0") = "1"
        if (want != cur) {
            Module_SetEnabled(name, want, false)
            changed++
        }
    }
    if (changed = 0)
        TrayTip "Module states match config.ini", "MACROHUB-OS", 1
    else
        TrayTip changed " module state(s) applied from config.ini", "MACROHUB-OS", 1
}
