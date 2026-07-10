#Requires AutoHotkey v2.0

; Hotkey Settings GUI — rebind any module hotkey by pressing it (no INI editing,
; no key-name lookup). Opened from the tray: "Hotkey Settings".

global g_HkGui := 0

HotkeySettings_Slots() {
    global g_ModOrder, g_ModNames
    slots := [
        { sec: "CopyPaste",       key: "CopyHotkey",  label: "CopyPaste: copy",                 def: "XButton1" },
        { sec: "CopyPaste",       key: "PasteHotkey", label: "CopyPaste: paste",                def: "XButton2" },
        { sec: "MultiTask",       key: "PlainPaste",  label: "MultiTask: plain paste",          def: "^+v" },
        { sec: "MultiTask",       key: "DateTime",    label: "MultiTask: type date/time",       def: "NumpadMult" },
        { sec: "MultiTask",       key: "FileStamp",   label: "MultiTask: type file timestamp",  def: "NumpadSub" },
        { sec: "MultiTask",       key: "Edge",        label: "MultiTask: launch Edge",          def: "Numpad7" },
        { sec: "MultiTask",       key: "NotepadPP",   label: "MultiTask: launch Notepad++",     def: "Numpad8" },
        { sec: "MultiTask",       key: "Teams",       label: "MultiTask: launch Teams",         def: "Numpad9" },
        { sec: "MultiTask",       key: "Outlook",     label: "MultiTask: launch Outlook",       def: "NumpadAdd" },
        { sec: "StringPaste",     key: "Hotkey",      label: "StringPaste: paste text",         def: "^!p" },
        { sec: "MediaKeys",       key: "PlayPause",   label: "MediaKeys: play/pause",           def: "Numpad0" },
        { sec: "MediaKeys",       key: "Next",        label: "MediaKeys: next track",           def: "Numpad6" },
        { sec: "MediaKeys",       key: "Prev",        label: "MediaKeys: previous track",       def: "Numpad4" },
        { sec: "MediaKeys",       key: "VolUp",       label: "MediaKeys: volume up",            def: "Numpad2" },
        { sec: "MediaKeys",       key: "VolDown",     label: "MediaKeys: volume down",          def: "Numpad5" },
        { sec: "MediaKeys",       key: "Mute",        label: "MediaKeys: mute",                 def: "Numpad1" },
        { sec: "ClipHistory",     key: "Hotkey",      label: "ClipHistory: open history menu",  def: "^!h" },
        { sec: "WindowTools",     key: "AlwaysOnTop", label: "WindowTools: always on top",      def: "^!t" },
        { sec: "WindowTools",     key: "NextMonitor", label: "WindowTools: next monitor",       def: "^!m" },
        { sec: "WindowTools",     key: "Center",      label: "WindowTools: center window",      def: "^!c" },
        { sec: "QuickNote",       key: "Hotkey",      label: "QuickNote: capture note",         def: "^!n" },
        { sec: "QuickNote",       key: "OpenHotkey",  label: "QuickNote: open notes file",      def: "" },
        { sec: "SearchSelection", key: "Hotkey",      label: "SearchSelection: search",         def: "^!s" }
    ]
    ; per-module on/off toggle hotkeys (always active, unbound by default)
    for name in g_ModOrder
        slots.Push({ sec: "ToggleHotkeys", key: name, label: "Toggle module: " g_ModNames[name], def: "" })
    return slots
}

HotkeySettings_Show(*) {
    global g_HkGui, CFG_PATH
    if IsObject(g_HkGui) {
        try g_HkGui.Destroy()
        g_HkGui := 0
    }
    slots := HotkeySettings_Slots()

    g := Gui(, "MACROHUB-OS — Hotkey Settings")
    g.OnEvent("Close", (*) => g.Destroy())
    lv := g.AddListView("w560 r20 -Multi NoSortHdr", ["Function", "Binding"])
    for s in slots
        lv.Add(, s.label, IniRead(CFG_PATH, s.sec, s.key, s.def))
    lv.ModifyCol(1, 370)
    lv.ModifyCol(2, 150)

    g.AddText("xm y+10", "1. Select a row   2. Press the new combo here:")
    hkCtl := g.AddHotkey("x+8 yp-3 w140")
    g.AddText("xm y+8", "...or type it manually (needed for Win/mouse keys, e.g. #c, XButton1, WheelUp):")
    edCtl := g.AddEdit("x+8 yp-3 w140")

    g.AddButton("xm y+12 w150", "Apply to selected").OnEvent("Click", ApplyBtn)
    g.AddButton("x+8 w120", "Clear binding").OnEvent("Click", ClearBtn)
    g.AddButton("x+46 w150", "Save && Reload").OnEvent("Click", SaveBtn)
    g.Show()
    g_HkGui := g

    ApplyBtn(*) {
        row := lv.GetNext(0)
        if !row {
            MsgBox "Select a row first.", "Hotkey Settings", "Icon!"
            return
        }
        newVal := Trim(edCtl.Value != "" ? edCtl.Value : hkCtl.Value)
        if (newVal = "") {
            MsgBox "Press a key combo (or type one) first.", "Hotkey Settings", "Icon!"
            return
        }
        ; syntax check on a pass-through (~) probe so live bindings are never touched
        try
            Hotkey "~" LTrim(newVal, "~"), HotkeySettings_Nop, "Off"
        catch {
            MsgBox "'" newVal "' is not a valid hotkey.", "Hotkey Settings", "Icon!"
            return
        }
        ; duplicate check against the other rows
        Loop lv.GetCount() {
            if (A_Index != row && lv.GetText(A_Index, 2) = newVal) {
                if (MsgBox("'" newVal "' is already used by:`n" lv.GetText(A_Index, 1) "`n`nAssign anyway?", "Hotkey Settings", "YesNo Icon!") = "No")
                    return
                break
            }
        }
        lv.Modify(row, "Col2", newVal)
        hkCtl.Value := ""
        edCtl.Value := ""
    }

    ClearBtn(*) {
        row := lv.GetNext(0)
        if !row {
            MsgBox "Select a row first.", "Hotkey Settings", "Icon!"
            return
        }
        lv.Modify(row, "Col2", "")
    }

    SaveBtn(*) {
        Loop lv.GetCount()
            IniWrite lv.GetText(A_Index, 2), CFG_PATH, slots[A_Index].sec, slots[A_Index].key
        if (MsgBox("Saved to config.ini.`nReload now to apply the new bindings?", "Hotkey Settings", "YesNo Iconi") = "Yes")
            Reload
        else
            g.Destroy()
    }
}

HotkeySettings_Nop(*) {
}
