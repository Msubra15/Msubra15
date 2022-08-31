$cred = get-credential JNJ\Admin_MSubra15

#Backend remote
{
$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred  #Please replace this with your Admin username (ex: JNJ\Admin_MSubra15)
}


Exit-pssession

#Check Reg Path
{
#$User = Get-ChildItem D:\Users -Name
$User = Read-Host 'Enter Username'
$objUser = New-Object System.Security.Principal.NTAccount($User)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
(Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($strSID.Value)" -Name ProfileImagePath).ProfileImagepath
}

#REFERENCE
{
Get-ChildItem 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList' | ForEach-Object { $_.GetValue('ProfileImagePath') }

$Ref = gwmi win32_userprofile | select localpath, sid

$env:USERPROFILE

Get-ChildItem "REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | 
  Where-Object {$_.Name -match "S-1-5-21"} | Select-Object -ExpandProperty ProfileImagePath


(gwmi win32_useraccount -Filter “sid = ‘S-1-5-21*'”).Caption

gwmi win32_userprofile | select localpath, sid
}


#Regkey check
{
$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred 
$Username = Read-Host "Enter Username"
$SID = (gwmi win32_useraccount -Filter "name = '$Username'").SID
$Regkeyvalue = (Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Name ProfileImagePath).ProfileImagepath

If ($Regkeyvalue = "c:\Users\$Username")
{

Set-Itemproperty -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID" -Name ProfileImagePath -value "D:\Users\$Username"

}
}

$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred

gwmi win32_userprofile | select localpath, sid


Exit-pssession







#########################################################################


$cred = get-credential JNJ\Admin_Msubra15



{
$ComputerName = Read-Host 'Enter Computername'
Enter-PSSession $ComputerName -Credential $cred
}



gwmi win32_userprofile | select localpath, sid

gwmi win32_userprofile | Select-Object -Property PSComputerName, LocalPath | where {($_.LocalPath -notlike "*Windows*") -and ($_.LocalPath -notlike "*admin_*") }



reg.exe import "C:\Program Files\Amazon\WorkSpacesConfig\Backup\profileImagePathD.reg"


Exit-pssession 


#Check user profile regkey in bulk

$cred = get-credential JNJ\Admin_MSubra15
$computers = Get-Content -Path C:\Temp\Computers.txt
Invoke-Command -ComputerName $computers -Credential $cred -ScriptBlock {

gwmi win32_userprofile | Select-Object -Property PSComputerName, LocalPath | where {($_.LocalPath -notlike "*Windows*") -and ($_.LocalPath -notlike "*admin_*") }
}

#Update user profile regkey in bulk

$cred = get-credential JNJ\Admin_MSubra15
$computers = Get-Content -Path C:\Temp\Computers.txt
Invoke-Command -ComputerName $computers -Credential $cred -ScriptBlock {

reg.exe import "C:\Program Files\Amazon\WorkSpacesConfig\Backup\profileImagePathD.reg"
}