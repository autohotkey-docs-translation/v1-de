; ToolTip-Mausmenü (benötigt XP/2k/NT) -- von Rajat
; http://www.autohotkey.com
; Dieses Script zeigt ein aufklappbares Menü beim kurzen
; Drücken der mittleren Maustaste an.  Ein Menüpunkt kann mit einem Linksklick ausgewählt werden.
; Das Menü wird geschlossen, sobald außerhalb des Menüs mit der linken Maustaste geklickt wird.  Als aktuelle Verbesserung
; kann der Inhalt des Menüs geändert werden, abhängig davon,
; welcher Fenstertyp aktiv ist (Notepad und Word wurden hier als Beispiele verwendet).

; Hier kann ein beliebiger Titel für das Menü angegeben werden:
MenuTitle = -=-=-=-=-=-=-=-

; Damit wird die Druckdauer der Maustaste bestimmt, bis das Menü angezeigt wird:
UMDelay = 20

SetFormat, float, 00
SetBatchLines, 10ms 
SetTitleMatchMode, 2
#SingleInstance


;___________________________________________
;_____Menü-Definitionen______________________

; Hier können die Menüpunkte erstellt oder bearbeitet werden.
; Es dürfen keine Leerzeichen im Schlüssel-/Wert-/Bereichssnamen verwendet werden.

; Mach dir keine Sorgen über die Reihenfolge, das Menü wird sortiert.

MenuItems = Editor/Rechner/Bereich 3/Bereich 4/Bereich 5


;___________________________________________
;______Hier dynamische Menüpunkte_______________

; Syntax:
;     Dyn# = Menüpunkt|Fenstertitel

Dyn1 = MS Word|- Microsoft Word
Dyn2 = Editor II|- Editor

;___________________________________________

Exit


;___________________________________________
;_____Menübereiche__________________________

; Hier können die Menübereiche erstellt oder bearbeitet werden.

Editor:
Run, Notepad.exe
Return

Rechner:
Run, Calc
Return

Bereich3:
MsgBox, 3 ausgewählt
Return

Bereich4:
MsgBox, 4 ausgewählt
Return

Bereich5:
MsgBox, 5 ausgewählt
Return

MSWord:
msgbox, Das ist ein dynamischer Eintrag (Word)
Return

EditorII:
msgbox, Das ist ein dynamischer Eintrag (Editor)
Return


;___________________________________________
;_____Hotkey-Bereich________________________

~MButton::
HowLong = 0
Loop
{
	HowLong ++
	Sleep, 10
	GetKeyState, MButton, MButton, P
	IfEqual, MButton, U, Break
}
IfLess, HowLong, %UMDelay%, Return


; Dynamisches Menü vorbereiten
DynMenu =
Loop
{
	IfEqual, Dyn%a_index%,, Break

	StringGetPos, ppos, dyn%a_index%, |
	StringLeft, item, dyn%a_index%, %ppos%
	ppos += 2
	StringMid, win, dyn%a_index%, %ppos%, 1000

	IfWinActive, %win%,
		DynMenu = %DynMenu%/%item%
}


; Sortiertes Hauptmenü mit dynamisches Menü verbinden
Sort, MenuItems, D/
TempMenu = %MenuItems%%DynMenu%


; Frühere Einträge entfernen
Loop
{
	IfEqual, MenuItem%a_index%,, Break
	MenuItem%a_index% =
}

; Neue Einträge erstellen
Loop, Parse, TempMenu, /
{
	MenuItem%a_index% = %a_loopfield%
}

; Das Menü erstellen
Menu = %MenuTitle%
Loop
{
	IfEqual, MenuItem%a_index%,, Break
	numItems ++
	StringTrimLeft, MenuText, MenuItem%a_index%, 0
	Menu = %Menu%`n%MenuText%
}

MouseGetPos, mX, mY
HotKey, ~LButton, MenuClick
HotKey, ~LButton, On
ToolTip, %Menu%, %mX%, %mY%
WinActivate, %MenuTitle%
Return


MenuClick:
HotKey, ~LButton, Off
IfWinNotActive, %MenuTitle%
{
	ToolTip
	Return
}

MouseGetPos, mX, mY
ToolTip
mY -= 3		; Platz, bevor die erste Zeile startet
mY /= 13	; Benötigter Platz jeder Zeile
IfLess, mY, 1, Return
IfGreater, mY, %numItems%, Return
StringTrimLeft, TargetSection, MenuItem%mY%, 0
StringReplace, TargetSection, TargetSection, %a_space%,, A
Gosub, %TargetSection%
Return
