function Add-UsersToDL {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of user email addresses to add to mailbox. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmails,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Single shared mailbox to add users to. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$distributionList
    )

    $userArr = ($userEmails -split ',').Trim()

    # Add each user to the distribution list
    foreach ($user in $userArr) {
        try {
            Add-DistributionGroupMember -Identity $distributionList -Member $user -BypassSecurityGroupManagerCheck
        } catch {
           Write-Host "Failed to add $user to $distributionList"
        }
    }

    # Prompt user to display all distribution list members
    Write-Host "Enter 'y' to display all members of $distributionList"
    $displayDL = Read-Host "Continue"
    if ($displayDL -eq "(?i)y") {
        Get-DistributionGroupMember -Identity $distributionList -ResultSize | Select-Object DisplayName, PrimarySmtpAddress, RecipientType
    } 
}