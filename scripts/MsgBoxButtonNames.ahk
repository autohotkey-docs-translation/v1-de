; Button-Namen der MsgBox ändern
; http://www.autohotkey.com
; Das ist ein funktionierendes Beispiel-Script, das einen Timer verwendet,
; um die Namen der Buttons in einem MsgBox-Dialogfenster zu ändern. Auch wenn
; die Button-Namen geändert werden, benötigt der IfMsgBox-Befehl
; weiterhin den ursprünglichen Namen des Buttons.

#SingleInstance
SetTimer, ChangeButtonNames, 50 
MsgBox, 4, Hinzufügen oder Entfernen, Button auswählen:
IfMsgBox, YES 
	MsgBox, Hinzufügen ausgewählt. 
else
    MsgBox, Entfernen ausgewählt. 
return 

ChangeButtonNames: 
IfWinNotExist, Hinzufügen oder Entfernen
    return  ; Warten.
SetTimer, ChangeButtonNames, off
WinActivate
ControlSetText, Button1, &Hinzufügen
ControlSetText, Button2, &Entfernen
return
