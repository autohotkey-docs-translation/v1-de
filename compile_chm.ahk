; Change this path if the loop below doesn't find your hhc.exe,
; or leave it as-is if hhc.exe is somewhere in %PATH%.
hhc := "hhc.exe"

; Try to find hhc.exe, since it's not in %PATH% by default.
for i, env_var in ["ProgramFiles", "ProgramFiles(x86)", "ProgramW6432"]
{
    EnvGet Programs, %env_var%
    if (Programs && FileExist(checking := Programs "\HTML Help Workshop\hhc.exe"))
    {
        hhc := checking
        break
    }
}

; Convert UTF-8 to ISO-8859-1 because chm doesn't support UTF-8
TempDir := A_Temp "\compile_chm"
FileCreateDir, % TempDir
FileCopyDir, % A_ScriptDir, % TempDir, 1
FileEncoding, UTF-8
Loop, % TempDir "\*.htm",, 1
{
    FileRead, filecontent, % A_LoopFileLongPath
    StringReplace, filecontent, filecontent, "text/html; charset=UTF-8", "text/html; charset=ISO-8859-1"
    FileDelete, % A_LoopFileLongPath
    FileAppend, % filecontent, % A_LoopFileLongPath, CP28591
}

; Rebuild Index.hhk and Table of Contents.hhc.
RunWait "%A_AhkPath%" "%TempDir%\static\source\CreateFiles4Help.ahk"

; Compile AutoHotkey.chm.
RunWait %hhc% "%TempDir%\Project.hhp"

FileMove, %TempDir%\AutoHotkey.chm, %A_ScriptDir%\AutoHotkey.chm, 1

FileRemoveDir, % TempDir, 1
