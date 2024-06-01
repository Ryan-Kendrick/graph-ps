function Add-GuestUsers {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of user email addresses to add to mailbox. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmails,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Single shared mailbox to add users to. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$mailbox
    )

    $userArr = ($userEmails -split ',').Trim()

    # Add each user to the shared mailbox with sendas permission
    foreach ($user in $userArr) {
        Add-MailboxPermission -Identity $mailbox -User $user -AccessRights FullAccess
        Add-RecipientPermission $mailbox -Trustee $user -AccessRights SendAs -Confirm:$false
    }

    # Display mailbox permissions after change
    Get-MailboxPermission -Identity $mailbox | Select-Object Identity, User, AccessRights -ExpandProperty AccessRights
}