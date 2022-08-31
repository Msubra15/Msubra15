$cred = get-credential JNJ\Admin_MSubra15

$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred

$logfilepath ="C:\Temp\Log.txt"

function NetworkInfo {

Write-Output "-----------------------------------------------------------"
Write-Output "           AWS Workspace Public IP Information             "
Write-Output "-----------------------------------------------------------"

Invoke-RestMethod -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content) 


Write-Host -nonewline "Run TCP port test to remote host? (Y/N) "
$response = read-host
if ( $response -ne "Y" ) { exit }

Write-Output "-----------------------------------------------------------"
Write-Output "           Remote Host Testing Information Below           "
Write-Output "-----------------------------------------------------------"

$RemoteComputer = Read-Host 'Enter IP or Name to Test'
$RemotePort = Read-Host 'Enter Port to Test'

Test-NetConnection $RemoteComputer -Port $RemotePort # -InformationLevel Quiet


Write-Host -nonewline "Run Traceroute to remote host? (Y/N) "
$response = read-host
if ( $response -ne "Y" ) { exit }



Write-Output "----------------------------------------------------------------"
Write-Output "   Traceroute to Remote Device -- Manually Stop with Control C  "
Write-Output "----------------------------------------------------------------"

tracert $RemoteComputer

}

$Ref = NetworkInfo

Echo $Ref

$Ref | Out-File c:\Temp\Log.txt


Exit-pssession

 