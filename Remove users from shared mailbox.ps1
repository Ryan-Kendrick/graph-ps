function Remove-UsersFromSM {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of user email addresses to remove from mailbox. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmails,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Single shared mailbox to remove users from. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$mailbox
    )

    $userArr = ($userEmails -split ',').Trim()

    # Remove each user from the shared mailbox
    foreach ($user in $userArr) {
        Remove-MailboxPermission -Identity $mailbox -User $user
    }

    # Display mailbox permissions after change
    Get-MailboxPermission -Identity $mailbox | Select-Object Identity, User, AccessRights -ExpandProperty AccessRights
}