

# Some code to derive a solution from:

# Import a CSV with the list of comps to be added to the group (update <path>)

# $computers = Import-Csv -Path "C:\working\aad-forceDevicesAutoUpdateList1.csv" | Select-Object -ExpandProperty ComputerName

# $groupName = "testdelete"

# #================================================================== # Connect to Microsoft Graph with comp read/write permissions

# Connect-MgGraph -Scopes GroupMember.ReadWrite.All, Device.ReadWrite.All

# $group = Get-MgGroup -Filter "DisplayName eq '$groupName'" -ConsistencyLevel eventual

# try {

# foreach ($computer in $computers) { $device = Get-MgDevice -Filter "DisplayName eq '$computer'"
# Write-host "Adding comp $($comp)to $($group.DisplayName)" -ForegroundColor Green

# # object IT, not the device id

# New-MgGroupMember -GroupId $group.id -DirectoryObjectId $device.id }
# }

# catch { Write-Host "Error getting information for $computer $_"
# }
# ----------
# $continue = Read-Host "Adding $users to $groups, press y to continue or n to cancel"
# $groupId = Get-MgGroup -Filter "DisplayName eq 'Leadership Team'"