#Requires AutoHotkey v2
SetWorkingDir(A_ScriptDir "\..")

SplitPath(A_WorkingDir, &parentName)
if FileExist(parentName "-omegat.tmx")
    LastSaveTime := FileGetTime(parentName "-omegat.tmx")
TotalProcessedFiles := 0
Loop Files, "target\docs\*.htm", "R"
{
    ; Get number of processed files to determine whether only one or all documents was created:
    
    if IsSet(LastSaveTime)
    {
        ModifyTime := FileGetTime(A_LoopFileFullPath)
        DiffTime := DateDiff(LastSaveTime, ModifyTime, "seconds")
        if (DiffTime <= 0)
            TotalProcessedFiles++
    }
    
    ; read content
    
    FileEncoding("UTF-8-RAW")
    content_orig := FileRead(A_LoopFileFullPath)
    content := content_orig
    
    ; skip sites
    
    if (A_LoopFilePath ~= "target\\docs\\search\.htm")
      continue

    ; add more infos about the translation 

    if (A_LoopFilePath = "target\docs\index.htm")
    {
        content := RegExReplace(content, '<p><a.*?</a></p>', '<p>Eine deutsche &Uuml;bersetzung von <a href="https://www.autohotkey.com/docs/v1/">https://www.autohotkey.com/docs/v1/</a> (siehe <a href="https://autohotkey.com/boards/viewtopic.php?f=9&amp;t=43">hier</a> f&uuml;r mehr Details).</p>')
    }

    ; add google analytics

    If RegExMatch(content, 'link href="(.*)static/theme.css"', &m)
        pre := m[1]

    replace  := 
    ( Join`r`n
    '<script src="' pre 'static/content.js" type="text/javascript"></script>
    <script src="' pre 'static/ga4.js" type="text/javascript"></script>'
    )

    if not InStr(content, replace)
        content := RegExReplace(content, "<script.*content.js.*?>.*</script>", replace)

    ; overwrite file if needed

    if (content != content_orig)
    {
        f := FileOpen(A_LoopFileFullPath, "w")
        if !f
            MsgBox(A_LoopFileFullPath)
        f.Write(content)
        f.Close()
    }
    
}

; Skip the rest below if only one file was processed since the file was only created for testing purposes:

if (TotalProcessedFiles = 1)
    ExitApp

; add/replace target files

ErrorCount := CopyFilesAndFolders(A_ScriptDir "\target\*.*", "target", true)
if (ErrorCount != 0)
    MsgBox(ErrorCount " files/folders could not be copied.")

; Skip the rest below if the working directory is not a real OmegaT project:

if not IsSet(LastSaveTime)
    ExitApp

; create search index

; FileAppend,, % "target\docs\static\source\data_search.js"
; RunWait, % A_AhkPath "\..\v2\AutoHotkey32.exe" " """ "target\docs\static\source\build_search.ahk"""

; Temporarily exclude google analytics file as not needed for chm:

FileMove("target\docs\static\ga4.js", "target\docs\static\ga4.excluded")

; compile docs to chm

RunWait("target\compile_chm.ahk")

; Restore google analytics file:

FileMove("target\docs\static\ga4.excluded", "target\docs\static\ga4.js")

; compress chm into zip file

SmartZip("target\AutoHotkey.chm", "temp.zip")
FileMove("temp.zip", "AutoHotkeyHelp_DE.zip", 1)

; delete chm files

FileDelete("target\*.chm")
FileDelete("target\*.hhk")

/*
SmartZip()
   Smart ZIP/UnZIP files
Parameters:
   s, o   When compressing, s is the dir/files of the source and o is ZIP filename of object. When unpressing, they are the reverse.
   t      The options used by CopyHere method. For availble values, please refer to: https://learn.microsoft.com/en-us/windows/win32/shell/folder-copyhere
Link:
https://www.autohotkey.com/board/topic/60706-
*/

SmartZip(s, o, t := 4)
{
    if !FileExist(s)
        return -1        ; The souce is not exist. There may be misspelling.
    
    oShell := ComObject("Shell.Application")
    
    if (SubStr(o, -4) = ".zip") ; Zip
    {
        if !FileExist(o)        ; Create the object ZIP file if it's not exist.
            CreateZip(o)
        
        Loop Files, o, "DF"
            sObjectLongName := A_LoopFileFullPath

        oObject := oShell.NameSpace(sObjectLongName)
        
        Loop Files, s, "DF"
        {
            if (sObjectLongName = A_LoopFileFullPath)
            {
                continue
            }
            ToolTip("Zipping " A_LoopFileName " ..")
            oObject.CopyHere(A_LoopFileFullPath, t)
            SplitPath(A_LoopFileFullPath, &OutFileName)
            Loop
            {
                oObject := "", oObject := oShell.NameSpace(sObjectLongName) ; This doesn't affect the copyhere above.
                try if oObject.ParseName(OutFileName)
                    break
            }
        }
        ToolTip()
    }
    else if InStr(FileExist(o), "D") or (!FileExist(o) and (SubStr(s, -4) = ".zip"))    ; Unzip
    {
        if !o
            o := A_ScriptDir        ; Use the working dir instead if the object is null.
        else if not FileExist(o)
            DirCreate(o)
        
        Loop Files, o, "DF"
            sObjectLongName := A_LoopFileFullPath
        
        oObject := oShell.NameSpace(sObjectLongName)
        
        Loop Files, s, "DF"
        {
            oSource := oShell.NameSpace(A_LoopFileFullPath)
            oObject.CopyHere(oSource.Items, t)
        }
    }
}

CreateZip(n)    ; Create empty Zip file
{
    ZIPHeader1 := "PK" . Chr(5) . Chr(6)
    ZIPHeader2 := Buffer(18, 0)
    ZIPFile := FileOpen(n, "w")
    ZIPFile.Write(ZIPHeader1)
    ZIPFile.RawWrite(ZIPHeader2, 18)
    ZIPFile.close()
}

CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite := false)
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ErrorCount := 0
    ; First copy all the files (but not the folders):
    try
        FileCopy SourcePattern, DestinationFolder, DoOverwrite
    catch as Err
        ErrorCount := Err.Extra
    ; Now copy all the folders:
    Loop Files, SourcePattern, "D"  ; D means "retrieve folders only".
    {
        try
            DirCopy A_LoopFilePath, DestinationFolder "\" A_LoopFileName, DoOverwrite
        catch
        {
            ErrorCount += 1
            ; Report each problem folder by name.
            MsgBox "Could not copy " A_LoopFilePath " into " DestinationFolder
        }
    }
    return ErrorCount
}
