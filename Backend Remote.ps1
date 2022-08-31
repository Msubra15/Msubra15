# Store Credentials
$cred = get-credential JNJ\Admin_MSubra15


#Take Backend PS session with admin previlages
{
$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred  #Please replace this with your Admin username (ex: JNJ\Admin_MSubra15)
}

Get-PSDrive | ? { $_.Provider.Name -eq 'FileSystem' }

Exit-Pssession

Get-Package -Provider Programs -IncludeWindowsInstaller -Name "PCoIP Standard Agent" | Select-Object -Property Name, Version

Set-ExecutionPolicy 

cd "C:\Program Files\Amazon\WorkSpacesConfig\Scripts"
.\update-pcoip-agent.ps1


Get-EventLog -LogName Application -EntryType Error -Message *PCOIP* -Newest 30

Get-EventLog -LogName System -EntryType Error -Message *SkyLight* -Newest 30

#Event Logs

Get-EventLog -LogName System -EntryType Error -Message *STXHD* -Newest 30

Get-EventLog -LogName System -EntryType Error -Newest 20

Get-EventLog -LogName Application -EntryType Error -Newest 50


(Get-WinEvent -ListProvider * -ComputerName DESKTOP-A2F09DN).Events



# DNS Server Value
{
$Ref1=(Get-DnsClient -ConnectionSpecificSuffix "jnj.com").InterfaceAlias
$Output = (Get-DnsClientServerAddress -InterfaceAlias "$Ref1" -AddressFamily IPv4).ServerAddresses
$Output
}

#Exit out of backend PS Session 

Exit-pssession

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


$computers = Get-Content -Path C:\Temp\Computers.txt
Invoke-Command -ComputerName $computers -Credential $cred -ScriptBlock {
$Ref1=(Get-DnsClient -ConnectionSpecificSuffix "jnj.com").InterfaceAlias
$Output= (Get-DnsClientServerAddress -InterfaceAlias "$Ref1" -AddressFamily IPv4).ServerAddresses
$Hostname = hostname
$Region=nltest /dsgetsite
$RegionID=$Region.Trim("The command completed successfully").Trim( )
$Result = "$Hostname $RegionID $Output"
Write-Host $Result

[PSCustomobject]@{
'Machine Name' = $Hostname
'Region ID' = $RegionID
'DNS Server IP' = $Output
 } 
 } | Export-CSV C:\Temp\yourcsv.csv -notype -Append 
 
 

 [PSCustomobject]@{
'Machine Name' = (@($Hostname) -join '')
'Region ID' = (@($RegionID) -join '')
'DNS Server IP' = (@($Output) -join ',')
 } | Export-CSV C:\Temp\yourcsv.csv -notype -Append 
 }
 
 

 $Data | Select-Object 'Machine Name','Region ID','DNS Server IP'
 
 $Data | Export-Csv C:\Temp\yourcsv.csv -notype -Append 
 }
 


$Data = [PSCustomobject]@{
'Machine Name' = (@($Hostname) -join '')
'Region ID' = (@($RegionID) -join '')
'DNS Server IP' = (@($Output) -join ',')
 }
 $Data | Select-Object - 'Machine Name','Region ID','DNS Server IP'
}



########################################################################

$DNSServer=@{ 

}
$MyObject = New-Object -TypeName psobject -Property $DNSServer
$FilePath = "C:\Temp\DNS.csv"
$MyObject | Export-Csv $FilePath -NoTypeInformation 


#DNSServerIP | export-csv DNSIP.CSV
$FilePath = "$env:USERPROFILE\Desktop\test4.csv" 

$MyObject | Export-Csv $FilePath -NoTypeInformation
$Props = @{
    "Date" = Get-Date -Format f
    "Computer Name" = $env:COMPUTERNAME
    "Username" = $env:USERNAME
    "Domain" = $env:USERDNSDOMAIN
}

$MyObject = New-Object -TypeName psobject -Property $Props


#Check if PCOIP counter are available in the worksapce

Get-Counter -ListSet * | Select-Object -Property CounterSetName | Where-Object { $_ -like "*PCOIP*" }


$Ref1=(Get-DnsClient -ConnectionSpecificSuffix "jnj.com").InterfaceAlias
(Get-DnsClientServerAddress -InterfaceAlias "$Ref1" -AddressFamily IPv4).ServerAddresses


get-childitem -Path 'HKLM:\SOFTWARE\Amazon\WorkSpacesConfig'
get-itemproperty -Path 'HKLM:\SOFTWARE\Amazon\WorkSpacesConfig\update-webaccess.ps1'
(Get-Service -Name spacedeskHookKmode).StartType
(Get-Service -Name Stxhd.HostAgents.HAService).StartType


############################################################################################

#Backend remote

$cred = get-credential JNJ\Admin_MSubra15

{
$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred  #Please replace this with your Admin username (ex: JNJ\Admin_MSubra15)
}

Get-Service -Name "Skylight Metrics Agent"


# DNS Server Value
{
C:\WINDOWS\System32\nltest /dsgetsite
(Get-ItemProperty -Path HKLM:\SOFTWARE\Amazon\SkyLight -Name DomainJoinDNS).DomainJoinDNS
}

Exit-pssession

# US EAST - 10.37.118.42 , 10.54.30.25
{
Set-ItemProperty -Path HKLM:\SOFTWARE\Amazon\SkyLight -Name DomainJoinDNS -Value "10.59.8.6,10.255.255.10" 
restart-service -Name SkyLightWorkspaceConfigService
}

# EU-WEST-1 - 10.157.55.9, 10.128.0.21
{
Set-ItemProperty -Path HKLM:\SOFTWARE\Amazon\SkyLight -Name DomainJoinDNS -Value "10.157.91.6,10.172.106.70" 
restart-service -Name SkyLightWorkspaceConfigService
}

#AP-SOUTHEAST-1 - 10.221.26.183, 10.203.136.25
{
Set-ItemProperty -Path HKLM:\SOFTWARE\Amazon\SkyLight -Name DomainJoinDNS -Value "10.221.46.6,10.255.255.10" 
restart-service -Name SkyLightWorkspaceConfigService
}


# STXHD Reg Key Check
{
$Key = Test-Path HKEY_LOCAL_MACHINE\SOFTWARE\Amazon\WorkSpacesConfig\update-webaccess.ps1
$Hostname = hostname
Write-Host $Hostname $Key 
}

#Exit out of backend PS Session 
set-location C:\Windows\System32

C:\WINDOWS\System32\nltest /dsgetsite

$Env:Path

Exit-pssession

Enable-WSManCredSSP -Role Client -DelegateComputer DESKTOP-8KOT5QS

############################################################

$logs = get-eventlog -Logname System -source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-7)
$res = @(); ForEach ($log in $logs) {if($log.instanceid -eq 7001) {$type = "Logon"} Elseif ($log.instanceid -eq 7002){$type="Logoff"} Else {Continue} $res += New-Object PSObject -Property @{Time = $log.TimeWritten; "Event" = $type; User = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}};
$res

$logs = Get-eventlog -LogName System -Source Microsoft-Windows-Winlogon
$res = @(); ForEach ($log in $logs) {if($log.instanceid -eq 7001) {$type = "Logon"} Elseif ($log.instanceid -eq 7002){$type="Logoff"} Else {Continue} $res += New-Object PSObject -Property @{Time = $log.TimeWritten; "Event" = $type; User = (New-Object System.Security.Principal.SecurityIdentifier $Log.ReplacementStrings[1]).Translate([System.Security.Principal.NTAccount])}};
$res