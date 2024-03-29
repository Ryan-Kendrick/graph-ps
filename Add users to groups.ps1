

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

# get-mggroup -filter "DisplayName eq 'tg-3'"

Connect-MgGraph -NoWelcome -Scopes GroupMember.ReadWrite.All, User.Read.All

$users = "ryan.kendrick93@gmail.com", "Ryan@givecredit.onmicrosoft.com", "RyanK@give-credit.co.nz", "fleeterson@gmail.com"
$groups = "TG-1", "TG-2", "TG-3", "TG-4"
$userIds = @()
$groupIds = @()

foreach ($user in $users) {
    $thisId = (Get-MgUser -Filter "mail eq '$user'").Id
    if (($null -ne $thisId) -and ($thisId -is [string])) {
        $userIds += $thisId
    } else {
        Throw "User `"$user`" not found, operation aborted"
    } 
}

foreach ($group in $groups) {
    $thisId = (Get-MgGroup -Filter "DisplayName eq '$group'").Id
    if (($null -ne $thisId) -and ($thisId -is [string])) {
        $groupIds += $thisId
    } else {
        Throw "Group `"$group`" not found, operation aborted"
    } 
}

foreach ($groupId in $GroupIds) {
    Get-MgGroup -Filter "Id eq '$groupId'"
    foreach ($userId in $userIds) {
        New-MgGroupMember -GroupId "$groupId" -DirectoryObjectId "$userId"
    }
    Get-MgGroup -Filter "Id eq '$groupId'"
}



Write-Host "$userIds"
Write-Host "$groupIds"