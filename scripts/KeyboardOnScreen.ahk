; Bildschirmtastatur (benötigt XP/2k/NT) -- von Jon
; http://www.autohotkey.com
; Dieses Script erstellt eine nachgebildete Tastatur am unteren Rand des Bildschirms,
; das die gedrückten Tasten in Echtzeit anzeigt. Das hat mir geholfen, Eingaben zu machen,
; ohne dabei auf die Tastatur zu schauen.  Die Größe der Bildschirmtastatur
; kann im oberen Bereich des Scripts angepasst werden. Außerdem kann
; die Tastatur angezeigt oder versteckt werden, wenn das Tray-Icon doppelt angeklickt wird.

;---- Konfigurationsbereich: Die Größe der Bildschirmtastatur und
; andere Optionen anpassen.

; Beim Verändern der Schriftgröße wird die gesamte Bildschirmtastatur
; größer oder kleiner:
k_FontSize = 10
k_FontName = Verdana  ; Kann leer sein, um die Standardschriftart des Systems zu verwenden.
k_FontStyle = Bold    ; Alternatives Beispiel: Italic Underline

; Namen der Tray-Menüpunkte:
k_MenuItemHide = &Bildschirmtastatur verstecken
k_MenuItemShow = &Bildschirmtastatur anzeigen

; Damit die Tastatur nicht nur auf den primären Monitor angezeigt wird, verwendet
; eine Zahl wie 2 für die folgende Variable.  Lasst sie leer, um den
; primären Monitor zu verwenden:
k_Monitor = 

;---- Ende des Konfigurationsbereichs.  Hier danach keine Änderungen durchführen,
; es sei denn, die allgemeine Funktionalität des Scripts soll geändert werden.


;---- Tray-Icon-Menü ändern:
Menu, Tray, Add, %k_MenuItemHide%, k_ShowHide
Menu, Tray, Add, &Exit, k_MenuExit
Menu, Tray, Default, %k_MenuItemHide%
Menu, Tray, NoStandard

;---- Abmessungen der Objekte berechnen, basierend auf der ausgewählten Schriftgröße:
k_KeyWidth = %k_FontSize%
k_KeyWidth *= 3
k_KeyHeight = %k_FontSize%
k_KeyHeight *= 3
k_KeyMargin = %k_FontSize%
k_KeyMargin /= 6
k_SpacebarWidth = %k_FontSize%
k_SpacebarWidth *= 25
k_KeyWidthHalf = %k_KeyWidth%
k_KeyWidthHalf /= 2

k_KeySize = w%k_KeyWidth% h%k_KeyHeight%
k_Position = x+%k_KeyMargin% %k_KeySize%

;---- Ein GUI-Fenster für die Bildschirmtastatur erstellen:
Gui, Font, s%k_FontSize% %k_FontStyle%, %k_FontName%
Gui, -Caption +E0x200 +ToolWindow
TransColor = F1ECED
Gui, Color, %TransColor%  ; Diese Farbe wird später transparent gemacht.

;---- Für jede Taste eine Schaltfläche hinzufügen. Die erste Schaltfläche wird mit absoluten
; Koordinaten positioniert, sodass alle anderen Schaltflächen sich darauf beziehen:
Gui, Add, Button, section %k_KeySize% xm+%k_KeyWidth%, 1
Gui, Add, Button, %k_Position%, 2
Gui, Add, Button, %k_Position%, 3
Gui, Add, Button, %k_Position%, 4
Gui, Add, Button, %k_Position%, 5
Gui, Add, Button, %k_Position%, 6
Gui, Add, Button, %k_Position%, 7
Gui, Add, Button, %k_Position%, 8
Gui, Add, Button, %k_Position%, 9
Gui, Add, Button, %k_Position%, 0
Gui, Add, Button, %k_Position%, -
Gui, Add, Button, %k_Position%, =
Gui, Add, Button, %k_Position%, Bk

Gui, Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight%, Tab  ; Automatische Breite.
Gui, Add, Button, %k_Position%, Q
Gui, Add, Button, %k_Position%, W
Gui, Add, Button, %k_Position%, E
Gui, Add, Button, %k_Position%, R
Gui, Add, Button, %k_Position%, T
Gui, Add, Button, %k_Position%, Y
Gui, Add, Button, %k_Position%, U
Gui, Add, Button, %k_Position%, I
Gui, Add, Button, %k_Position%, O
Gui, Add, Button, %k_Position%, P
Gui, Add, Button, %k_Position%, [
Gui, Add, Button, %k_Position%, ]
Gui, Add, Button, %k_Position%, \

Gui, Add, Button, xs+%k_KeyWidthHalf% y+%k_KeyMargin% %k_KeySize%, A
Gui, Add, Button, %k_Position%, S
Gui, Add, Button, %k_Position%, D
Gui, Add, Button, %k_Position%, F
Gui, Add, Button, %k_Position%, G
Gui, Add, Button, %k_Position%, H
Gui, Add, Button, %k_Position%, J
Gui, Add, Button, %k_Position%, K
Gui, Add, Button, %k_Position%, L
Gui, Add, Button, %k_Position%, `;
Gui, Add, Button, %k_Position%, '
Gui, Add, Button, x+%k_KeyMargin% h%k_KeyHeight%, Enter  ; Automatische Breite.

; Die erste untere Schaltfläche enthält am Ende %A_Space%, um sie etwas breiter zu machen,
; damit das Layout der Tasten daneben mehr einer echten Tastatur entspricht:
Gui, Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight%, Shift%A_Space%%A_Space%
Gui, Add, Button, %k_Position%, Z
Gui, Add, Button, %k_Position%, X
Gui, Add, Button, %k_Position%, C
Gui, Add, Button, %k_Position%, V
Gui, Add, Button, %k_Position%, B
Gui, Add, Button, %k_Position%, N
Gui, Add, Button, %k_Position%, M
Gui, Add, Button, %k_Position%, `,
Gui, Add, Button, %k_Position%, .
Gui, Add, Button, %k_Position%, /

Gui, Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight%, Ctrl  ; Automatische Breite.
Gui, Add, Button, h%k_KeyHeight% x+%k_KeyMargin%, Win      ; Automatische Breite.
Gui, Add, Button, h%k_KeyHeight% x+%k_KeyMargin%, Alt      ; Automatische Breite.
Gui, Add, Button, h%k_KeyHeight% x+%k_KeyMargin% w%k_SpacebarWidth%, Space


;---- Fenster anzeigen:
Gui, Show
k_IsVisible = y

WinGet, k_ID, ID, A   ; Fenster-ID abrufen.
WinGetPos,,, k_WindowWidth, k_WindowHeight, A

;---- Tastatur am unteren Rand des Bildschirms positionieren (unter Berücksichtigung
; der Position der Taskleiste):
SysGet, k_WorkArea, MonitorWorkArea, %k_Monitor%

; X-Position des Fensters berechnen:
k_WindowX = %k_WorkAreaRight%
k_WindowX -= %k_WorkAreaLeft%  ; Nun enthält k_WindowX die Breite des Monitors.
k_WindowX -= %k_WindowWidth%
k_WindowX /= 2  ; Position berechnen, um sie horizontal zu zentrieren.
; Das Folgende wird durchgeführt, falls sich das Fenster nicht auf den primären Monitor befindet
; oder wenn die Taskleiste auf der linken Seite des Bildschirms verankert ist:
k_WindowX += %k_WorkAreaLeft%

; Y-Position des Fensters berechnen:
k_WindowY = %k_WorkAreaBottom%
k_WindowY -= %k_WindowHeight%

WinMove, A,, %k_WindowX%, %k_WindowY%
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, TransColor, %TransColor% 220, ahk_id %k_ID%


;---- Alle Tasten als Hotkeys bestimmen. Siehe www.asciitable.com
k_n = 1
k_ASCII = 45

Loop
{
	Transform, k_char, Chr, %k_ASCII%
	StringUpper, k_char, k_char
	if k_char not in <,>,^,~,,`,
		Hotkey, ~*%k_char%, k_KeyPress
		; Mit dem oberen Sternchenpräfix wird die Taste erkannt, unabhängig davon,
		; ob der Benutzer die Modifikatortasten wie Steuerung und Umschalt gedrückt hält.
	if k_ASCII = 93
		break
	k_ASCII++
}

Return ; Ende des automatischen Ausführungsbereichs.


;---- Beim Tastendruck die entsprechende Schaltfläche auf dem Bildschirm drücken:

~*Backspace::
ControlClick, Bk, ahk_id %k_ID%, , LEFT, 1, D
KeyWait, Backspace
ControlClick, Bk, ahk_id %k_ID%, , LEFT, 1, U
Return


; LShift und RShift werden anstelle von "Shift" verwendet, denn als Hotkey
; würde "Shift" beim Loslassen der Taste standardmäßig ausgeführt (in älteren AHK-Versionen):
~*LShift::
~*RShift::
~*LCtrl::  ; Ctrl muss anstelle von Control verwendet werden, damit es mit dem Schaltflächennamen übereinstimmt.
~*RCtrl::
~*LAlt::
~*RAlt::
~*LWin::
~*RWin::
StringTrimLeft, k_ThisHotkey, A_ThisHotkey, 3
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
KeyWait, %k_ThisHotkey%
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U
Return


~*,::
~*'::
~*Space::
~*Enter::
~*Tab::
k_KeyPress:
StringReplace, k_ThisHotkey, A_ThisHotkey, ~
StringReplace, k_ThisHotkey, k_ThisHotkey, *
SetTitleMatchMode, 3  ; Verhindert, dass die Tasten T und B nicht mit Tabulator und Rücktaste (Backspace) verwechselt werden.
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
KeyWait, %k_ThisHotkey%
ControlClick, %k_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U
Return


k_ShowHide:
if k_IsVisible = y
{
	Gui, Cancel
	Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
	k_IsVisible = n
}
Else
{
	Gui, Show
	Menu, Tray, Rename, %k_MenuItemShow%, %k_MenuItemHide%
	k_IsVisible = y
}
Return


GuiClose:
k_MenuExit:
ExitApp
