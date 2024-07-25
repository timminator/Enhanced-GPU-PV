Set objShell = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
objFolder = fso.GetParentFolderName(WScript.ScriptFullName)
objShell.Run "cmd.exe /c """ & objFolder & "\Switch Display to ParsecVDA.bat""", 0, False