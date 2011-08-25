; Numpad-Taste 000
; http://www.autohotkey.com
; Dieses Beispiel-Script wandelt die 000-Sondertaste
; bei einigen Ziffernblöcken in eine Gleichheitstaste.  Diese Aktion kann geändert werden,
; wenn die Zeile "Send, =" je nach Bedarf mit einer anderen Zeile ersetzt wird.

#MaxThreadsPerHotkey 5  ; Erlaubt mehrere Threads für diesen Hotkey.
$Numpad0::
#MaxThreadsPerHotkey 1
; Oben: Mit einem $ wird der Hook erzwungen, wodurch eine
; Endlosschleife verhindert wird, da diese Subroutine selbst Numpad0 sendet,
; ansonsten würde sie sich selbst rekursiv aufrufen.
SetBatchLines, 100 ; Damit wird das Script ein wenig schneller ausgeführt.
DelayBetweenKeys = 30 ; Diesen Wert anpassen, falls es nicht funktionieren sollte.
if A_PriorHotkey = %A_ThisHotkey%
{
	if A_TimeSincePriorHotkey < %DelayBetweenKeys%
	{
		if Numpad0Count =
			Numpad0Count = 2 ; d.h. dieser Tastendruck plus vorherigen Tastendruck.
		else if Numpad0Count = 0
			Numpad0Count = 2
		Else
		{
			; Da wir hier sind, muss Numpad0Count wie bei
			; vorherigen Aufrufen eine 2 sein, das heißt, dass das hier
			; der dritte Tastendruck ist. Daher sollte die Hotkey-Sequenz
			; ausgeführt werden:
			Numpad0Count = 0
			Send, = ; ******* Die Aktion für die 000-Taste
		}
		; In allen obigen Fällen kehren wir ohne weitere Aktion zurück:
		CalledReentrantly = y
		Return
	}
}
; Ansonsten ist dieses Numpad0-Ereignis das erste in der Reihe
; oder wurde zu lange nach dem ersten ausgeführt (z. B. hält
; der Benutzer die Numpad0-Taste automatisch wiederholend gedrückt,
; dass wir erlauben wollen).  Deshalb werden wir nach einer kurzen Verzögerung (während ein
; anderes Numpad0-Hotkey-Ereignis diese Subroutine
; wiederholend aufruft), die Taste senden, falls kein weiterer Aufruf
; erfolgt:
Numpad0Count = 0
CalledReentrantly = n
; Während dieser Ruhephase kann diese Subroutine wiederholend
; aufgerufen werden (d. h. ein simultaner "Thread", der parallel zum jetzigen
; Aufruf ausgeführt wird):
Sleep, %DelayBetweenKeys%
if CalledReentrantly = y ; Ein anderer "Thread" hat diesen Wert geändert.
{
	; Da es wiederholend aufgerufen wurde, war dieses Tastenereignis das
	; erste in der Sequenz, daher sollte es unterdrückt werden (im System versteckt werden):
	CalledReentrantly = n
	Return
}
; Ansonsten gehört es nicht zur Sequenz, daher werden wir es normal senden.
; Mit anderen Worten wurde die *echte* Numpad0-Taste gedrückt, daher wollen
; wir den normalen Effekt:
Send, {Numpad0}
Return
