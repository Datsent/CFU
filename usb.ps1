#Requires -version 2.0
# Run two lines below in PowerShell as administrator
# Get-ExecutionPolicy
# Set-ExecutionPolicy RemoteSigned

Register-WmiEvent -Class win32_VolumeChangeEvent -SourceIdentifier volumeChange
write-host (get-date -format s) " Beginning script..."
do{
$newEvent = Wait-Event -SourceIdentifier volumeChange
$eventType = $newEvent.SourceEventArgs.NewEvent.EventType
$eventTypeName = switch($eventType)
{
1 {"Configuration changed"}
2 {"Device arrival"}
3 {"Device removal"}
4 {"docking"}
}
write-host (get-date -format s) " Event detected = " $eventTypeName
if ($eventType -eq 2)
{
$driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
$driveLabel = ([wmi]"Win32_LogicalDisk='$driveLetter'").VolumeName
write-host (get-date -format s) " Drive name = " $driveLetter
write-host (get-date -format s) " Drive label = " $driveLabel
# Execute process if drive matches specified condition(s)
if ($eventTypeName -eq 'Device arrival' -and $driveLabel -ne 'EXTRAEYE')
{
    [reflection.assembly]::loadwithpartialname('System.Windows.Forms')
    [reflection.assembly]::loadwithpartialname('System.Drawing')
    $notify = new-object system.windows.forms.notifyicon
    $notify.icon = [System.Drawing.SystemIcons]::Information
    $notify.visible = $true
    $notify.showballoontip(10000,'Process Started','Coping process in work',[system.windows.forms.tooltipicon]::Info)
    Write-Host (get-date -format s) 'Coping files...'
    Copy-Item -Path "$driveLetter\*" -Destination "C:\Users\$env:UserName\Desktop\CopiedFiles" -Recurse
    Write-Host (get-date -format s) 'Coping complited!'
    Write-Host (get-date -format s) 'Formating Disk...'
    $string = $driveLetter -replace “.$”
    Format-Volume -DriveLetter $string -FileSystem FAT32 -Force
    Write-Host (get-date -format s) 'Format complited!'
    Write-Host (get-date -format s) 'Ejecting'
    Start-Sleep -Seconds 3
    $driveEject = New-Object -comObject Shell.Application
    $driveEject.Namespace(17).ParseName($driveLetter).InvokeVerb("Eject")
    Write-Host (get-date -format s) 'Ejected'
    $notify.showballoontip(10000,'Process Copleted','You can remove flash drive',[system.windows.forms.tooltipicon]::Info)
    ii C:\Users\$env:UserName\Desktop\CopiedFiles
}
}
Remove-Event -SourceIdentifier volumeChange
} while (1-eq1) #Loop until next event
Unregister-Event -SourceIdentifier volumeChange
