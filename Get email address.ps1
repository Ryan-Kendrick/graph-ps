function Get-EmailAddress {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of display names to fetch email addresses for. Must be in quotes")]
        [string]$names
    )

    $namesArr = ($names -split ',').Trim()

    $emailsArr = @()
    $ambiguousResults = $false

    foreach ($providedName in $namesArr) {

      # Fetch the email address property for each display name provided
      $user = (Get-MgUser -Filter  "startsWith(DisplayName, '$providedName')" -Limit 3)
      

      if ($user) {
        $userEmail = $user.mail

        # Add the email address property to the results array as appropriate for one, multiple, or no matches
        if ($userEmail.GetType().name -eq "Object[]") {
          $ambiguousResults = $true
          $emailsArr += [PSCustomObject][Ordered]@{
            DisplayName = $providedName
            EmailAddress = $userEmail -join ', '
          }
        } elseif ($userEmail.GetType().name -eq "String") {
          $emailsArr += [PSCustomObject][Ordered]@{
            DisplayName = $user.DisplayName
            EmailAddress = $userEmail
          }
        }
      } else {
      $emailsArr += [PSCustomObject][Ordered]@{
        DisplayName = $providedName
        EmailAddress = 'not found'
        }
      }
      
    }

    # Display the results array of objects as a table
    $emailsArr | Format-Table
    if ($ambiguousResults) {
      Write-Host "Multiple potential matches found for some names. Verify which account is correct before proceeding."
    }

}