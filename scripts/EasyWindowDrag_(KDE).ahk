; Einfache Fensterverschiebung -- KDE-Style (benötigt XP/2k/NT) -- von Jonny
; http://www.autohotkey.com
; Mit diesem Script ist es bedeutend einfacher, ein Fenster zu verschieben oder zu skalieren: 1) Haltet die
; ALT-Taste gedrückt und klickt mit der linken Maustaste irgendwo auf das Fenster,
; um es zur gewünschten Position zu verschieben; 2) Haltet die ALT-Taste gedrückt und
; klickt mit der rechten Maustaste irgendwo auf das Fenster, um dessen Größe einfach zu ändern;
; 3) Drückt die ALT-Taste zweimal, bevor jedoch der zweite Tastendruck losgelassen wird, klickt mit der linken Maustaste, um das Fenster
; unter dem Mauszeiger zu minimieren, klickt mit der rechten Maustaste, um es zu maximieren oder klickt mit der mittleren Maustaste, um es zu schließen.

; Dieses Script wurde inspiriert von und beruht auf
; das Forum, wie viele andere Scripts auch. Der Dank geht an ck, thinkstorm, Chris,
; und aurelian für eine gute Arbeit.

; Änderungen:
; 7. November 2006: Skalierungscode in !RButton optimiert, mit freundlicher Genehmigung von bluedawn.
; 5. Februar 2006: Fehler mit Doppel-Alt behoben (der ~Alt-Hotkey), damit das Script mit den aktuellsten Versionen von AHK funktioniert.

; Der Doppel-Alt-Modifikator wird beim zweimaligen Drücken von
; Alt aktiviert, ähnlich wie ein Doppelklick. Haltet die zweite Taste
; gedrückt, bis ein Klick erfolgt.
;
; Die Tastenkombinationen:
;  Alt + linke Maustaste  : Ziehen, um ein Fenster zu verschieben.
;  Alt + rechte Maustaste  : Ziehen, um die Größe eines Fensters zu ändern.
;  Doppel-Alt + linke Maustaste  : Ein Fenster minimieren.
;  Doppel-Alt + rechte Maustaste  : Ein Fenster maximieren/skalieren.
;  Doppel-Alt + mittlere Maustaste  : Ein Fenster schließen.
;
; Die Alt-Taste kann optional nach dem ersten Klick losgelassen werden,
; anstatt die Taste die ganze Zeit gedrückt zu halten.

If (A_AhkVersion < "1.0.39.00")
{
    MsgBox,20,,Dieses Script funktioniert möglicherweise nicht mit der aktuellen Version von AutoHotkey. Weiter?
    IfMsgBox,No
    ExitApp
}


; Die Einstellung, die auf meinem System
; flüssig läuft. Abhängig von der aktuellen Grafikkarte und CPU,
; kann dieser Wert erhöht oder verringert werden.
SetWinDelay,2

CoordMode,Mouse
return

!LButton::
If DoubleAlt
{
    MouseGetPos,,,KDE_id
    ; Diese Nachricht ist meist gleichbedeutend mit WinMinimize,
    ; verhindert jedoch einen Fehler mit PSPad.
    PostMessage,0x112,0xf020,,,ahk_id %KDE_id%
    DoubleAlt := false
    return
}
; Ermittelt die anfängliche Mausposition und Fenster-ID, und
; abbrechen, falls das Fenster maximiert ist.
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; Ermittelt die anfängliche Mausposition.
WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
Loop
{
    GetKeyState,KDE_Button,LButton,P ; Unterbrechen, falls die Taste losgelassen wurde.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Ermittelt die aktuelle Mausposition.
    KDE_X2 -= KDE_X1 ; Ermittelt den Offset von der anfänglichen Mausposition.
    KDE_Y2 -= KDE_Y1
    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Wendet diesen Offset auf die Fensterposition an.
    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Verschiebt das Fenster zur neuen Position.
}
return

!RButton::
If DoubleAlt
{
    MouseGetPos,,,KDE_id
    ; Zwischen maximierten und wiederhergestellten Zustand umschalten.
    WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
    If KDE_Win
        WinRestore,ahk_id %KDE_id%
    Else
        WinMaximize,ahk_id %KDE_id%
    DoubleAlt := false
    return
}
; Ermittelt die anfängliche Mausposition und Fenster-ID, und
; abbrechen, falls das Fenster maximiert ist.
MouseGetPos,KDE_X1,KDE_Y1,KDE_id
WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
If KDE_Win
    return
; Ermittelt die anfängliche Mausposition und Größe.
WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
; Definiert den Fensterbereich für die aktuelle Maus.
; Die vier Bereiche sind Up und Left, Up und Right, Down und Left, Down und Right.
If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
   KDE_WinLeft := 1
Else
   KDE_WinLeft := -1
If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
   KDE_WinUp := 1
Else
   KDE_WinUp := -1
Loop
{
    GetKeyState,KDE_Button,RButton,P ; Unterbrechen, falls die Taste losgelassen wurde.
    If KDE_Button = U
        break
    MouseGetPos,KDE_X2,KDE_Y2 ; Ermittelt die aktuelle Mausposition.
    ; Ermittelt die aktuelle Fensterposition und Größe.
    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
    KDE_X2 -= KDE_X1 ; Ermittelt den Offset von der anfänglichen Mausposition.
    KDE_Y2 -= KDE_Y1
    ; Danach in Bezug auf den definierten Bereich agieren.
    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X des skalierten Fensters
                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y des skalierten Fensters
                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W des skalierten Fensters
                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H des skalierten Fensters
    KDE_X1 := (KDE_X2 + KDE_X1) ; Die ursprüngliche Position für den nächsten Durchlauf wiederherstellen.
    KDE_Y1 := (KDE_Y2 + KDE_Y1)
}
return

; "Alt + MButton" ist möglicherweise einfacher, ich
; bevorzuge jedoch eine zusätzliche Absicherung
; mit einer Operation wie diese.
!MButton::
If DoubleAlt
{
    MouseGetPos,,,KDE_id
    WinClose,ahk_id %KDE_id%
    DoubleAlt := false
    return
}
return

; Dadurch werden "Doppelklicks" der Alt-Taste erkannt.
~Alt::
DoubleAlt := A_PriorHotKey = "~Alt" AND A_TimeSincePriorHotkey < 400
Sleep 0
KeyWait Alt  ; Dadurch wird die Störung der automatischen Wiederholfunktion der Tastatur unterdrückt.
return
