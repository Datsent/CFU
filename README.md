# CFU
Script by PowerShell for copy and format flash drive.

## Description

 - Skript triggered by inserting USB flash in to PC.
 - Automaticly copy files in flash to path directory. Default user Desktop in folder CopiedFiles.
 - After copy, format USB flash drive and eject it.
 - For Windows systems

## Deployment

To deploy this project run

```bat
  start.bat 
```

## Before Using do the next changes:

### File start.vbs
```vb
Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "PATH TO <start.bat>" & Chr(34), 0
Set WinScriptHost = Nothing
```
- Replace PATH TO with path to file start.bat.

### File start.bat
```bat
Powershell -executionpolicy remotesigned -File  PATH TO <usb.ps1> > PATH TO <log.log>
```
- Replace PATH TO with path to file usb.ps1 and to log.log.

## Support

For some error of Authorization run two lines below in PowerShell as administrator:
```PowerShell
Get-ExecutionPolicy
```
```PowerShell
Set-ExecutionPolicy RemoteSigned
```
