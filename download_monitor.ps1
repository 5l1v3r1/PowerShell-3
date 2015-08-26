# Figure out adding -Action for Register-WmiEvent

$query = @" 
 Select * from __InstanceCreationEvent within 5  
 where targetInstance isa 'Cim_DirectoryContainsFile'  
 and targetInstance.GroupComponent = 'Win32_Directory.Name="c:\\\\test"' 
"@ 
Register-WmiEvent -Query $query -SourceIdentifier "MonitorFiles" -Action 
$fileEvent = Wait-Event -SourceIdentifier "MonitorFiles" 
$name = ($fileEvent.SourceEventArgs.NewEvent.TargetInstance.PartComponent).split('"')[1]
$md5 = (get-filehash $name -Algorithm MD5).hash
$sha256 = (get-filehash $name -Algorithm SHA256).hash

$wscript = New-Object -ComObject Wscript.Shell
$wscript.Popup("Downloaded File: $name MD5: $md5 SHA256: $sha256",0,"Done",0x1)



Get-EventSubscriber | Unregister-Event 
Get-Event | Remove-Event 

