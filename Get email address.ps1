function Get-EmailAddress {
    param (
        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Comma separated list of display names to fetch email addresses for. Must be in quotes")]
        [string]$names
    )

    $namesArr = ($names -split ',').Trim()

    $emailsArr = @()
    $ambiguousResults = $false

    foreach ($name in $namesArr) {

      # Fetch the email address property for each display name provided
      $userEmail = (Get-MgUser -Filter  "displayname eq '$name'").mail

      if ($userEmail) {

        # Add the email address property to the results array as appropriate for one, multiple, or no matches
        if ($userEmail.GetType().name -eq "Object[]") {
          $ambiguousResults = $true
          $emailsArr += [PSCustomObject][Ordered]@{
            DisplayName = $name
            EmailAddress = $userEmail -join ', '
          }
        } elseif ($userEmail.GetType().name -eq "String") {
          $emailsArr += [PSCustomObject][Ordered]@{
            DisplayName = $name
            EmailAddress = $userEmail
          }
        }
      } else {
      $emailsArr += [PSCustomObject][Ordered]@{
        DisplayName = $name
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