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

function FindThumbnails {
    param ( $root )
    $subDirs = @{
        Path = $root.FullName;
        Directory = $true
    }
    $thumbsDirs = (Get-ChildItem @subDirs).where({$_.Name -eq "Thumbnails"})
    $thumbnails = @()
    if ($thumbsDirs) {
        Write-Host "Thumbnails dir: $($thumbsDir.FullName)"
        $filter = @{
            root = $thumbsDirs[0].FullName;
            ext = "package";
            names = @("CASThumbnails.package", "ObjectThumbnails.package")
        }
        $thumbnails = FindCleanableFiles @filter
    }
    return $thumbnails
}

$sims3dir = FindEaSims3In .
Write-Host "Found $($sims3dir.FullName)"

$a = FindCacheFiles $sims3dir
Write-Host "Found files: $a"
$b = FindThumbnails $sims3dir
Write-Host "Found thumbnails: $b"

read-host 'Press ENTER to continue...'  # aka Pause
