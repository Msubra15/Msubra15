set-executionpolicy bypass
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline
Get-InboxRule | Export-Csv -NoTypeInformation "$HOME\Downloads\rules.csv"

Get-InboxRule –Mailbox msubra15@its.jnj.com | Select Name, Description | FL

Get-ManagementRoleAssignment -RoleAssignee msubra15@its.jnj.com -Delegating $false | Format-Table -Auto Role,RoleAssigneeName,RoleAssigneeType