; Fenster in das Tray-Menü minimieren
; http://www.autohotkey.com
; Dieses Script ermöglicht einem beliebigen Hotkey, ein beliebiges Fenster zu verstecken,
; damit es als Menüpunkt am Ende des Tray-Menüs angezeigt wird.  Versteckte
; Fenster können dann wieder einzeln oder alle auf einmal sichtbar gemacht werden,
; indem der entsprechende Menüpunkt ausgewählt wird.  Falls das Script aus irgendeinem Grund beendet wird,
; werden alle versteckten Fenster wieder automatisch sichtbar gemacht.

; ÄNDERUNGEN:
; 22. Juli 2005 (bereitgestellte Änderungen von egilmour):
; - Neuer Hotkey hinzugefügt, um das zuletzt versteckte Fenster wieder sichtbar zu machen (Win+U)
;
; 3. November 2004 (bereitgestellte Änderungen von trogdor):
; - Programm-Manager kann nicht mehr versteckt werden.
; - Falls kein aktives Fenster vorhanden ist, dann ist der In-Tray-minimieren-Hotkey nicht aktiv,
;   anstatt unendlich lang zu warten.
;
; 23. Oktober 2004:
; - Tastleiste kann nicht mehr versteckt werden.
; - Mögliche Probleme mit langen Fenstertiteln wurden behoben.
; - Fenster ohne Titel können ohne Probleme versteckt werden.
; - Wenn das Script unter AHK v1.0.22 oder höher ausgeführt wird,
;   dann wird die maximale Länge jeden Menüpunkts von 100 auf 260 erhöht.

; KONFIGURATIONSBEREICH: Ändert die unteren Werte je nach Bedarf.

; Die maximale Anzahl der Fenster, die versteckt werden können (hilft
; der Performance):
mwt_MaxWindows = 50

; Der Hotkey, um das aktive Fenster zu verstecken:
mwt_Hotkey = #h  ; Win+H

; Der Hotkey, um das zuletzt versteckte Fenster wieder sichtbar zu machen:
mwt_UnHotkey = #u  ; Win+U

; Falls der Wunsch besteht, keine vorgegebenen Menüpunkte
; wie Help und Pause anzuzeigen, verwendet N.  Ansonsten Y:
mwt_StandardMenu = N

; Die nächsten Performance-Einstellungen helfen dabei, die Aktion innerhalb
; der #HotkeyModifierTimeout-Periode durchzuführen, daher müssen die Modifikatoren
; des Hotkeys nicht erst gedrückt und wieder losgelassen werden,
; wenn mehr als ein Fenster gleichzeitig versteckt werden soll.  Diese Einstellungen verhindern, dass der Tastatur-Hook mithilfe von
; #InstallKeybdHook oder ähnliches manuell gesetzt werden muss:
#HotkeyModifierTimeout 100
SetWinDelay 10
SetKeyDelay 0

#SingleInstance  ; Dadurch kann nur eine Instanz des Scripts ausgeführt werden.

; ENDE DES KONFIGURATIONSBEREICHS (Hier danach keine Änderungen durchführen,
; es sei denn, die allgemeine Funktionalität des Scripts soll geändert werden).

Hotkey, %mwt_Hotkey%, mwt_Minimize
Hotkey, %mwt_UnHotkey%, mwt_UnMinimize

; Wenn der Benutzer das Script irgendwie beendet, dann zuerst
; alle Fenster wieder sichtbar machen:
OnExit, mwt_RestoreAllThenExit

if mwt_StandardMenu = Y
	Menu, Tray, Add
Else
{
	Menu, Tray, NoStandard
	Menu, Tray, Add, &Beenden und Fenster sichtbar machen, mwt_RestoreAllThenExit
}
Menu, Tray, Add, &Alle versteckten Fenster sichtbar machen, mwt_RestoreAll
Menu, Tray, Add  ; Eine weitere Trennlinie, um die obigen Menüpunkte abzugrenzen.

if a_AhkVersion =   ; Falls leer, dann ist die Version älter als 1.0.22.
	mwt_MaxLength = 100
Else
	mwt_MaxLength = 260  ; Verringern, um die Breite des Menüs zu begrenzen.

Return ; Ende des automatischen Ausführungsbereichs.


mwt_Minimize:
if mwt_WindowCount >= %mwt_MaxWindows%
{
	MsgBox Es können nicht mehr als %mwt_MaxWindows% gleichzeitig versteckt werden.
	Return
}

; Bestimmt das zuletzt gefundene Fenster für die einfache Verwendung und Performance.
; Es kann vorkommen, dass kein aktives Fenster vorhanden ist,
; daher wurde eine Zeitüberschreitung hinzugefügt:
WinWait, A,, 2
if ErrorLevel <> 0  ; Zeit überschritten, daher nichts tun.
	Return

; Ansonsten wurde das "zuletzt gefundene Fenster" gesetzt und kann nun verwendet werden:
WinGet, mwt_ActiveID, ID
WinGetTitle, mwt_ActiveTitle
WinGetClass, mwt_ActiveClass
if mwt_ActiveClass in Shell_TrayWnd,Progman
{
	MsgBox Der Desktop und die Taskleiste können nicht versteckt werden.
	Return
}
; Da das Fenster beim Verstecken nicht deaktiviert wird, wird das Fenster
; darunter aktiviert (falls vorhanden). Ich habe andere Wege ausprobiert, was aber dazu führte,
; dass die Taskleiste aktiviert wurde.  Mit diesem Weg wird das aktive Fenster (welches
; versteckt werden soll) ans Ende des Stapels verschoben, dass scheinbar am besten ist:
Send, !{esc}
; Nun das Fenster verstecken, das mit WinGetTitle/WinGetClass verwendet wurde (da
; standardmäßig solche Befehle keine versteckten Fenster erkennen können):
WinHide

; Wenn der Titel leer ist, dann wird die Klasse stattdessen verwendet.  Dies dient zwei Aufgaben:
; 1) Ein aussagekräftiger Name wird als Menüname verwendet.
; 2) Damit kann der Menüpunkt erstellt werden (ansonsten würden leere Menüpunkte
;    nicht korrekt von den unteren Routinen behandelt).
if mwt_ActiveTitle =
	mwt_ActiveTitle = ahk_class %mwt_ActiveClass%
; Stellt sicher, dass der Titel kurz genug ist, damit er passt. mwt_ActiveTitle dient auch dazu,
; diesen bestimmten Menüpunkt eindeutig zu identifizieren.
StringLeft, mwt_ActiveTitle, mwt_ActiveTitle, %mwt_MaxLength%

; Neben dem Tray-Menü, dessen Menüpunktnamen eindeutig sein müssen,
; muss das Tray-Menü selbst auch eindeutig sein, sodass im Array nachgeschaut werden kann,
; wenn das Fenster später wieder sichtbar gemacht wird.  Daher macht das Menü eindeutig,
; wenn noch nicht getan:
Loop, %mwt_MaxWindows%
{
	if mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
	{
		; Übereinstimmung gefunden, also nicht eindeutig.
		; Zuerst wird das 0x von der Hexadezimalen Zahl entfernt, um Platz im Menü zu sparen:
		StringTrimLeft, mwt_ActiveIDShort, mwt_ActiveID, 2
		StringLen, mwt_ActiveIDShortLength, mwt_ActiveIDShort
		StringLen, mwt_ActiveTitleLength, mwt_ActiveTitle
		mwt_ActiveTitleLength += %mwt_ActiveIDShortLength%
		mwt_ActiveTitleLength += 1 ; +1 ist das Leerzeichen zwischen Titel & ID.
		if mwt_ActiveTitleLength > %mwt_MaxLength%
		{
			; Da die Länge der Menüpunktnamen limitiert ist,
			; wird der Titel am Ende gekürzt, damit genug Platz
			; für die kurze ID des Fensters vorhanden ist:
			TrimCount = %mwt_ActiveTitleLength%
			TrimCount -= %mwt_MaxLength%
			StringTrimRight, mwt_ActiveTitle, mwt_ActiveTitle, %TrimCount%
		}
		; Eindeutigen Titel konstruieren:
		mwt_ActiveTitle = %mwt_ActiveTitle% %mwt_ActiveIDShort%
		break
	}
}

; Zuerst sicherstellen, dass die ID noch nicht in der Liste vorhanden ist, dass
; passieren kann, wenn ein bestimmtes Fenster extern sichtbar gemacht wurde
; und nun wieder dabei ist, versteckt zu werden:
mwt_AlreadyExists = n
Loop, %mwt_MaxWindows%
{
	if mwt_WindowID%a_index% = %mwt_ActiveID%
	{
		mwt_AlreadyExists = y
		break
	}
}

; Das Element ins Array und im Menü einfügen:
if mwt_AlreadyExists = n
{
	Menu, Tray, add, %mwt_ActiveTitle%, RestoreFromTrayMenu
	mwt_WindowCount += 1
	Loop, %mwt_MaxWindows%  ; Nach einer freien Stelle suchen.
	{
		; Es sollte immer eine freie Stelle gefunden werden, wenn alles richtig gemacht ist.
		if mwt_WindowID%a_index% =  ; Eine leere Stelle wurde gefunden.
		{
			mwt_WindowID%a_index% = %mwt_ActiveID%
			mwt_WindowTitle%a_index% = %mwt_ActiveTitle%
			break
		}
	}
}
Return


RestoreFromTrayMenu:
Menu, Tray, delete, %A_ThisMenuItem%
; Fenster finden, basierend auf dessen eindeutigen Titel, der als Menüpunktname gespeichert ist:
Loop, %mwt_MaxWindows%
{
	if mwt_WindowTitle%a_index% = %A_ThisMenuItem%  ; Übereinstimmung gefunden.
	{
		StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
		WinShow, ahk_id %IDToRestore%
		WinActivate ahk_id %IDToRestore%  ; Manchmal notwendig.
		mwt_WindowID%a_index% =  ; Leer machen, um die Stelle freizugeben.
		mwt_WindowTitle%a_index% =
		mwt_WindowCount -= 1
		break
	}
}
Return


; Damit wird das zuletzt minimierte Fenster aktiviert und sichtbar gemacht.
mwt_UnMinimize:
; Sicherstellen, dass etwas vorhanden ist, das sichtbar gemacht wird.
if mwt_WindowCount > 0 
{
	; Ermittelt die ID des zuletzt minimierten Fensters und macht es sichtbar
	StringTrimRight, IDToRestore, mwt_WindowID%mwt_WindowCount%, 0
	WinShow, ahk_id %IDToRestore%
	WinActivate ahk_id %IDToRestore%
	
	; Ermittelt den Menünamen des zuletzt minimierten Fensters und entfernt ihn
	StringTrimRight, MenuToRemove, mwt_WindowTitle%mwt_WindowCount%, 0
	Menu, Tray, delete, %MenuToRemove%
	
	; Array aufräumen und Fensterzählung verringern
	mwt_WindowID%mwt_WindowCount% =
	mwt_WindowTitle%mwt_WindowCount% = 
	mwt_WindowCount -= 1
}
Return


mwt_RestoreAllThenExit:
Gosub, mwt_RestoreAll
ExitApp  ; Echtes Exit durchführen.


mwt_RestoreAll:
Loop, %mwt_MaxWindows%
{
	if mwt_WindowID%a_index% <>
	{
		StringTrimRight, IDToRestore, mwt_WindowID%a_index%, 0
		WinShow, ahk_id %IDToRestore%
		WinActivate ahk_id %IDToRestore%  ; Manchmal notwendig.
		; Diesen Weg anstelle von DeleteAll durchführen, sodass die Trennlinie
		; und das erste Element erhalten bleiben:
		StringTrimRight, MenuToRemove, mwt_WindowTitle%a_index%, 0
		Menu, Tray, delete, %MenuToRemove%
		mwt_WindowID%a_index% =  ; Leer machen, um die Stelle freizugeben.
		mwt_WindowTitle%a_index% =
		mwt_WindowCount -= 1
	}
	if mwt_WindowCount = 0
		break
}
Return
