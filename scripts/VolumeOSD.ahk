; Lautstärke-Bildschirmanzeige (OSD) -- von Rajat
; http://www.autohotkey.com
; Dieses Script ermöglicht beliebige Hotkeys, die Gesamt- und/oder Wave-Lautstärke
; zu erhöhen oder zu verringern.  Beide Lautstärken werden als Balkendiagramme
; mit unterschiedlichen Farben angezeigt.

;_________________________________________________ 
;_______Benutzereinstellungen_____________________________ 

; Nur in diesem Bereich oder Hotkey-Bereich Änderungen durchführen!! 

; Der Prozentwert, um wieviel die Lautstärke jedes Mal erhöht oder verringert wird:
vol_Step = 4

; Wie lange die Balkendiagramme der Lautstärken angezeigt werden sollen:
vol_DisplayTime = 2000

; Balkenfarbe der Gesamtlautstärke (siehe Hilfe-Datei, um präzisere
; Farbtöne anzugeben):
vol_CBM = Red

; Balkenfarbe der Wave-Lautstärke
vol_CBW = Blue

; Hintergrundfarbe
vol_CW = Silver

; Balkenposition auf dem Bildschirm.  Verwendet -1, um den Balken in dieser Abmessung zu zentrieren:
vol_PosX = -1
vol_PosY = -1
vol_Width = 150  ; Balkenbreite
vol_Thick = 12   ; Balkendicke

; Wenn die aktuelle Tastatur Multimedia-Tasten für die Lautstärke hat, dann
; kannst du versuchen, die unteren Hotkeys so zu ändern, dass sie
; Volume_Up, ^Volume_Up, Volume_Down und ^Volume_Down verwenden:
HotKey, #Up, vol_MasterUp      ; Win+Pfeil nach oben
HotKey, #Down, vol_MasterDown
HotKey, +#Up, vol_WaveUp       ; Umschalt+Win+Pfeil nach oben
HotKey, +#Down, vol_WaveDown


;___________________________________________
;_____automatischer Ausführungsbereich_________ 

; HIER DANACH KEINE ÄNDERUNGEN DURCHFÜHREN (es sei denn, du weißt, was du tust).

vol_BarOptionsMaster = 1:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBM% CW%vol_CW%
vol_BarOptionsWave   = 2:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBW% CW%vol_CW%

; Wenn die X-Position angegeben wurde, dann wird sie zu den Optionen hinzugefügt.
; Ansonsten wird sie weggelassen, um den Balken horizontal zu zentrieren:
if vol_PosX >= 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% X%vol_PosX%
    vol_BarOptionsWave   = %vol_BarOptionsWave% X%vol_PosX%
}

; Wenn die Y-Position angegeben wurde, dann wird sie zu den Optionen hinzugefügt.
; Ansonsten wird sie weggelassen, um sie später zu berechnen:
if vol_PosY >= 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% Y%vol_PosY%
    vol_PosY_wave = %vol_PosY%
    vol_PosY_wave += %vol_Thick%
    vol_BarOptionsWave = %vol_BarOptionsWave% Y%vol_PosY_wave%
}

#SingleInstance
SetBatchLines, 10ms
Return


;___________________________________________ 

vol_WaveUp:
SoundSet, +%vol_Step%, Wave
Gosub, vol_ShowBars
return

vol_WaveDown:
SoundSet, -%vol_Step%, Wave
Gosub, vol_ShowBars
return

vol_MasterUp:
SoundSet, +%vol_Step%
Gosub, vol_ShowBars
return

vol_MasterDown:
SoundSet, -%vol_Step%
Gosub, vol_ShowBars
return

vol_ShowBars:
; Um den Blinkeffekt zu unterdrücken, wird nur das Balkenfenster erstellt,
; falls noch nicht vorhanden:
IfWinNotExist, vol_Wave
    Progress, %vol_BarOptionsWave%, , , vol_Wave
IfWinNotExist, vol_Master
{
    ; Falls sich die Bildschirmauflösung ändert, wird hier die Position berechnet,
    ; während das Script läuft:
    if vol_PosY < 0
    {
        ; Wave-Balken direkt über den Balken der Gesamtlautstärke erstellen:
        WinGetPos, , vol_Wave_Posy, , , vol_Wave
        vol_Wave_Posy -= %vol_Thick%
        Progress, %vol_BarOptionsMaster% Y%vol_Wave_Posy%, , , vol_Master
    }
    else
        Progress, %vol_BarOptionsMaster%, , , vol_Master
}
; Sobald beide Lautstärken vom Benutzer oder von einem externen Programm geändert werden, werden die neuen Lautstärken abgerufen:
SoundGet, vol_Master, Master
SoundGet, vol_Wave, Wave
Progress, 1:%vol_Master%
Progress, 2:%vol_Wave%
SetTimer, vol_BarOff, %vol_DisplayTime%
return

vol_BarOff:
SetTimer, vol_BarOff, off
Progress, 1:Off
Progress, 2:Off
return
