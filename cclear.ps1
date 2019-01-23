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

function FindCleanableFiles {
    param (
        $root,
        $ext,
        [array]$names
    )
    $allFiles = Get-ChildItem -Path $root -Filter *.$ext -File
    Write-Host "`$allFiles = $allFiles"
    $allFiles.where({ $names.Contains($_.Name) })
}

function FindCacheFiles {
    param ( $root )
    $cacheFilter = @{
        root = $root.FullName;
        ext = "package";
        names = @( "CASPartCache.package", "compositorCache.package",
            "scriptCache.package", "simCompositorCache.package",
            "socialCache.package" )
    }
    FindCleanableFiles @cacheFilter
}

$sims3dir = FindEaSims3In .
Write-Host "Found $($sims3dir.FullName)"

$a = FindCacheFiles $sims3dir
Write-Host "Found files: $a"

read-host 'Press ENTER to continue...'  # aka Pause
