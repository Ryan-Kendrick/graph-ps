function Remove-UsersFromDL {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of user email addresses to remove from distribution list. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$userEmails,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Single distribution list to remove users from. Must be in quotes")]
        [ValidateNotNullOrEmpty()]
        [string]$distributionList
    )

    $userArr = ($userEmails -split ',').Trim()

    # Remove each user from the distribution list
    foreach ($user in $userArr) {
        try {
            Remove-DistributionGroupMember -Identity $distributionList -Member $user -BypassSecurityGroupManagerCheck
        } catch {
           Write-Host "Failed to remove $user from $distributionList"
        }
    }

    # Prompt user to display all distribution list members
    Write-Host "Enter 'y' to display all members of $distributionList"
    $displayDL = Read-Host "Continue"
    if ($displayDL -eq "(?i)y") {
        Get-DistributionGroupMember -Identity $distributionList | Select-Object DisplayName, PrimarySmtpAddress, RecipientType
    } 
}