function Add-UsersToSM {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of user email addresses to add to mailbox. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmails,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Single shared mailbox to add users to. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$mailbox
    )

    $userArr = ($userEmails -split ',').Trim()

    # Prompt user for send permission
    Write-Host "Add 'Send as' permission for each user?"
    Write-Host "Enter 1 to add sending permission"
    Write-Host "Enter 2 to skip adding sending permission"
    do {$sendPermission -notmatch "^[12]$"} while ($sendPermission = Read-Host "Option")

    if ($sendPermission -eq 1) {
        $sendPermission = @{AccessRights = 'SendAs'}
    } else {
        $sendPermission = @{AccessRights = $null}
    }

    # Add each user to the shared mailbox
    foreach ($user in $userArr) {
        try {
            Add-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess -Automapping $true
        } catch {
           Write-Host "Failed to add $user to $mailbox"
        }
        Add-RecipientPermission $mailbox -Trustee $user @sendPermission -Confirm:$false
    }

    # Display mailbox permissions after change
    Get-MailboxPermission -Identity $mailbox | Select-Object Identity, User, AccessRights -ExpandProperty AccessRights
}