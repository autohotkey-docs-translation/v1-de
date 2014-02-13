; Window Shading (ein Fenster bis zur Titelleiste zusammenrollen) -- von Rajat
; http://www.autohotkey.com
; Dieses Script verkleinert ein Fenster auf dessen Titelleiste und beim Drücken
; eines Hotkeys wieder auf seine ursprüngliche Größe.  Eine beliebige Anzahl an Fenstern
; kann auf diese Weise verkleinert werden (das Script merkt sich diese).  Wenn das
; Script aus irgendeinem Grund beendet wird, dann werden die originalen Höhen aller
; "zusammengerollten" Fenstern automatisch wiederhergestellt.

; Höhe eines zusammengerollten Fensters hier angeben.  Durch das Betriebssystem
; kann die Titelleiste wahrscheinlich gar nicht versteckt werden,
; unabhängig davon, wie klein die Zahl ist:
ws_MinHeight = 25

; Diese Zeile wird alle Fenster wieder aufrollen, falls das Script
; aus irgendeinem Grund beendet wird:
OnExit, ExitSub
Return  ; Ende des automatischen Ausführungsbereichs.

#z::  ; Ändert diese Zeile, um einen anderen Hotkey zu verwenden.
; Danach sollten keine Änderungen durchgeführt werden, es sei denn,
; die allgemeine Funktionalität des Scripts soll geändert werden.
; Hebt die Kommentierung der nächsten Zeile auf, falls diese Subroutine
; in einen benutzerdefinierten Menüpunkt anstelle eines Hotkeys verwandelt wird.  Die Verzögerung erlaubt es,
; das aktive Fenster, welches vom angezeigten Menü deaktiviert wurde,
; wieder aktiv zu machen:
;Sleep, 200
WinGet, ws_ID, ID, A
Loop, Parse, ws_IDList, |
{
	IfEqual, A_LoopField, %ws_ID%
	{
		; Übereinstimmung gefunden, daher sollte das Fenster wiederhergestellt werden (aufrollen):
		StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
		WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
		StringReplace, ws_IDList, ws_IDList, |%ws_ID%
		Return
	}
}
WinGetPos,,,, ws_Height, A
ws_Window%ws_ID% = %ws_Height%
WinMove, ahk_id %ws_ID%,,,,, %ws_MinHeight%
ws_IDList = %ws_IDList%|%ws_ID%
Return

ExitSub:
Loop, Parse, ws_IDList, |
{
	if A_LoopField =  ; Das erste Feld in der Liste ist normalerweise leer.
		continue      ; Also überspringen.
	StringTrimRight, ws_Height, ws_Window%A_LoopField%, 0
	WinMove, ahk_id %A_LoopField%,,,,, %ws_Height%
}
ExitApp  ; Muss für die OnExit-Subroutine durchgeführt werden, um das Script tatsächlich zu beenden.
