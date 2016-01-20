#NoEnv
SetBatchLines, -1
SetWorkingDir, % A_ScriptDir

if (A_PtrSize = 8) {
    try
        RunWait "%A_AhkPath%\..\AutoHotkeyU32.exe" "%A_ScriptFullPath%"
    catch
        MsgBox 16,, This script must be run with AutoHotkey 32-bit, due to use of the ScriptControl COM component.
    ExitApp
}

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

; Convert files to ISO-8859-1 because chm doesn't support UTF-8
TempDir := A_Temp "\compile_chm\"

FileCreateDir, % TempDir
Loop, Files, *.*, DR
    if !(A_LoopFileFullPath ~= ".git")
        FileCreateDir, % TempDir A_LoopFileFullPath

FileEncoding, UTF-8
Loop, Files, *.*, FR
{
    if (A_LoopFileExt = "htm")
    {
        FileRead, filecontent, % A_LoopFileLongPath
        StringReplace, filecontent, filecontent, "text/html; charset=UTF-8", "text/html; charset=ISO-8859-1"
        FileAppend, % filecontent, % TempDir A_LoopFileFullPath, CP28591
    }
    else
        FileCopy, % A_LoopFileLongPath, % TempDir A_LoopFileFullPath
}

; Rebuild Index.hhk and Table of Contents.hhc.
RunWait "%A_AhkPath%" "%TempDir%static\source\CreateFiles4Help.ahk"
RunWait "%A_AhkPath%" "static\source\CreateFiles4Help.ahk"

; Compile AutoHotkey.chm.
RunWait %hhc% "%TempDir%\Project.hhp"

FileMove, %TempDir%\AutoHotkey.chm, %A_ScriptDir%\AutoHotkey.chm, 1

FileRemoveDir, % TempDir, 1