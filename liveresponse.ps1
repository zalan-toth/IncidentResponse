
# =======================================================================================
# PRECONFIG
# =======================================================================================

#remote host for netcat to transfer live response data to the forensic workstation
$RemoteHost = "192.168.0.0"
#remote port for netcat
$RemotePort = 2222

#temporary location to put data before transfering to forensic workstation
$TempDir = "C:\WINDOWS\Temp"

#netcat location locally to use for sending out the data to the forensic workstation
$NetCatPath = "C:\netcat"


# =======================================================================================
# COLLECT DATA
# =======================================================================================

#Capture date and time and put it into a file in the temporary dir
Get-Date | Out-File "$TempDir\SysDate.txt"

#TODO 


# =======================================================================================
#COMBINDE DATA
# =======================================================================================
#TODO



# =======================================================================================
#TRANSFER TO FORENSIC WORKSTATION
# =======================================================================================

#netcat to transfer combined data
#TODO