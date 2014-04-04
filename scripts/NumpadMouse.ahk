; Tastatur-Ziffernblock als eine Maus verwenden -- von deguix
; http://www.autohotkey.com
; Mit diesem Script kann die Maus wie die echte Maus bewegt werden
; (vielleicht sogar einfacher bei einigen Aufgaben).
; Es werden bis zu fünf Maustasten sowie das Drehen des Mausrades
; unterstützt.  Außerdem kann damit die Bewegungsgeschwindigkeit,
; Genauigkeit und "Achseninversion" angepasst werden.

/*
o------------------------------------------------------------o
|Tastatur-Ziffernblock als eine Maus verwenden               |
(------------------------------------------------------------)
| von deguix / Eine Script-Datei für AutoHotkey 1.0.22+      |
|                    ----------------------------------------|
|                                                            |
| Dieses Script ist ein Verwendungsbeispiel von AutoHotkey.  | 
| Es verwendet die Neubelegung von Numpad-Tasten, um eine    |
| Maus zu simulieren. Einige Funktionen sind die             |
| Beschleunigung, womit die Mausgeschwindigkeit beim         |
| längeren Halten einer Taste erhöht werden kann,            |
| und die Rotation, womit die Numpad-Maus "gedreht" werden   |
| kann. Zum Beispiel NumPadDown als NumPadUp und umgekehrt.  | 
| Siehe nachfolgende Liste mit Tasten:                       |
|                                                            |
|------------------------------------------------------------|
| Tasten                | Beschreibung                       |
|------------------------------------------------------------|
| ScrollLock (an)       | Aktiviert den Numpad-Maus-Modus.   |       
|-----------------------|------------------------------------|
| NumPad0               | Linker Maustastenklick.            |           
| NumPad5               | Mittlerer Maustastenklick.         |
| NumPadDot             | Rechter Maustastenklick.           |
| NumPadDiv/NumPadMult  | X1/X2-Maustastenklick. (Win 2k+)   |
| NumPadSub/NumPadAdd   | Mausrad nach oben/unten drehen.    |     
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (aus)         | Aktiviert den Mausbewegungsmodus.  |     
|-----------------------|------------------------------------|
| NumPadEnd/Down/PgDn/  | Mausbewegung.                      |
| /Left/Right/Home/Up/  |                                    |
| /PgUp                 |                                    |
|                       |                                    |
|-----------------------|------------------------------------|
| NumLock (an)          | Aktiviert Mauseinstellungsmodus.   |
|-----------------------|------------------------------------|
| NumPad7/NumPad1       | Erhöht/Verringert Beschleunigung   |
|                       | mittels Tastendruck.               |                      
| NumPad8/NumPad2       | Erhöht/Verringert Anfangsgeschwin- |
|                       | digkeit per Tastendruck.           |                      
| NumPad9/NumPad3       | Erhöht/Verringert Maximalgeschwin- |
|                       | digkeit per Tastendruck.           |                      
| ^NumPad7/^NumPad1     | Erhöht/Verringert Mausradbeschleu- |
|                       | nigung per Tastendruck.*           |                     
| ^NumPad8/^NumPad2     | Erhöht/Verringert Mausradanfangs-  |
|                       | geschwindigkeit per Tastendruck.*  |                     
| ^NumPad9/^NumPad3     | Erhöht/Verringert Mausradmaximal-  |
|                       | geschwindigkeit per Tastendruck.*  |                     
| NumPad4/NumPad6       | Erhöht/Verringert Rotationswinkel  |
|                       | nach rechts in Grad. (z.B.         |
|                       | 180° = Umgekehrt).                 |
|------------------------------------------------------------|
| * = Diese Optionen werden von der eingestellten Mausradge- |
| schwindigkeit in der Systemsteuerung beeinflusst. Falls    |
| die Maus kein Mausrad hat, dann wird standardmäßig         |
| +/- 3 Zeilen per Tastendruck verwendet.                    |
o------------------------------------------------------------o
*/

; BEGINN DES KONFIGURATIONSBEREICHS

#SingleInstance force
#MaxHotkeysPerInterval 500

; Mithilfe des Tastatur-Hooks werden die implementierten
; Numpad-Hotkeys daran gehindert, von ANSI-Zeichenerzeugungen
; wie à beeinträchtigt zu werden.  Denn AutoHotkey
; erzeugt solche Zeichen, sobald ALT gedrückt gehalten
; wird und mehrere Numpad-Tastatureingaben gesendet werden.
; Hook-Hotkeys sind intelligent genug, solche Tastatureingaben
; zu ignorieren.
#UseHook

MouseSpeed = 1
MouseAccelerationSpeed = 1
MouseMaxSpeed = 5

; Die Geschwindigkeit des Mausrads kann auch in der System-
; steuerung eingestellt werden. Da dadurch das normale Maus
; verhalten beeinflusst wird, sind die unten genannten Einstellungen
; Zeiten der normalen Geschwindigkeit des Mausrads.
MouseWheelSpeed = 1
MouseWheelAccelerationSpeed = 1
MouseWheelMaxSpeed = 5

MouseRotationAngle = 0

; ENDE DES KONFIGURATIONSBEREICHS

; Notwendig oder Tastendrücke senden fälschlicherweise
; ihre natürlichen Aktionen. Wie NumPadDiv wird manchmal "/" zum
; Bildschirm gesendet.       
#InstallKeybdHook

Temp = 0
Temp2 = 0

MouseRotationAnglePart = %MouseRotationAngle%
; Durch 45º teilen, weil MouseMove nur ganze Zahlen
; unterstützt, und sobald die Mausrotation auf eine Zahl kleiner
; als 45º gesetzt wird, erfolgen merkwürdige Bewegungen.
;
; Zum Beispiel: 22.5º beim Drücken von NumPadUp:
; Zuerst wird die Maus nach oben bewegt, bis die Geschwindigkeit
; 1 erreicht.
MouseRotationAnglePart /= 45

MouseCurrentAccelerationSpeed = 0
MouseCurrentSpeed = %MouseSpeed%

MouseWheelCurrentAccelerationSpeed = 0
MouseWheelCurrentSpeed = %MouseSpeed%

SetKeyDelay, -1
SetMouseDelay, -1

Hotkey, *NumPad0, ButtonLeftClick
Hotkey, *NumpadIns, ButtonLeftClickIns
Hotkey, *NumPad5, ButtonMiddleClick
Hotkey, *NumpadClear, ButtonMiddleClickClear
Hotkey, *NumPadDot, ButtonRightClick
Hotkey, *NumPadDel, ButtonRightClickDel
Hotkey, *NumPadDiv, ButtonX1Click
Hotkey, *NumPadMult, ButtonX2Click

Hotkey, *NumpadSub, ButtonWheelUp
Hotkey, *NumpadAdd, ButtonWheelDown

Hotkey, *NumPadUp, ButtonUp
Hotkey, *NumPadDown, ButtonDown
Hotkey, *NumPadLeft, ButtonLeft
Hotkey, *NumPadRight, ButtonRight
Hotkey, *NumPadHome, ButtonUpLeft
Hotkey, *NumPadEnd, ButtonUpRight
Hotkey, *NumPadPgUp, ButtonDownLeft
Hotkey, *NumPadPgDn, ButtonDownRight

Hotkey, Numpad8, ButtonSpeedUp
Hotkey, Numpad2, ButtonSpeedDown
Hotkey, Numpad7, ButtonAccelerationSpeedUp
Hotkey, Numpad1, ButtonAccelerationSpeedDown
Hotkey, Numpad9, ButtonMaxSpeedUp
Hotkey, Numpad3, ButtonMaxSpeedDown

Hotkey, Numpad6, ButtonRotationAngleUp
Hotkey, Numpad4, ButtonRotationAngleDown

Hotkey, !Numpad8, ButtonWheelSpeedUp
Hotkey, !Numpad2, ButtonWheelSpeedDown
Hotkey, !Numpad7, ButtonWheelAccelerationSpeedUp
Hotkey, !Numpad1, ButtonWheelAccelerationSpeedDown
Hotkey, !Numpad9, ButtonWheelMaxSpeedUp
Hotkey, !Numpad3, ButtonWheelMaxSpeedDown

Gosub, ~ScrollLock  ; Initialisieren, auf Basis von ScrollLock.
return

; Unterstützung für Tastenaktivierung

~ScrollLock::
; Darauf warten, bis sie losgelassen wird, weil der Hook-Status
; ansonsten beim Drücken der Taste neu gesetzt wird, wodurch das
; Up-Ereignis unterdrückt wird, folglich wird das Umschalten des
; ScrollLock-Status/Lichts verhindert:
KeyWait, ScrollLock
GetKeyState, ScrollLockState, ScrollLock, T
If ScrollLockState = D
{
    Hotkey, *NumPad0, on
    Hotkey, *NumpadIns, on
    Hotkey, *NumPad5, on
    Hotkey, *NumPadDot, on
    Hotkey, *NumPadDel, on
    Hotkey, *NumPadDiv, on
    Hotkey, *NumPadMult, on

    Hotkey, *NumpadSub, on
    Hotkey, *NumpadAdd, on

    Hotkey, *NumPadUp, on
    Hotkey, *NumPadDown, on
    Hotkey, *NumPadLeft, on
    Hotkey, *NumPadRight, on
    Hotkey, *NumPadHome, on
    Hotkey, *NumPadEnd, on
    Hotkey, *NumPadPgUp, on
    Hotkey, *NumPadPgDn, on

    Hotkey, Numpad8, on
    Hotkey, Numpad2, on
    Hotkey, Numpad7, on
    Hotkey, Numpad1, on
    Hotkey, Numpad9, on
    Hotkey, Numpad3, on

    Hotkey, Numpad6, on
    Hotkey, Numpad4, on

    Hotkey, !Numpad8, on
    Hotkey, !Numpad2, on
    Hotkey, !Numpad7, on
    Hotkey, !Numpad1, on
    Hotkey, !Numpad9, on
    Hotkey, !Numpad3, on
}
else
{
    Hotkey, *NumPad0, off
    Hotkey, *NumpadIns, off
    Hotkey, *NumPad5, off
    Hotkey, *NumPadDot, off
    Hotkey, *NumPadDel, off
    Hotkey, *NumPadDiv, off
    Hotkey, *NumPadMult, off

    Hotkey, *NumpadSub, off
    Hotkey, *NumpadAdd, off

    Hotkey, *NumPadUp, off
    Hotkey, *NumPadDown, off
    Hotkey, *NumPadLeft, off
    Hotkey, *NumPadRight, off
    Hotkey, *NumPadHome, off
    Hotkey, *NumPadEnd, off
    Hotkey, *NumPadPgUp, off
    Hotkey, *NumPadPgDn, off

    Hotkey, Numpad8, off
    Hotkey, Numpad2, off
    Hotkey, Numpad7, off
    Hotkey, Numpad1, off
    Hotkey, Numpad9, off
    Hotkey, Numpad3, off

    Hotkey, Numpad6, off
    Hotkey, Numpad4, off

    Hotkey, !Numpad8, off
    Hotkey, !Numpad2, off
    Hotkey, !Numpad7, off
    Hotkey, !Numpad1, off
    Hotkey, !Numpad9, off
    Hotkey, !Numpad3, off
}
return

; Unterstützung für Mausklicks

ButtonLeftClick:
GetKeyState, already_down_state, LButton
If already_down_state = D
    return
Button2 = NumPad0
ButtonClick = Left
Goto ButtonClickStart
ButtonLeftClickIns:
GetKeyState, already_down_state, LButton
If already_down_state = D
    return
Button2 = NumPadIns
ButtonClick = Left
Goto ButtonClickStart

ButtonMiddleClick:
GetKeyState, already_down_state, MButton
If already_down_state = D
    return
Button2 = NumPad5
ButtonClick = Middle
Goto ButtonClickStart
ButtonMiddleClickClear:
GetKeyState, already_down_state, MButton
If already_down_state = D
    return
Button2 = NumPadClear
ButtonClick = Middle
Goto ButtonClickStart

ButtonRightClick:
GetKeyState, already_down_state, RButton
If already_down_state = D
    return
Button2 = NumPadDot
ButtonClick = Right
Goto ButtonClickStart
ButtonRightClickDel:
GetKeyState, already_down_state, RButton
If already_down_state = D
    return
Button2 = NumPadDel
ButtonClick = Right
Goto ButtonClickStart

ButtonX1Click:
GetKeyState, already_down_state, XButton1
If already_down_state = D
    return
Button2 = NumPadDiv
ButtonClick = X1
Goto ButtonClickStart

ButtonX2Click:
GetKeyState, already_down_state, XButton2
If already_down_state = D
    return
Button2 = NumPadMult
ButtonClick = X2
Goto ButtonClickStart

ButtonClickStart:
MouseClick, %ButtonClick%,,, 1, 0, D
SetTimer, ButtonClickEnd, 10
return

ButtonClickEnd:
GetKeyState, kclickstate, %Button2%, P
if kclickstate = D
    return

SetTimer, ButtonClickEnd, off
MouseClick, %ButtonClick%,,, 1, 0, U
return

; Unterstützung für die Mausbewegung

ButtonSpeedUp:
MouseSpeed++
ToolTip, Mausgeschwindigkeit: %MouseSpeed% Pixel
SetTimer, RemoveToolTip, 1000
return
ButtonSpeedDown:
If MouseSpeed > 1
    MouseSpeed--
If MouseSpeed = 1
    ToolTip, Mausgeschwindigkeit: %MouseSpeed% Pixel
else
    ToolTip, Mausgeschwindigkeit: %MouseSpeed% Pixel
SetTimer, RemoveToolTip, 1000
return
ButtonAccelerationSpeedUp:
MouseAccelerationSpeed++
ToolTip, Mausbeschleunigungsgeschwindigkeit: %MouseAccelerationSpeed% Pixel
SetTimer, RemoveToolTip, 1000
return
ButtonAccelerationSpeedDown:
If MouseAccelerationSpeed > 1
    MouseAccelerationSpeed--
If MouseAccelerationSpeed = 1
    ToolTip, Mausbeschleunigungsgeschwindigkeit: %MouseAccelerationSpeed% Pixel
else
    ToolTip, Mausbeschleunigungsgeschwindigkeit: %MouseAccelerationSpeed% Pixel
SetTimer, RemoveToolTip, 1000
return

ButtonMaxSpeedUp:
MouseMaxSpeed++
ToolTip, Mausmaximalgeschwindigkeit: %MouseMaxSpeed% Pixel
SetTimer, RemoveToolTip, 1000
return
ButtonMaxSpeedDown:
If MouseMaxSpeed > 1
    MouseMaxSpeed--
If MouseMaxSpeed = 1
    ToolTip, Mausmaximalgeschwindigkeit: %MouseMaxSpeed% Pixel
else
    ToolTip, Mausmaximalgeschwindigkeit: %MouseMaxSpeed% Pixel
SetTimer, RemoveToolTip, 1000
return

ButtonRotationAngleUp:
MouseRotationAnglePart++
If MouseRotationAnglePart >= 8
    MouseRotationAnglePart = 0
MouseRotationAngle = %MouseRotationAnglePart%
MouseRotationAngle *= 45
ToolTip, Mausrotationswinkel: %MouseRotationAngle%°
SetTimer, RemoveToolTip, 1000
return
ButtonRotationAngleDown:
MouseRotationAnglePart--
If MouseRotationAnglePart < 0
    MouseRotationAnglePart = 7
MouseRotationAngle = %MouseRotationAnglePart%
MouseRotationAngle *= 45
ToolTip, Mausrotationswinkel: %MouseRotationAngle%°
SetTimer, RemoveToolTip, 1000
return

ButtonUp:
ButtonDown:
ButtonLeft:
ButtonRight:
ButtonUpLeft:
ButtonUpRight:
ButtonDownLeft:
ButtonDownRight:
If Button <> 0
{
    IfNotInString, A_ThisHotkey, %Button%
    {
        MouseCurrentAccelerationSpeed = 0
        MouseCurrentSpeed = %MouseSpeed%
    }
}
StringReplace, Button, A_ThisHotkey, *

ButtonAccelerationStart:
If MouseAccelerationSpeed >= 1
{
    If MouseMaxSpeed > %MouseCurrentSpeed%
    {
        Temp = 0.001
        Temp *= %MouseAccelerationSpeed%
        MouseCurrentAccelerationSpeed += %Temp%
        MouseCurrentSpeed += %MouseCurrentAccelerationSpeed%
    }
}

; MouseRotationAngle-Umwandlung in die Geschwindigkeit der Tastenrichtung
{
    MouseCurrentSpeedToDirection = %MouseRotationAngle%
    MouseCurrentSpeedToDirection /= 90.0
    Temp = %MouseCurrentSpeedToDirection%

    if Temp >= 0
    {
        if Temp < 1
        {
            MouseCurrentSpeedToDirection = 1
            MouseCurrentSpeedToDirection -= %Temp%
            Goto EndMouseCurrentSpeedToDirectionCalculation
        }
    }
    if Temp >= 1
    {
        if Temp < 2
        {
            MouseCurrentSpeedToDirection = 0
            Temp -= 1
            MouseCurrentSpeedToDirection -= %Temp%
            Goto EndMouseCurrentSpeedToDirectionCalculation
        }
    }
    if Temp >= 2
    {
        if Temp < 3
        {
            MouseCurrentSpeedToDirection = -1
            Temp -= 2
            MouseCurrentSpeedToDirection += %Temp%
            Goto EndMouseCurrentSpeedToDirectionCalculation
        }
    }
    if Temp >= 3
    {
        if Temp < 4
        {
            MouseCurrentSpeedToDirection = 0
            Temp -= 3
            MouseCurrentSpeedToDirection += %Temp%
            Goto EndMouseCurrentSpeedToDirectionCalculation
        }
    }
}
EndMouseCurrentSpeedToDirectionCalculation:

; MouseRotationAngle-Umwandlung in die Geschwindigkeit von 90 Grad nach rechts
{
    MouseCurrentSpeedToSide = %MouseRotationAngle%
    MouseCurrentSpeedToSide /= 90.0
    Temp = %MouseCurrentSpeedToSide%
    Transform, Temp, mod, %Temp%, 4

    if Temp >= 0
    {
        if Temp < 1
        {
            MouseCurrentSpeedToSide = 0
            MouseCurrentSpeedToSide += %Temp%
            Goto EndMouseCurrentSpeedToSideCalculation
        }
    }
    if Temp >= 1
    {
        if Temp < 2
        {
            MouseCurrentSpeedToSide = 1
            Temp -= 1
            MouseCurrentSpeedToSide -= %Temp%
            Goto EndMouseCurrentSpeedToSideCalculation
        }
    }
    if Temp >= 2
    {
        if Temp < 3
        {
            MouseCurrentSpeedToSide = 0
            Temp -= 2
            MouseCurrentSpeedToSide -= %Temp%
            Goto EndMouseCurrentSpeedToSideCalculation
        }
    }
    if Temp >= 3
    {
        if Temp < 4
        {
            MouseCurrentSpeedToSide = -1
            Temp -= 3
            MouseCurrentSpeedToSide += %Temp%
            Goto EndMouseCurrentSpeedToSideCalculation
        }
    }
}
EndMouseCurrentSpeedToSideCalculation:

MouseCurrentSpeedToDirection *= %MouseCurrentSpeed%
MouseCurrentSpeedToSide *= %MouseCurrentSpeed%

Temp = %MouseRotationAnglePart%
Transform, Temp, Mod, %Temp%, 2

If Button = NumPadUp
{
    if Temp = 1
    {
        MouseCurrentSpeedToSide *= 2
        MouseCurrentSpeedToDirection *= 2
    }

    MouseCurrentSpeedToDirection *= -1
    MouseMove, %MouseCurrentSpeedToSide%, %MouseCurrentSpeedToDirection%, 0, R
}
else if Button = NumPadDown
{
    if Temp = 1
    {
        MouseCurrentSpeedToSide *= 2
        MouseCurrentSpeedToDirection *= 2
    }

    MouseCurrentSpeedToSide *= -1
    MouseMove, %MouseCurrentSpeedToSide%, %MouseCurrentSpeedToDirection%, 0, R
}
else if Button = NumPadLeft
{
    if Temp = 1
    {
        MouseCurrentSpeedToSide *= 2
        MouseCurrentSpeedToDirection *= 2
    }

    MouseCurrentSpeedToSide *= -1
    MouseCurrentSpeedToDirection *= -1

    MouseMove, %MouseCurrentSpeedToDirection%, %MouseCurrentSpeedToSide%, 0, R
}
else if Button = NumPadRight
{
    if Temp = 1
    {
        MouseCurrentSpeedToSide *= 2
        MouseCurrentSpeedToDirection *= 2
    }

    MouseMove, %MouseCurrentSpeedToDirection%, %MouseCurrentSpeedToSide%, 0, R
}
else if Button = NumPadHome
{
    Temp = %MouseCurrentSpeedToDirection%
    Temp -= %MouseCurrentSpeedToSide%
    Temp *= -1
    Temp2 = %MouseCurrentSpeedToDirection%
    Temp2 += %MouseCurrentSpeedToSide%
    Temp2 *= -1
    MouseMove, %Temp%, %Temp2%, 0, R
}
else if Button = NumPadPgUp
{
    Temp = %MouseCurrentSpeedToDirection%
    Temp += %MouseCurrentSpeedToSide%
    Temp2 = %MouseCurrentSpeedToDirection%
    Temp2 -= %MouseCurrentSpeedToSide%
    Temp2 *= -1
    MouseMove, %Temp%, %Temp2%, 0, R
}
else if Button = NumPadEnd
{
    Temp = %MouseCurrentSpeedToDirection%
    Temp += %MouseCurrentSpeedToSide%
    Temp *= -1
    Temp2 = %MouseCurrentSpeedToDirection%
    Temp2 -= %MouseCurrentSpeedToSide%
    MouseMove, %Temp%, %Temp2%, 0, R
}
else if Button = NumPadPgDn
{
    Temp = %MouseCurrentSpeedToDirection%
    Temp -= %MouseCurrentSpeedToSide%
    Temp2 *= -1
    Temp2 = %MouseCurrentSpeedToDirection%
    Temp2 += %MouseCurrentSpeedToSide%
    MouseMove, %Temp%, %Temp2%, 0, R
}

SetTimer, ButtonAccelerationEnd, 10
return

ButtonAccelerationEnd:
GetKeyState, kstate, %Button%, P
if kstate = D
    Goto ButtonAccelerationStart

SetTimer, ButtonAccelerationEnd, off
MouseCurrentAccelerationSpeed = 0
MouseCurrentSpeed = %MouseSpeed%
Button = 0
return

;Unterstützung für die Mausradbewegung

ButtonWheelSpeedUp:
MouseWheelSpeed++
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
If MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
MouseWheelSpeedReal = %MouseWheelSpeed%
MouseWheelSpeedReal *= %MouseWheelSpeedMultiplier%
ToolTip, Mausradgeschwindigkeit: %MouseWheelSpeedReal% Zeilen
SetTimer, RemoveToolTip, 1000
return
ButtonWheelSpeedDown:
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
If MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
If MouseWheelSpeedReal > %MouseWheelSpeedMultiplier%
{
    MouseWheelSpeed--
    MouseWheelSpeedReal = %MouseWheelSpeed%
    MouseWheelSpeedReal *= %MouseWheelSpeedMultiplier%
}
If MouseWheelSpeedReal = 1
    ToolTip, Mausradgeschwindigkeit: %MouseWheelSpeedReal% Zeilen
else
    ToolTip, Mausradgeschwindigkeit: %MouseWheelSpeedReal% Zeilen
SetTimer, RemoveToolTip, 1000
return

ButtonWheelAccelerationSpeedUp:
MouseWheelAccelerationSpeed++
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
If MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
MouseWheelAccelerationSpeedReal = %MouseWheelAccelerationSpeed%
MouseWheelAccelerationSpeedReal *= %MouseWheelSpeedMultiplier%
ToolTip, Mausradbeschleunigungsgeschwindigkeit: %MouseWheelAccelerationSpeedReal% Zeilen
SetTimer, RemoveToolTip, 1000
return
ButtonWheelAccelerationSpeedDown:
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
If MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
If MouseWheelAccelerationSpeed > 1
{
    MouseWheelAccelerationSpeed--
    MouseWheelAccelerationSpeedReal = %MouseWheelAccelerationSpeed%
    MouseWheelAccelerationSpeedReal *= %MouseWheelSpeedMultiplier%
}
If MouseWheelAccelerationSpeedReal = 1
    ToolTip, Mausradbeschleunigungsgeschwindigkeit: %MouseWheelAccelerationSpeedReal% Zeilen
else
    ToolTip, Mausradbeschleunigungsgeschwindigkeit: %MouseWheelAccelerationSpeedReal% Zeilen
SetTimer, RemoveToolTip, 1000
return

ButtonWheelMaxSpeedUp:
MouseWheelMaxSpeed++
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
If MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
MouseWheelMaxSpeedReal = %MouseWheelMaxSpeed%
MouseWheelMaxSpeedReal *= %MouseWheelSpeedMultiplier%
ToolTip, Mausradmaximumgeschwindigkeit: %MouseWheelMaxSpeedReal% Zeilen
SetTimer, RemoveToolTip, 1000
return
ButtonWheelMaxSpeedDown:
RegRead, MouseWheelSpeedMultiplier, HKCU, Control Panel\Desktop, WheelScrollLines
If MouseWheelSpeedMultiplier <= 0
    MouseWheelSpeedMultiplier = 1
If MouseWheelMaxSpeed > 1
{
    MouseWheelMaxSpeed--
    MouseWheelMaxSpeedReal = %MouseWheelMaxSpeed%
    MouseWheelMaxSpeedReal *= %MouseWheelSpeedMultiplier%
}
If MouseWheelMaxSpeedReal = 1
    ToolTip, Mausradmaximumgeschwindigkeit: %MouseWheelMaxSpeedReal% Zeilen
else
    ToolTip, Mausradmaximumgeschwindigkeit: %MouseWheelMaxSpeedReal% Zeilen
SetTimer, RemoveToolTip, 1000
return

ButtonWheelUp:
ButtonWheelDown:

If Button <> 0
{
    If Button <> %A_ThisHotkey%
    {
        MouseWheelCurrentAccelerationSpeed = 0
        MouseWheelCurrentSpeed = %MouseWheelSpeed%
    }
}
StringReplace, Button, A_ThisHotkey, *

ButtonWheelAccelerationStart:
If MouseWheelAccelerationSpeed >= 1
{
    If MouseWheelMaxSpeed > %MouseWheelCurrentSpeed%
    {
        Temp = 0.001
        Temp *= %MouseWheelAccelerationSpeed%
        MouseWheelCurrentAccelerationSpeed += %Temp%
        MouseWheelCurrentSpeed += %MouseWheelCurrentAccelerationSpeed%
    }
}

If Button = NumPadSub
    MouseClick, wheelup,,, %MouseWheelCurrentSpeed%, 0, D
else if Button = NumPadAdd
    MouseClick, wheeldown,,, %MouseWheelCurrentSpeed%, 0, D

SetTimer, ButtonWheelAccelerationEnd, 100
return

ButtonWheelAccelerationEnd:
GetKeyState, kstate, %Button%, P
if kstate = D
    Goto ButtonWheelAccelerationStart

MouseWheelCurrentAccelerationSpeed = 0
MouseWheelCurrentSpeed = %MouseWheelSpeed%
Button = 0
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
Return