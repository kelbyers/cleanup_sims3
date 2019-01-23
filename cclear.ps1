# Clean up caches, dumps, etc., before starting The Sims 3

function FindEaSims3In($base) {
    $targetItem = Get-Item ($base)
    while ($targetItem.Name -ne "The Sims 3" `
            -and $targetItem.FullName -ne $targetItem.Root) {
        $targetItem = $targetItem.Parent
    }
    if ($targetItem.FullName -eq $targetItem.Root) {
        Write-Host "Could not find 'The Sims 3' in $base"
        read-host 'Press ENTER to continue...'  # aka Pause
        Exit
    }
    return $targetItem
}

function FindSubdir {
    param ( $root, $name )
    $subDirs = @{
        Path = $root.FullName;
        Directory = $true
    }
    $subDirs = (Get-ChildItem @subDirs)
    $mySubdirs = $subDirs.where({$_.Name -eq $name})
    if ($mySubdirs) {
        return $mySubdirs[0]
    } else {
        return ""
    }
}

function FindFilesByFilter {
    param (
        $root,
        $filter
    )
    Get-ChildItem -Path $root -Filter $filter -File
}

function FindCleanableFiles {
    param (
        $root,
        $ext,
        [array]$names
    )
    $allFiles = FindFilesByFilter $root "*.$ext"
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
    $thumbsDir = FindSubdir $root Thumbnails
    $thumbnails = @()
    if ($thumbsDir) {
        $filter = @{
            root = $thumbsDir.FullName;
            ext = "package";
            names = @("CASThumbnails.package", "ObjectThumbnails.package")
        }
        $thumbnails = FindCleanableFiles @filter
    }
    return $thumbnails
}

function FindDCBackups {
    param ( $root )
    $dcbDir = FindSubdir $root DCBackup
    $backups = @()
    if ($dcbDir) {
        $filter = @{
            root = $dcbDir.FullName;
            filter = "0x*.package"
        }
        $backups = FindFilesByFilter @filter
    }
    return $backups
}

$sims3dir = FindEaSims3In .
Write-Host "Found $($sims3dir.FullName)"

$a = FindCacheFiles $sims3dir
Write-Host "Found caches: $a"
$b = FindThumbnails $sims3dir
Write-Host "Found thumbnails: $b"
$c = FindDCBackups $sims3dir
Write-Host "Found backups: $c"

$cleanable = $a + $b + $c
Write-Host "Files to clean:"
foreach ($f in $cleanable) {
    Write-Host $f.FullName
}

read-host 'Press ENTER to continue...'  # aka Pause
