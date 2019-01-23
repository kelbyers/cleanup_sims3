# Param( [string]$savePath, [switch]$once )

# $base = (get-item $savePath)

function FindEaSims3In($base) {
    $targetItem = Get-Item ($base)
    Write-Host "Examining $targetItem"
    while ($targetItem.Name -ne "The Sims 3" `
            -and $targetItem.FullName -ne $targetItem.Root) {
        $targetItem = $targetItem.Parent
        Write-Host "Examining $($targetItem.FullName)"
    }
    if ($targetItem.FullName -eq $targetItem.Root) {
        Write-Host "Could not find 'The Sims 3' in $base"
        read-host 'Press ENTER to continue...'  # aka Pause
        Exit
    }
    return $targetItem
}

$sims3dir = FindEaSims3In .
Write-Host "Found $($sims3dir.FullName)"

read-host 'Press ENTER to continue...'  # aka Pause
