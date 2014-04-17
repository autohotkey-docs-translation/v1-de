; Seek -- by Phi
; http://www.autohotkey.com
; Die Navigation im Startmenü kann umständlich sein, besonders
; wenn viele Programme im Laufe der Zeit installiert wurden. Mit "Seek"
; kann ein Schlüsselwort unabhängig von der Groß- und Kleinschreibung angegeben werden,
; um übereinstimmende Programme und Verzeichnisse im Startmenü herauszufiltern,
; damit das gewünschte Programm aus der Liste einfach geöffnet werden kann. ;*****************************************************************
;
;  Programm : Seek
;  Coder   : Phi
;  Aktualisiert : Mon Jan 31 10:08:37 2005
;
;  Wonach suchst du, mein Freund?
;
;*****************************************************************
;
;  Ich hatte viel Spaß dabei, das hier zu programmieren, und hoffe,
;  dass es dir auch gefallen wird. Du kannst mir jederzeit eine E-Mail mit
;  Kommentaren und Feedbacks schreiben: phi1618 (*a.t*) gmail
;  :D0T: com.
;
;  Optionen:
;    -cache Die zwischengespeicherte Verzeichnisauflistung verwenden, falls verfügbar
;           (Standardmodus, wenn keine Optionen angegeben werden)
;    -scan  Eine Verzeichnisüberprüfung erzwingen, um die aktuellste
;           Verzeichnisauflistung zu erhalten
;    -scex  Überprüfen & Beenden (nützlich, um die
;           möglicherweise zeitraubende Verzeichnisüberprüfung
;           im Hintergrund durchzuführen)
;    -help  Diese Hilfe anzeigen
;
;*****************************************************************
;
; WIE WIRD GESUCHT:
;
; 1. 'Seek' ist ein AutoHotkey-Script. Du kannst das Script entweder
;    als Seek.ahk (originales Script) oder als Seek.exe (kompilierte
;    ausführbare Datei) ausführen.
;
;    Um Seek.exe zu erhalten, kannst du Seek.zip (enthält
;    sowohl den Quellcode als auch die kompilierte Binärdatei) von
;    http://home.ripway.com/2004-10/188589/ herunterladen.
;    Ansonsten kannst du Seek.ahk auch selbst mithilfe des
;    Ahk2Exe-Compilers von AutoHotkey kompilieren, oder von mir
;    eine Kopie per E-Mail anfordern. Die Dateigröße liegt bei
;    ca. 200 kbytes. Ich kann damit erreicht werden: phi1618 (*a.t*)
;    gmail :D0T: com.
;
;    Damit Seek.ahk verwendet werden kann, installiere zuerst
;    AutoHotkey v1.0.25 oder höher auf deinem PC (von
;    http://www.autohotkey.com herunterladen). Als nächstes den Befehl ausführen:
;
;    C:\Programme\AutoHotkey\AutoHotkey.exe C:\MeineScripts\Seek.ahk
;
;    Denke daran, C:\Programme und C:\MeineScripts mit
;    den richtigen Verzeichnisnamen zu ersetzen.
;
; 2. Seek.exe kann von überall ausgeführt
;    werden. Es keine Installation notwendig, es wird
;    nichts in deiner Registrierung geschrieben, und greift nicht
;    auf das Internet zu (nicht nach Hause telefonieren). Um das Programm
;    zu deinstallieren, lösche einfach Seek.exe.
;
;    Es werden nur 2 Dateien im
;    TMP-Verzeichnis erstellt:
;
;      a. _Seek.key  (Cache-Datei für den aktuellsten Abfragestring)
;      b. _Seek.list (Cache-Datei für die Verzeichnisauflistung)
;
;    Wenn du ein Purist bist, dann kannst du diese Dateien manuell löschen,
;    falls du die Absicht hast, 'Seek' vom System zu entfernen.
;
; 3. Der bequemste Weg, 'Seek' auszuführen, erfolgt mittels
;    einer Tastenkombination/einem Hotkey. Falls du noch kein
;    Hotkey-Verwaltungsprogramm auf deinem PC verwendest,
;    empfehle ich dringendst AutoHotkey. Wenn du kein Hotkey-Verwaltungsprogramm
;    installieren willst, dann kannst du die
;    Tastenkombinationsfunktion von Windows benutzen und
;    einen Hotkey (z. B. ALT+F1) dazu bringen, 'Seek' auszuführen. Das ist
;    wichtig, da du 'Seek' jederzeit und von überall ausführen
;    kannst.
;
; 4. Beim erstmaligen Ausführen von 'Seek' wird dein
;    Startmenü überprüft und die Verzeichnisauflistung in
;    eine Cache-Datei gespeichert.
;
;    Die folgenden Verzeichnisse werden mit einbezogen:
;    - %A_StartMenu%
;    - %A_StartMenuCommon%
;
;    Standardmäßig werden nachfolgende Ausführungen die
;    Cache-Datei lesen, um die Ladezeit zu verringern. Für
;    mehr Infos über Optionen, führe 'Seek.exe -help' aus. Wenn du
;    denkst, dass dein Startmenü nicht sehr viele Programme
;    enthält, kannst du die Zwischenspeicherung deaktivieren und
;    'Seek' anweisen, immer eine Verzeichnisüberprüfung durchzuführen (mittels
;    der Option -scan).  Dadurch erhältst du immer die aktuelle
;    Auflistung.
;
; 5. Sobald du 'Seek' ausführst, erscheint ein Fenster und wartet darauf,
;    dass du ein Schlüsselwort einträgst. Nachdem du einen
;    Abfragestring eingetragen hast, wird eine Liste mit
;    Übereinstimmungen angezeigt. Als nächstes muss ein Eintrag ausgewählt
;    und <Enter> oder der Button 'Öffnen' gedrückt
;    werden, um das ausgewählte Programm auszuführen
;    oder das ausgewählte Verzeichnis zu öffnen.
;
;*****************************************************************
;
; TECHNISCHE HINWEISE:
;
; - 'Seek' benötigt Chris Mallett's AutoHotkey v1.0.25
;   oder höher (http://www.autohotkey.com).
;   Danke an Chris für seine großartige Arbeit mit AutoHotkey. :)
;
; - Die folgenden Umgebungsvariablen müssen gültig sein:
;   a. TMP
;
;*****************************************************************
;
; BEKANNTE PROBLEME:
;
; - Nil
;
;*****************************************************************
;
; UMGESETZTE VORSCHLÄGE:
;
; - Erste Übereinstimmung standardmäßig markieren, sodass
;   der Benutzer nur <Enter> zu drücken braucht, um sie auszuführen.
;   (Vorgeschlagen von Yih Yeong)
;
; - Doppelklick für die Auflistung der Suchergebnisse
;   ermöglichen, um das Programm auszuführen.
;   (Vorgeschlagen von Yih Yeong & Jack)
;
; - Automatische inkrementelle Suche in Echtzeit.
;   (Vorgeschlagen von Rajat)
;
; - Fuzzy-Suche bei Benutzereingabe von mehreren Abfragestrings,
;   durch Leerzeichen getrennt.
;   (Vorgeschlagen von Rajat)
;
;*****************************************************************
;
; VORGESCHLAGENE FUNKTIONEN (DIE VIELLEICHT UMGESETZT WERDEN):
;
; - Ausführungsablauf protokollieren. Die am häufigsten
;   verwendeten Programme am Anfang der Suchergebnisse auflisten.
;   (Vorgeschlagen von Yih Yeong)
;
; - Anstelle einer ListBox eine Reihe von Anwendung-Icons
;   darstellen, sodass ein ToolTip mit Programminformationen
;   (Pfad usw.) angezeigt wird, sobald sich der Mauszeiger
;   über das Icon befindet.
;   (Vorgeschlagen von Yih Yeong)
;
; - Anstatt mit dem Text in der Mitte übereinzustimmen, nur mit
;   Programm-/Verzeichnisnamen übereinstimmen, die mit dem
;   Abfragestring beginnen.
;   (Vorgeschlagen von Stefan)
;
; - Verwaltung von Favoriten hinzufügen. Eine Gruppe von Programmen
;   bei einer einzigen Ausführung starten.
;   (Vorgeschlagen von Atomhrt)
;
; - Seek in der Taskleiste/Symbolleiste integrieren, sodass
;   es immer verfügbar ist, wodurch es unnötig ist,
;   einen Hotkey zum Ausführen von Seek zu erstellen.
;   (Vorgeschlagen von Deniz Akay)
;
; - Suche mittels Platzhalter/RegEx.
;   (Vorgeschlagen von Steve)
;
;*****************************************************************
;
; ÄNDERUNGEN:
;
; * v1.1.0
; - Erste Veröffentlichung.
;
; * v1.1.1
; - Maximierungsoption entfernt, da einige Programme nicht
;   richtig damit funktionieren.
; - Doppelklickerkennung hinzugefügt, um die Öffnen-Funktion auszulösen.
;
; * v2.0.0
; - Das Popup-Fenster von 'Seek' wurde im Ausgabebildschirm integriert,
;   sodass der Benutzer den Abfragestring nochmals eingeben kann, um etwas
;   zu suchen, ohne dabei Seek zu beenden und wieder zu starten.
; - Button 'Startmenü überprüfen'  hinzugefügt.
; - Inkrementelle Suche in Echtzeit hinzugefügt, die Übereinstimmungen
;   bei der Benutzereingabe automatisch filtert, ohne darauf zu warten,
;   dass du <Enter> drückst.
; - Internen Schalter hinzugefügt (TrackKeyPhrase), um den Suchstring zu merken.
; - Internen Schalter hinzugefügt (ToolTipFilename), um den Dateinamen
;   mithilfe des Tooltips anzuzeigen.
;
; * v2.0.1
; - Horizontale Bildlaufleiste zur ListBox hinzugefügt, sodass sehr
;   lange Übereinstimmungen nicht gekürzt werden.
;
; * v2.0.2
; - Der Benutzer kann nun seine eigene angepasste Liste mit Verzeichnissen hinzufügen,
;   die beim Überprüfen mit einbezogen wird. Der Benutzer muss nur eine
;   Textdatei namens 'Seek.dir' im gleichen Verzeichnis von Seek.exe oder
;   Seek.ahk erstellen, und den vollständigen Pfad des Verzeichnisses angeben,
;   ein Verzeichnis pro Zeile. Die Pfade dürfen nicht in
;   einfache oder doppelte Anführungszeichen gesetzt werden.
;
; * v2.0.3
; - /on-Option zum DIR-Befehl hinzugefügt, um nach Name zu sortieren.
; - Fuzzy-Suche, wenn der Benutzer mehrere Abfragestrings eingibt,
;   getrennt durch Leerzeichen, zum Beispiel "med pla". Es erfolgt eine Übereinstimmung,
;   sobald alle Strings ("med" & "pla") gefunden werden. Damit wird zum Beispiel
;   "Media Player", "Macromedia Flash Player",
;   "Play Medieval King", "medpla", "plamed" gefunden.
; - Tabulator-Bewegungsablauf korrigiert, indem bereits alle Buttons
;   beim Start hinzugefügt werden, die jedoch deaktiviert sind, bis sie
;   gebraucht werden.
; - Statusleiste hinzugefügt, um ToolTip-Feedback zu ersetzen.
; - Veraltete interne Schalter entfernt (ToolTipFilename).
; - Das Verwenden des "dir"-Befehls wurde mit dem eigenen
;   "Loop"-Befehl von AutoHotkey ersetzt, um Verzeichnisinhalte zu überprüfen.
;   "dir" kann nicht mit erweiterten Zeichensätzen umgehen, folglich
;   wurden nicht englische (z. B. deutsche) Verzeichnisse und Dateinamen
;   falsch erfasst. (Danke an Wolfgang Bujatti und
;   Sietse Fliege fürs Testen der Modifikation)
; - Internen Schalter hinzugefügt (ScanMode), um zu definieren, ob
;   Dateien und/oder Verzeichnisse beim Überprüfen mit einbezogen werden.
; - Die selbst programmierte Erkennung vom Startmenü-Pfad wurde mit den
;   integrierten Variablen A_StartMenu und A_StartMenuCommon ersetzt.
;   Damit funktioniert Seek nun mit unterschiedlichen Sprachen, die
;   verschiedene Namensgebungen für den Startmenü haben.
;   (Danke an Wolfgang Bujatti und Sietse Fliege für die Hilfe
;   beim Testen der anderen Methode, bevor diese neuen Variablen
;   verfügbar waren.)
; - Vorauswahl der zuletzt ausgeführten Übereinstimmung hinzugefügt,
;   sodass sie beim zweimaligen Drücken von <ENTER> ausgeführt werden kann.
;
;*****************************************************************

;**************************
;<--- BEGINN DES PROGRAMMS --->
;**************************

;==== DEINE KONFIGURATION ===================================

; Gebt an, welches Programm beim Öffnen eines Verzeichnisses verwendet werden soll.
; Wenn das Programm nicht gefunden werden kann oder nicht angegeben ist
; (z. B. ist die Variable leer oder enthält einen Null-Wert),
; dann wird standardmäßig der Explorer verwendet.
dirExplorer = E:\utl\xplorer2_lite\xplorer2.exe

; Eine benutzerdefinierte Liste von zusätzlichen Verzeichnissen,
; die beim Überprüfen mit einbezogen wird. Der vollständige Pfad darf nicht in
; einfachen oder doppelten Anführungszeichen gesetzt werden. Wenn diese Datei nicht
; vorhanden ist, dann werden nur die Standardverzeichnisse überprüft.
SeekMyDir = %A_ScriptDir%\Seek.dir

; Gebt den Dateinamen und den Standort des Verzeichnisses an,
; um die zwischengespeicherte Verzeichnis-/Programmauflistung zu speichern. Es ist nicht notwendig,
; das hier zu ändern, solange es nicht der Wunsch ist.
dirListing = %A_Temp%\_Seek.list

; Gebt den Dateinamen und den Standort des Verzeichnisses an,
; um das zwischengespeicherte Schlüsselwort der letzten Suche zu speichern. Es ist nicht notwendig,
; das hier zu ändern, solange es nicht der Wunsch ist.
keyPhrase = %A_Temp%\_Seek.key

; Suchstring merken (ON/OFF)
; Wenn ON, dann wird der zuletzt benutzte Abfragestring als
; Standardabfragestring beim nächsten Ausführen von Seek wiederverwendet.
; Wenn OFF, dann wird der zuletzt benutzte Abfragestring nicht gespeichert,
; außerdem ist beim nächsten Ausführen von Seek kein
; Standardabfragestring vorhanden.
TrackKeyPhrase = ON

; Gebt an, was bei der Überprüfung mit einbezogen werden soll.
; 0: Verzeichnisse werden ignoriert (nur Dateien).
; 1: Es werden alle Dateien und Verzeichnisse mit einbezogen.
; 2: Nur Verzeichnisse einbeziehen (keine Dateien).
ScanMode = 1

;...........................................................

; INIT
;#NoTrayIcon
StringCaseSense, Off
version = Seek v2.0.3

; HILFE ANZEIGEN
If 1 in --help,-help,/h,-h,/?,-?
{
    MsgBox,, %version%, Die Navigation im Startmenü kann umständlich sein, besonders wenn viele Programme im Laufe der Zeit installiert wurden. Mit "Seek" kann ein Schlüsselwort unabhängig von der Groß- und Kleinschreibung angegeben werden, um übereinstimmende Programme und Verzeichnisse im Startmenü herauszufiltern, damit das gewünschte Programm aus der Liste einfach geöffnet werden kann. Dadurch entfällt das unnötige Durchsuchen des Startmenüs.`n`nIch hatte viel Spaß dabei, das hier zu programmieren, und hoffe, dass es dir auch gefallen wird. Du kannst mir jederzeit eine E-Mail mit Kommentaren und Feedbacks schreiben: phi1618 (*a.t*) gmail :D0T: com.`n`nOptionen:`n  -cache`tDie zwischengespeicherte Verzeichnisauflistung verwenden, falls verfügbar (Standardmodus, wenn keine Optionen angegeben werden)`n  -scan`tEine Verzeichnisüberprüfung erzwingen, um die aktuellste Verzeichnisauflistung zu erhalten`n  -scex`tÜberprüfen & Beenden (nützlich, um die möglicherweise zeitraubende Verzeichnisüberprüfung im Hintergrund durchzuführen)`n  -help`tDiese Hilfe anzeigen
    Goto QuitNoSave
}

; ÜBERPRÜFEN, OB DIE WICHTIGEN UMGEBUNGSVARIABLEN VORHANDEN UND GÜLTIG SIND
; *TMP*
IfNotExist, %A_Temp% ; PFAD IST NICHT VORHANDEN
{
    MsgBox Diese wichtige Umgebungsvariable ist entweder nicht definiert oder ungültig:`n`n    TMP = %A_Temp%`n`nBitte behebt dieses Problem, damit Seek ausgeführt werden kann.
    Goto QuitNoSave
}

; WENN NICHT ÜBERPFÜFEN-UND-BEENDEN
IfNotEqual 1, -scex
{
    ; DAS ZULETZT VERWENDETE SCHLÜSSELWORT VON DER CACHE-DATEI ABRUFEN,
    ; DAS ALS STANDARDABFRAGESTRING BENUTZT WIRD
    If TrackKeyPhrase = ON
    {
        FileReadLine, PrevKeyPhrase, %keyPhrase%, 1
        FileReadLine, PrevOpenTarget, %keyPhrase%, 2
    }
    NewKeyPhrase = %PrevKeyPhrase%
    NewOpenTarget = %PrevOpenTarget%

    ; TEXTBOX FÜR DEN BENUTZER HINZUFÜGEN, DAMIT DER ABFRAGESTRING EINGEGEBEN WERDEN KANN
    Gui, 1:Add, Edit, vFilename W600, %NewKeyPhrase%

    ; MEINE LIEBLINGSZEILE HINZUFÜGEN
    Gui, 1:Add, Text, X625 Y10, Wonach suchst du, mein Freund?

    ; STATUSLEISTE HINZUFÜGEN, UM FEEDBACKS FÜR DEN BENUTZER BEREITZUSTELLEN
    Gui, 1:Add, Text, vStatusBar X10 Y31 R1 W764

    ; AUSWAHL-LISTBOX HINZUFÜGEN, UM SUCHERGEBNISSE ANZUZEIGEN
    Gui, 1:Add, ListBox, vOpenTarget gTargetSelection X10 Y53 R28 W764 HScroll Disabled, %List%

    ; DIESE BUTTONS HINZUFÜGEN, ABER ERSTMAL DEAKTIVIEREN
    Gui, 1:Add, Button, gButtonOPEN vButtonOPEN Default X10 Y446 Disabled, Öffnen
    Gui, 1:Add, Button, gButtonOPENDIR vButtonOPENDIR X59 Y446 Disabled, Verzeichnis öffnen
    Gui, 1:Add, Button, gButtonSCANSTARTMENU vButtonSCANSTARTMENU X340 Y446 Disabled, Startmenü überprüfen

    ; BEENDEN-BUTTON HINZUFÜGEN
    Gui, 1:Add, Button, gButtonEXIT X743 Y446, Beenden

    ; ABFRAGEFENSTER ANZEIGEN
    Gui, 1:Show, Center, %version%
}

; NOCHMALIGE ÜBERPRÜFUNG DER LETZTEN VERZEICHNISAUFLISTUNG AKTIVIEREN
If 1 in -scan,-scex
    rescan = Y
; ÜBERPRÜFEN, OB DIE CACHE-DATEI FÜR DIE VERZEICHNISAUFLISTUNG BEREITS EXISTIERT. WENN NICHT, DANN NOCHMALS ÜBERPRÜFEN.
Else IfNotExist, %dirListing%
    rescan = Y

If rescan = Y ; NOCHMALS ÜBERPRÜFEN
{
    ; STATUS ANZEIGEN, ES SEI DENN, DIE OPTION ÜBERPRÜFEN-UND-BEENDEN IST AKTIV
    IfNotEqual 1, -scex
        GuiControl,, StatusBar, Verzeichnisauflistung wird überprüft ...

    ; STARTMENÜ ÜBERPRÜFEN UND VERZEICHNIS-/PROGRAMMAUFLISTUNG IN DIE CACHE-DATEI SPEICHERN
    Gosub ScanStartMenu

    ; BEENDEN, WENN DIE OPTION ÜBERPRÜFEN-UND-BEENDEN AKTIV IST
    IfEqual 1, -scex, Goto, QuitNoSave
}

GuiControl,, StatusBar, Letztes Abfrageergebnis abrufen ...

; VERGLEICHSLISTE FÜR DAS ZULETZT VERWENDETE SCHLÜSSELWORT ABRUFEN
Gosub SilentFindMatches

; STATUSTEXT ENTFERNEN
GuiControl,, StatusBar,

; VERZEICHNISAUFLISTUNG WURDE GELADEN. ANDERE BUTTONS WERDEN AKTIVIERT.
; DIESE BUTTONS WURDEN VORHER DEAKTIVIERT, DA SIE ERST
; FUNKTIONIEREN SOLLEN, WENN SIE GEBRAUCHT WERDEN.
GuiControl, 1:Enable, ButtonOPEN
GuiControl, 1:Enable, ButtonOPENDIR
GuiControl, 1:Enable, ButtonSCANSTARTMENU

; INKREMENTELLE SUCHE AKTIVIEREN
SetTimer, tIncrementalSearch, 500

; GUI AKTUALISIEREN
Gosub EnterQuery

Return

;***********************************************************
;                                                          *
;                 ENDE DES HAUPTPROGRAMMS                      *
;                                                          *
;***********************************************************


;=== BEGINN DES ButtonSCANSTARTMENU-EREIGNISSES =======================

ButtonSCANSTARTMENU:

Gui, 1:Submit, NoHide
GuiControl,, StatusBar, Verzeichnisauflistung wird überprüft ...

; LISTBOX DEAKTIVIEREN, WÄHREND ÜBERPRÜFT WIRD
GuiControl, 1:Disable, OpenTarget
GuiControl, 1:Disable, ButtonEXIT
GuiControl, 1:Disable, ButtonOPEN
GuiControl, 1:Disable, ButtonOPENDIR
GuiControl, 1:Disable, ButtonSCANSTARTMENU

; ÜBERPRÜFUNG DURCHFÜHREN
Gosub ScanStartMenu

; BENUTZER BENACHRICHTIGEN, DASS DIE ÜBERPRÜFUNG ABGESCHLOSSEN IST
If Filename =
{
    ; WENN ABFRAGESTRING LEER IST...
    GuiControl, 1:Enable, ButtonEXIT
    GuiControl, 1:Enable, ButtonOPEN
    GuiControl, 1:Enable, ButtonSCANSTARTMENU
    GuiControl,, StatusBar, Überprüfung abgeschlossen.
    Gosub EnterQuery
}
Else
{
    ; WENN ABFRAGESTRING VORHANDEN IST...
    ; MIT SUCHSTRING DIE NEUE AUFLISTUNG FILTERN
    NewKeyPhrase =
    Gosub FindMatches
}
Return

;... ENDE DES ButtonSCANSTARTMENU-EREIGNISSES .........................


;=== BEGINN DER ScanStartMenu-SUBROUTINE ========================
; STARTMENÜ ÜBERPRÜFEN UND VERZEICHNIS-/PROGRAMMAUFLISTUNG
; IN DIE CACHE-DATEI SPEICHERN
ScanStartMenu:

; VERZEICHNISPFADE DEFINIEREN, DIE ABGERUFEN WERDEN.
; DER PFAD DARF NICHT IN EINFACHEN ODER DOPPELTEN ANFÜHRUNGSZEICHEN GESETZT WERDEN.
;
; FÜR DIE ENGLISCHE VERSION VON WINDOWS
scanPath = %A_StartMenu%|%A_StartMenuCommon%

; ZUSÄTZLICHE BENUTZERDEFINIERTE PFADE BEIM ÜBERPRÜFEN MIT EINBEZIEHEN
IfExist, %SeekMyDir%
{
    Loop, read, %SeekMyDir%
    {
        IfNotExist, %A_LoopReadLine%
            MsgBox, 8192, %version%, Benutzerdefinierte Verzeichnisliste wird bearbeitet ...`n`n"%A_LoopReadLine%" ist weder vorhanden noch beim Überprüfen mit einbezogen.`nAktualisiert bitte [ %SeekMyDir% ].
        Else
            scanPath = %scanPath%|%A_LoopReadLine%
    }
}

; VORHANDENE DATEIEN LÖSCHEN, BEVOR EINE NEUE VERSION ERSTELLT WIRD
FileDelete, %dirListing%

; VERZEICHNISAUFLISTUNG ÜBERPRÜFEN (TRENNZEICHEN = |), WOBEI AUCH JEDES
; UNTERVERZEICHNIS MIT EINBEZOGEN WIRD. VERSTECKTE DATEIEN
; WERDEN IGNORIERT.
Loop, parse, scanPath, |
{
    Loop, %A_LoopField%\*, %ScanMode%, 1
    {
        FileGetAttrib, fileAttrib, %A_LoopFileFullPath%
        IfNotInString, fileAttrib, H ; VERSTECKTE DATEIEN IGNORIEREN
            FileAppend, %A_LoopFileFullPath%`n, %dirListing%
    }
}

Return

;... ENDE DER ScanStartMenu-SUBROUTINE ..........................


;=== BEGINN DER FindMatches-SUBROUTINE ==========================
; ALLE ÜBEREINSTIMMUNGEN IN DER LISTBOX ANZEIGEN
FindMatches:

Gui, 1:Submit, NoHide
CurFilename = %Filename%
GuiControl,, StatusBar,

; WENN ABFRAGESTRING LEER IST ...
If CurFilename =
{
    MsgBox, 8192, %version%, Bitte ein Schlüsselwort eingeben, mit dem gesucht wird.
    Goto EnterQuery
}

; tIncrementalSearch WURDE UNTERBROCHEN. BEENDEN LASSEN.
If NewKeyPhrase <> %CurFilename%
{
    ; BENUTZER INFORMIEREN, DASS GEDULD EINE TUGEND IST
    GuiControl,, StatusBar, Suche ...
    ResumeFindMatches = TRUE
    Return
}

If List = |
{
    ; KEINE EINZIGE ÜBEREINSTIMMUNG GEFUNDEN.
    ; LASS DEN BENUTZER DEN ABFRAGESTRING BEARBEITEN UND ERNEUT VERSUCHEN.
    MsgBox, 8192, %version%, Der Abfragestring "%CurFilename%" ermöglicht keine einzige Übereinstimmung. Versuche es erneut.
    GuiControl, 1:Disable, ButtonOPENDIR
    GuiControl, 1:Enable, ButtonSCANSTARTMENU
    Goto EnterQuery
}
Else
{
    ; ERSTE ÜBEREINSTIMMUNG AUSWÄHLEN, FALLS KEINE ANDERE ÜBEREINSTIMMUNG AUSGEWÄHLT WURDE
    Gui, 1:Submit, NoHide
    GuiControl, 1:Enable, OpenTarget
    GuiControl, 1:Enable, ButtonOPEN
    GuiControl, 1:Enable, ButtonOPENDIR
    GuiControl, 1:Enable, ButtonSCANSTARTMENU
    GuiControl, Focus, OpenTarget
    If OpenTarget =
        GuiControl, 1:Choose, OpenTarget, |1
}

; GUI AKTUALISIEREN
Gui, 1:Show, Center, %version%

Return

;... ENDE DER FindMatches-SUBROUTINE ..........................


;=== BEGINN DER SilentFindMatches-SUBROUTINE ====================

SilentFindMatches:

Gui, 1:Submit, NoHide
sfmFilename = %Filename%

; ÜBEREINSTIMMUNGEN FILTERN, BASIEREND AUF DEM ABFRAGESTRING
List = |
If sfmFilename <>
{
    Loop, read, %dirListing%
    {
        Gui, 1:Submit, NoHide
        tFilename = %Filename%
        If sfmFilename <> %tFilename%
        {
            ; BENUTZER HAT DEN SUCHSTRING GEÄNDERT. ES MACHT KEINEN SINN,
            ; DIE SUCHE MIT DEM ALTEN STRING FORTZUSETZEN, ALSO ABBRECHEN.
            Return
        }
        Else
        {
            ; ÜBEREINSTIMMUNGEN AN DIE LISTE ANFÜGEN
            SplitPath, A_LoopReadLine, name, dir, ext, name_no_ext, drive
            MatchFound = Y
            Loop, parse, sfmFilename, %A_Space%
            {
                IfNotInString, name, %A_LoopField%
                {
                    MatchFound = N
                    Break
                }
            }
            IfEqual, MatchFound, Y
            {
                ; ÜBEREINSTIMMUNG ZUR LISTE HINZUFÜGEN
                List = %List%%A_LoopReadLine%|

                ; VORAUSWÄHLEN, WENN DIESE ÜBEREINSTIMMUNG DAS ZULETZT AUSGEFÜHRTE PROGRAMM ENTSPRICHT
                If (A_LoopReadLine = PrevOpenTarget && sfmFilename = PrevKeyPhrase)
                    List = %List%|
            }
        }
    }
}

; LISTE MIT SUCHERGEBNISSEN AKTUALISIEREN
GuiControl, 1:, OpenTarget, %List%

If List = |
{
    ; KEINE ÜBEREINSTIMMUNG GEFUNDEN
    ; LISTBOX DEAKTIVIEREN
    GuiControl, 1:Disable, OpenTarget
    GuiControl, 1:Disable, ButtonOPENDIR
}
Else
{
    ; ÜBEREINSTIMMUNGEN GEFUNDEN
    ; LISTBOX AKTIVIEREN
    GuiControl, 1:Enable, OpenTarget
    GuiControl, 1:Enable, ButtonOPENDIR
}

; GUI AKTUALISIEREN
Gui, 1:Show, Center, %version%

Return

;... ENDE DER SilentFindMatches-SUBROUTINE ..........................


;=== BEGINN DER EnterQuery-SUBROUTINE ===========================
; GUI AKTUALISIEREN UND DEM BENUTZER DEN SUCHSTRING EINGEBEN LASSEN
EnterQuery:
GuiControl, Focus, Filename
GuiControl, 1:Enable, ButtonOPEN
Gui, 1:Show, Center, %version%
Return
;... ENDE DER EnterQuery-SUBROUTINE ..........................


;=== BEGINN DES TargetSelection-EREIGNISSES ===========================

TargetSelection:
Gui, 1:Submit, NoHide

; DOPPELKLICKERKENNUNG, UM PROGRAMM ZU STARTEN
If A_GuiControlEvent = DoubleClick
{
    Gosub ButtonOPEN
}
Else
{
    ; PLATZHALTER - FÜR ZUKÜNFTIGE VERWENDUNG
    If A_GuiControlEvent = Normal
    {
        ; ERSTMAL NICHTS TUN
    }
}

Return

;... ENDE DES TargetSelection-EREIGNISSES .........................


;=== BEGINN DES ButtonOPEN-EREIGNISSES ================================

; BENUTZER HAT DEN BUTTON 'ÖFFNEN' ODER <ENTER> GEDRÜCKT
ButtonOPEN:
Gui, 1:Submit, NoHide

; HERAUSFINDEN, WO DER TASTATURFOKUS WAR. WENN ER BEIM
; TEXTFELD IST, ABFRAGE AUSFÜHREN, UM ÜBEREINSTIMMUNGEN ZU FINDEN. ANSONSTEN IST ER
; BEI DER LISTBOX.
GuiControlGet, focusControl, 1:Focus
If focusControl = Edit1
{
    GuiControl, Focus, OpenTarget
    GuiControl, 1:Disable, OpenTarget
    GuiControl, 1:Disable, ButtonOPENDIR
    GuiControl, 1:Disable, ButtonSCANSTARTMENU
    Goto FindMatches
}

; KEINE ÜBEREINSTIMMUNG AUF DER LISTBOX AUSGEWÄHLT
If OpenTarget =
{
    MsgBox, 8192, %version%, Bitte eine Auswahl treffen`, bevor <Enter> gedrückt wird.`nDrücke <Esc>`, um zu beenden.
    Goto EnterQuery
}

; AUSGEWÄHLTE ÜBEREINSTIMMUNG NICHT VORHANDEN  (DATEI ODER VERZEICHNIS NICHT GEFUNDEN)
IfNotExist, %OpenTarget%
{
    MsgBox, 8192, %version%, %OpenTarget% nicht vorhanden. Das heißt`, dass der Verzeichnis-Cache nicht mehr aktuell ist. Du kannst den Button "Startmenü überprüfen" drücken`, um den Verzeichnis-Cache mit deiner neuesten Verzeichnisliste zu aktualisieren.
    Goto EnterQuery
}

; ÜBERPRÜFEN, OB DIE AUSGEWÄHLTE ÜBEREINSTIMMUNG EINE DATEI ODER EIN VERZEICHNIS IST
FileGetAttrib, fileAttrib, %OpenTarget%
IfInString, fileAttrib, D ; IST EIN VERZEICHNIS
{
    Gosub sOpenDir
}
Else If fileAttrib <> ; IST EINE DATEI
{
    Run, %OpenTarget%
}
Else
{
    MsgBox %OpenTarget% ist weder ein VERZEICHNIS noch eine DATEI. Das sollte nicht passieren. Die Suche kann nicht fortgesetzt werden. Beenden ...
}

Goto Quit

;... ENDE DES ButtonOPEN-EREIGNISSES .........................


;=== BEGINN DES ButtonOPENDIR-EREIGNISSES =============================

; BENUTZER HAT DEN BUTTON 'VERZEICHNIS ÖFFNEN' GEDRÜCKT
ButtonOPENDIR:
Gui, 1:Submit, NoHide

; ÜBERPRÜFEN, OB DER BENUTZER BEREITS EINE ÜBEREINSTIMMUNG AUSGEWÄHLT HAT
If OpenTarget =
{
    MsgBox, 8192, %version%, Bitte zuerst eine Auswahl treffen.
    Goto EnterQuery
}

; SUBROUTINE AUSFÜHREN, UM EIN VERZEICHNIS ZU ÖFFNEN
Gosub sOpenDir

Goto Quit

;... ENDE DES ButtonOPENDIR-EREIGNISSES .........................


;=== BEGINN DER sOpenDir-SUBROUTINE =============================

sOpenDir:

; WENN DER BENUTZER EINE DATEIÜBEREINSTIMMUNG ANSTELLE EINER VERZEICHNISÜBEREINSTIMMUNG AUSWÄHLT,
; DEN VERZEICHNISPFAD EXTRAHIEREN. (ICH VERWENDE DriveGet ANSTELLE VON
; FileGetAttrib, UM DAS SZENARIO ZU ERMÖGLICHEN, WO OpenTarget
; UNGÜLTIG IST, ABER DAS VERZEICHNIS VON OpenTarget GÜLTIG IST.
DriveGet, status, status, %OpenTarget%
If status <> Ready ; KEIN VERZEICHNIS
{
    SplitPath, OpenTarget, name, dir, ext, name_no_ext, drive
    OpenTarget = %dir%
}

; ÜBERPRÜFEN, OB VERZEICHNIS VORHANDEN IST
IfNotExist, %OpenTarget%
{
    MsgBox, 8192, %version%, %OpenTarget% nicht vorhanden. Das heißt`, dass der Verzeichnis-Cache nicht mehr aktuell ist. Du kannst den Button "Startmenü überprüfen" drücken`, um den Verzeichnis-Cache mit deiner neuesten Verzeichnisliste zu aktualisieren.
    Goto EnterQuery
}

; DAS VERZEICHNIS ÖFFNEN
IfExist, %dirExplorer%
{
    Run, "%dirExplorer%" "%OpenTarget%", , Max ; MIT BENUTZERDEFINIERTEN DATEI-EXPLORER ÖFFNEN
}
Else
{
    Run, %OpenTarget%, , Max ; MIT DEN STANDARD-EXPLORER VON WINDOWS ÖFFNEN
}
Return

;... ENDE DER sOpenDir-SUBROUTINE ..........................


;=== BEGINN DES tIncrementalSearch-EREIGNISSES ========================
; AUTOMATISCH EINE INKREMENTELLE SUCHE IN ECHTZEIT DURCHFÜHREN,
; UM ÜBEREINSTIMMUNGEN ZU FINDEN, OHNE DABEI AUF DIE BENUTZEREINGABE
; <ENTER> ZU WARTEN
tIncrementalSearch:

Loop
; SUCHE WIEDERHOLEN, BIS DER ABFRAGESTRING NICHT MEHR GEÄNDERT WIRD
{
    Gui, 1:Submit, NoHide
    CurFilename = %Filename%
    If NewKeyPhrase <> %CurFilename%
    {
        OpenTarget =
        Gosub SilentFindMatches
        NewKeyPhrase = %CurFilename%
        Sleep, 100 ; NICHT DIE CPU ÜBERLASTEN!
    }
    Else
    {
        ; ABFRAGESTRING WIRD NICHT MEHR GEÄNDERT
        Break
    }
}

; BENUTZER HAT <ENTER> GEDRÜCKT, UM DIE ÜBEREINSTIMMUNGEN ANZUSCHAUEN.
; JETZT FindMatches AUSFÜHREN.
If ResumeFindMatches = TRUE
{
    ResumeFindMatches = FALSE
    Gosub FindMatches
}

; ÄNDERUNGSÜBERWACHUNG FORTSETZEN
SetTimer, tIncrementalSearch, 500

Return

;... ENDE DES tIncrementalSearch-EREIGNISSES .........................


;=== BEGINN DER Quit-SUBROUTINE =================================

Quit:
ButtonEXIT:
GuiClose:
GuiEscape:

Gui, 1:Submit, NoHide

; SCHLÜSSELWORT FÜR DIE NÄCHSTE AUSFÜHRUNG SPEICHERN, FALLS ES GEÄNDERT WURDE
If TrackKeyPhrase = ON
{
    If (PrevKeyPhrase <> Filename || PrevOpenTarget <> OpenTarget)
    {
        FileDelete, %keyPhrase%
        FileAppend, %Filename%`n, %keyPhrase%
        FileAppend, %OpenTarget%`n, %keyPhrase%
    }
}

QuitNoSave:
ExitApp ; AUFGABE ERLEDIGT. GUTEN TAG!

;... ENDE DER Quit-SUBROUTINE ..........................


;************************
;<--- ENDE DES PROGRAMMS --->
;************************

; /* vim: set noexpandtab shiftwidth=4: */
