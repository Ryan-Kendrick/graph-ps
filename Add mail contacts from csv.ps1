function Add-CsvMailContacts{
  param (
      [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Path to the csv file")]
      [ValidateNotNullOrEmpty()]
      [string]$csvPath
  )

  Import-Csv $csvPath | ForEach-Object {

    $props = @{
        Name = ($_.DisplayName.Trim())
        DisplayName = "$($_.DisplayName.Trim()) (EXT $($_.Organisation))"
        ExternalEmailAddress = $_.ExternalEmailAddress.Trim()
    }

    Write-Host "Adding contact for $($_.DisplayName) with email address $($_.ExternalEmailAddress)"
    try {
        New-MailContact @props
    } catch {
        Write-Host "Failed for $($_.DisplayName)"
    }

  }
}