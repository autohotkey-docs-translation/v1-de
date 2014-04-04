; Joystick-Test-Script
; http://www.autohotkey.com
; Dieses Script hilft dabei, die Tastennummern und andere Attribute
; des aktuellen Joysticks zu bestimmen. Es könnte auch erkennen lassen, ob der aktuelle Joystick
; kalibriert werden muss; das heißt, ob der Bewegungsbereich jeder
; Achse von 0 bis 100 Prozent ist. Falls eine Kalibrierung erforderlich ist,
; verwendet die Systemsteuerung des Betriebssystems oder die mitgelieferte
; Software des aktuellen Joysticks.

; 6. Juli 2005: Automatische Erkennung der Joystick-Nummer hinzugefügt.
; 8. Mai 2005: Fehler behoben: JoyAxes wird nicht länger abgefragt, das heißt,
; ob der Joystick angeschlossen ist.  Einige Joysticks sind
; Gamepads und haben keine einzige Achse.

; Wenn unbedingt der Bedarf besteht, eine bestimmte Joystick-Nummer zu verwenden, ändert
; den folgenden Wert von 0 auf eine Joystick-Nummer (1-16).
; Bei einem Wert von 0 wird die Joystick-Nummer automatisch erkannt:
JoystickNumber = 0

; ENDE DES KONFIGURATIONSBEREICHS. Hier danach keine Änderungen durchführen,
; es sei denn, die allgemeine Funktionalität des Scripts soll geändert werden.

; Joystick-Nummer automatisch erkennen, falls gefordert:
if JoystickNumber <= 0
{
    Loop 16  ; Jede Joystick-Nummer auf Existenz überprüfen.
    {
        GetKeyState, JoyName, %A_Index%JoyName
        if JoyName <>
        {
            JoystickNumber = %A_Index%
            break
        }
    }
    if JoystickNumber <= 0
    {
        MsgBox Das System hat scheinbar keine Joysticks.
        ExitApp
    }
}

#SingleInstance
SetFormat, float, 03  ; Dezimalpunkt von den Prozentwerten der Achsenpositionen weglassen.
GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
GetKeyState, joy_name, %JoystickNumber%JoyName
GetKeyState, joy_info, %JoystickNumber%JoyInfo
Loop
{
    buttons_down =
    Loop, %joy_buttons%
    {
        GetKeyState, joy%a_index%, %JoystickNumber%joy%a_index%
        if joy%a_index% = D
            buttons_down = %buttons_down%%a_space%%a_index%
    }
    GetKeyState, joyx, %JoystickNumber%JoyX
    axis_info = X%joyx%
    GetKeyState, joyy, %JoystickNumber%JoyY
    axis_info = %axis_info%%a_space%%a_space%Y%joyy%
    IfInString, joy_info, Z
    {
        GetKeyState, joyz, %JoystickNumber%JoyZ
        axis_info = %axis_info%%a_space%%a_space%Z%joyz%
    }
    IfInString, joy_info, R
    {
        GetKeyState, joyr, %JoystickNumber%JoyR
        axis_info = %axis_info%%a_space%%a_space%R%joyr%
    }
    IfInString, joy_info, U
    {
        GetKeyState, joyu, %JoystickNumber%JoyU
        axis_info = %axis_info%%a_space%%a_space%U%joyu%
    }
    IfInString, joy_info, V
    {
        GetKeyState, joyv, %JoystickNumber%JoyV
        axis_info = %axis_info%%a_space%%a_space%V%joyv%
    }
    IfInString, joy_info, P
    {
        GetKeyState, joyp, %JoystickNumber%JoyPOV
        axis_info = %axis_info%%a_space%%a_space%POV%joyp%
    }
    ToolTip, %joy_name% (#%JoystickNumber%):`n%axis_info%`nGedrückte Tasten: %buttons_down%`n`n(Zum Beenden Rechtsklick auf Tray-Icon)
    Sleep, 100
}
return
