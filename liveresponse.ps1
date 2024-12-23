
# =======================================================================================
# PRECONFIG
# =======================================================================================

#remote host for netcat to transfer live response data to the forensic workstation
$RemoteHost = "192.168.0.0"
#remote port for netcat
$RemotePort = 2222

#temporary location to put data before transfering to forensic workstation
$TempDir = "C:\WINDOWS\Temp\IR"

#netcat location locally to use for sending out the data to the forensic workstation
$NetCatPath = "C:\Trusted\NetCat\t_nc.exe"

#Other locations
$ProcDump = "C:\Trusted\ProcDump\ProcDump.exe"
$PsLoggedOn = "C:\Trusted\PSTools\PsLoggedOn.exe"
$PsFile = "C:\Trusted\PSTools\PsFile.exe"
$PsList = "C:\Trusted\PSTools\PsList.exe"
$PsService = "C:\Trusted\PSTools\PsService.exe"

$PsInfo = "C:\Trusted\PSTools\PsInfo.exe"
$PsLogList = "C:\Trusted\PSTools\PsLogList.exe"

# =======================================================================================
# COLLECT DATA
# =======================================================================================

#Capture date and time and put it into a file in the temporary dir
Get-Date | Out-File "$TempDir\SysDate.txt"

#check open ports
Get-NetTCPConnection | Out-File "$TempDir\NetworkConnections.txt"
netstat -an | Out-File "$TempDir\OpenPorts.txt"

#map executables to open ports
netstat -abno | Out-File "$TempDir\MappedPorts.txt"

#netbios name cache
nbtstat -c | Out-File "$TempDir\NetBIOSCache.txt"

#Logged on users
& $PsLoggedOn | Out-File "$TempDir\LoggedOnUsers.txt"

#Routing table
netstat -rn | Out-File "$TempDir\RoutingTable.txt"

#Running processes
& $PsList | Out-File "$TempDir\Processes.txt"

#Running services
& $PsService | Out-File "$TempDir\Services.txt"

#Open Files
& $PsFile | Out-File "$TempDir\OpenFiles.txt"

#Get scheduled tasks
Get-ScheduledTask | Out-File "$TempDir\ScheduledTasks.txt"

#TODO Memory dumps 
$Processes = Get-Process
foreach ($Process in $Processes) {
    $DumpFile = "$TempDir\$($Process.Id)_$($Process.ProcessName).dmp"
    & $ProcDump -ma $Process.Id $DumpFile 2>&1 | Out-Null
}

#NON VOLATILE
#timestamp 
Get-ChildItem | Out-File "$TempDir\Dir.txt"
#Get-ChildItem is the same as dir

#System version and patch level
& $PsInfo | Out-File "$TempDir\PsInfo.txt"

#System logs
& $PsLogList -s -x security | Out-File "$TempDir\SystemEvents.txt"

#Get registry data https://learn.microsoft.com/en-us/windows/win32/wmisdk/obtaining-registry-data 

# =======================================================================================
# COMBINE DATA
# =======================================================================================
$CombinedData = "$TempDir\Final\FullData.txt"
#TODO combine all files
Get-ChildItem -Path $TempDir -Filter *.txt | ForEach-Object {
    Get-Content $_.FullName | Add-Content -Path $CombinedData
}


# =======================================================================================
# TRANSFER TO FORENSIC WORKSTATION
# =======================================================================================

#netcat to transfer combined data
Get-Content $CombinedData | & $NetCatPath $RemoteHost $RemotePort


# =======================================================================================
# CLEANUP TEMPORARY FILES
# =======================================================================================
#TODO