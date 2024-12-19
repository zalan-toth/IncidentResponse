
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
$NetCatPath = "C:\netcat"


# =======================================================================================
# COLLECT DATA
# =======================================================================================

#Capture date and time and put it into a file in the temporary dir
Get-Date | Out-File "$TempDir\SysDate.txt"

#check open ports
netstat -an | Out-File "$TempDir\OpenPorts.txt"

#map executables to open ports
netstat -abno | Out-File "$TempDir\MappedPorts.txt"

#TODO 


# =======================================================================================
# COMBINE DATA
# =======================================================================================
$CombinedData = "$TempDir\FullData.txt"
#TODO combine all files



# =======================================================================================
# TRANSFER TO FORENSIC WORKSTATION
# =======================================================================================

#netcat to transfer combined data
Get-Content $CombinedData | & $NetCatPath $RemoteHost $RemotePort
#TODO


# =======================================================================================
# CLEANUP TEMPORARY FILES
# =======================================================================================
#TODO