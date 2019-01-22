# Param( [string]$savePath, [switch]$once )

# $base = (get-item $savePath)

$base = Get-Location
$targetItem = Get-Item ($base)
Write-Host "Examining " + $targetItem
while ($targetItem.Name -ne "The Sims 3" -and $targetItem.FullName -ne $targetItem.Root) {
    $targetItem = $targetItem.Parent
    Write-Host "Examining " + $targetItem
}
if ($targetItem.FullName -eq $targetItem.Root) {
    Write-Host "Could not find 'The Sims 3' in " + $base
    Start-Sleep -Seconds 7
    Exit
}

Write-Host "Found " + $targetItem.FullName

read-host 'Press ENTER to continue...'  # aka Pause
