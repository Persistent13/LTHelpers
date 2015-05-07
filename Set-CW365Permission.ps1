<#
    The purpose of this script is to make permissions changes so connectwise
    may send as the new O365 account. Failure to make this change on the
    account will cause emails sent from the user to fail silently.
#>

#below gets the office 365 credentials
$O365Credential = Get-Credential
#below takes input for email alias
$O365Alias = Read-Host -Prompt "Email alias of the account"
#below sets up the remote session
$O365Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential $O365Credential -Authentication Basic -AllowRedirection

#below starts the remote session
Import-PSSession $O365Session
#below configured the access rights
Add-MailboxPermission -Identity $O365Alias -User CWAdmin -AccessRights FullAccess -InheritanceType All -Confirm $false
#below closes the remote session
Remove-PSSession -ComputerName "outlook.office365.com"