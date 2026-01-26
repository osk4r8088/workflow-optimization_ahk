; This script pastes a predefined string on keybind press, usefull if you need the same preset / whatever string again and again

#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
; =========================
; Simple custom text paste script
; =========================
; Examples for combinations
; HOTKEY := "NumpadSub"    ; Numpad -
; HOTKEY := "^!p"          ; Ctrl+Alt+P
; HOTKEY := "#+s"          ; Win+Shift+S


; -------- SETTINGS --------
TEXT_TO_PASTE := "paste"  		; <- change this to whatever you want to paste
HOTKEY        := "NumpadAdd"    	; <- change to custom key



Hotkey, %HOTKEY%, DoPaste, On
return
DoPaste:
    PasteText(TEXT_TO_PASTE)
return
PasteText(msg) {
    ClipSaved := ClipboardAll
    Clipboard := ""              ; clear to ensure ClipWait works
    Clipboard := msg
    ClipWait, 0.5
    Send ^v                      ; paste
    Sleep, 30
    Clipboard := ClipSaved       ; restore previous clipboard
    VarSetCapacity(ClipSaved, 0)
}







; -------- KEY NAME CHEAT SHEET (use in HOTKEY above) --------
; Modifiers (prefix):  ^ = Ctrl   ! = Alt   + = Shift   # = Win
; Combo examples: "^!p" (Ctrl+Alt+P), "#NumpadSub" (Win+Numpad-)

; Letters: a b c d e f g h i j k l m n o p q r s t u v w x y z
; Numbers (top row): 0 1 2 3 4 5 6 7 8 9
; Function: F1 F2 F3 ... F24
; Numpad: Numpad0 Numpad1 Numpad2 Numpad3 Numpad4 Numpad5 Numpad6 Numpad7 Numpad8 Numpad9
;         NumpadDot NumpadDiv NumpadMult NumpadAdd NumpadSub NumpadEnter
; Navigation: Up Down Left Right Home End PgUp PgDn
; Editing: Backspace Tab Enter Space Delete Insert
; Locks: CapsLock NumLock ScrollLock
; System: Escape PrintScreen Pause AppsKey Sleep
; Mouse (optional): LButton RButton MButton XButton1 XButton2
; Browser: Browser_Back Browser_Forward Browser_Refresh Browser_Stop Browser_Search Browser_Favorites Browser_Home
; Media/Volume: Volume_Mute Volume_Down Volume_Up Media_Next Media_Prev Media_Play_Pause Media_Stop

