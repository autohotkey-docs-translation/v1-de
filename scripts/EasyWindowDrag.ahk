; Einfache Fensterverschiebung (benötigt XP/2k/NT)
; http://www.autohotkey.com
; Normalerweise kann ein Fenster nur verschoben werden, wenn die Titelleiste angeklickt wird.
; Dieses Script erweitert diese Funktion, sodass jeder Punkt in einem Fenster angeklickt werden kann.
; Um diesen Modus zu aktivieren, haltet die Feststelltaste oder die mittlere Maustaste beim
; Klicken gedrückt und verschiebt das Fenster danach zur gewünschten Position.

; Hinweis: Die Feststelltaste oder mittlere Maustaste kann optional losgelassen werden, nachdem
; die Maustaste gedrückt wurde, anstatt die Taste die ganze Zeit gedrückt zu halten.
; Dieses Script benötigt v1.0.25+.

~MButton & LButton::
CapsLock & LButton::
CoordMode, Mouse  ; Auf Bildschirm-/absolute Koordinaten wechseln.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
if EWD_WinState = 0  ; Nur, wenn das Fenster nicht maximiert ist.
    SetTimer, EWD_WatchMouse, 10 ; Die Maus verfolgen, wenn sie vom Benutzer gezogen wird.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Taste wurde losgelassen, daher ist das Ziehen abgeschlossen.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape wurde gedrückt, daher wird das Ziehen abgebrochen.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Ansonsten das Fenster neu positionieren, damit es den Mauskoordinaten entspricht,
; bedingt durch das Ziehen der Maus:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Fenster wird schneller/flüssiger verschoben.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Für den nächsten Timer-Aufruf auf diese Subroutine aktualisieren.
EWD_MouseStartY := EWD_MouseY
return
