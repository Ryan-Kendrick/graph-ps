function Add-UsersToSM {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of user email addresses to add to mailbox. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmails,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Single shared mailbox to add users to. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$mailbox
    )

    Write-Host "Add 'Send as' permission?"
    Write-Host "Enter 1 to add sending permission"
    Write-Host "Enter 2 to skip adding sending permission"

    while ($sendPermission -notmatch "1|2") {$sendPermission = Read-Host "Option"}
    
    if ($sendPermission -eq '1') {
        $sendPermission = SendAs        
    } else {
        $sendPermission = $null
    }
    Write-host "send is $sendPermission"
    $userArr = ($userEmails -split ',').Trim()

    # Add each user to the shared mailbox
    foreach ($user in $userArr) {
        Add-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess -Automapping $true
        Add-RecipientPermission $mailbox -Trustee $user -AccessRights $sendPermission -Confirm:$false
    }

    # Display mailbox permissions after change
    Get-MailboxPermission -Identity $mailbox | Select-Object Identity, User, AccessRights -ExpandProperty AccessRights
}