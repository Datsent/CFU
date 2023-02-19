Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "PATH TO <start.bat>" & Chr(34), 0
Set WinScriptHost = Nothing