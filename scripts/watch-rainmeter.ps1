[CmdletBinding()]
param(
    [string]$SourceRoot,
    [string]$TargetRoot = (Join-Path $env:USERPROFILE 'Documents\Rainmeter\Skins\RetroTouchPlayer'),
    [string]$RainmeterExe,
    [switch]$Watch,
    [switch]$SkipRefresh,
    [int]$DebounceMilliseconds = 350
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))

if (-not $PSBoundParameters.ContainsKey('SourceRoot')) {
    $SourceRoot = Join-Path $workspaceRoot 'RetroTouchPlayer'
}

$SourceRoot = [System.IO.Path]::GetFullPath($SourceRoot)
$TargetRoot = [System.IO.Path]::GetFullPath($TargetRoot)

function Resolve-RainmeterExecutable {
    param([string]$ConfiguredPath)

    if ($ConfiguredPath) {
        if (Test-Path -LiteralPath $ConfiguredPath) {
            return [System.IO.Path]::GetFullPath($ConfiguredPath)
        }

        throw "Rainmeter executable was not found at '$ConfiguredPath'."
    }

    $candidates = @(
        'C:\Program Files\Rainmeter\Rainmeter.exe',
        'C:\Program Files (x86)\Rainmeter\Rainmeter.exe'
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    return $null
}

function Test-FileIsLockedForWrite {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }

    try {
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
        $stream.Dispose()
        return $false
    }
    catch [System.UnauthorizedAccessException] {
        return $true
    }
    catch [System.IO.IOException] {
        return $true
    }
}

function Get-RelativePath {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    $normalizedBasePath = [System.IO.Path]::GetFullPath($BasePath).TrimEnd('\') + '\'
    $normalizedTargetPath = [System.IO.Path]::GetFullPath($TargetPath)

    $baseUri = [System.Uri]::new($normalizedBasePath)
    $targetUri = [System.Uri]::new($normalizedTargetPath)

    return [System.Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString().Replace('/', '\'))
}

function Sync-FontFiles {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    $sourceFontsPath = Join-Path $SourcePath '@Resources\Fonts'
    $destinationFontsPath = Join-Path $DestinationPath '@Resources\Fonts'

    if (-not (Test-Path -LiteralPath $sourceFontsPath)) {
        return
    }

    New-Item -ItemType Directory -Path $destinationFontsPath -Force | Out-Null

    $sourceFontFiles = @(Get-ChildItem -LiteralPath $sourceFontsPath -File -Recurse)
    $sourceFontFilesByRelativePath = @{}

    foreach ($sourceFontFile in $sourceFontFiles) {
        $relativePath = Get-RelativePath -BasePath $sourceFontsPath -TargetPath $sourceFontFile.FullName
        $sourceFontFilesByRelativePath[$relativePath] = $sourceFontFile

        $destinationFontPath = Join-Path $destinationFontsPath $relativePath
        $destinationFontDirectory = Split-Path -Path $destinationFontPath -Parent
        New-Item -ItemType Directory -Path $destinationFontDirectory -Force | Out-Null

        $copyRequired = $true

        if (Test-Path -LiteralPath $destinationFontPath -PathType Leaf) {
            $destinationFontFile = Get-Item -LiteralPath $destinationFontPath
            $copyRequired = $destinationFontFile.Length -ne $sourceFontFile.Length -or $destinationFontFile.LastWriteTimeUtc -ne $sourceFontFile.LastWriteTimeUtc

            if ($copyRequired -and (Test-FileIsLockedForWrite -Path $destinationFontPath)) {
                Write-Warning "Skipping locked font file '$relativePath'."
                continue
            }
        }

        if (-not $copyRequired) {
            continue
        }

        Copy-Item -LiteralPath $sourceFontFile.FullName -Destination $destinationFontPath -Force
        (Get-Item -LiteralPath $destinationFontPath).LastWriteTimeUtc = $sourceFontFile.LastWriteTimeUtc
    }

    if (-not (Test-Path -LiteralPath $destinationFontsPath)) {
        return
    }

    $destinationFontFiles = @(Get-ChildItem -LiteralPath $destinationFontsPath -File -Recurse)

    foreach ($destinationFontFile in $destinationFontFiles) {
        $relativePath = Get-RelativePath -BasePath $destinationFontsPath -TargetPath $destinationFontFile.FullName

        if ($sourceFontFilesByRelativePath.ContainsKey($relativePath)) {
            continue
        }

        if (Test-FileIsLockedForWrite -Path $destinationFontFile.FullName) {
            Write-Warning "Skipping locked font file '$relativePath'."
            continue
        }

        Remove-Item -LiteralPath $destinationFontFile.FullName -Force
    }
}

function Invoke-SkinSync {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        throw "Source skin folder '$SourcePath' does not exist."
    }

    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null

    Write-Host ("[{0:HH:mm:ss}] Syncing skin files..." -f (Get-Date))
    $sourceFontsPath = Join-Path $SourcePath '@Resources\Fonts'

    & robocopy $SourcePath $DestinationPath /MIR /R:1 /W:1 /XD $sourceFontsPath /NFL /NDL /NJH /NJS /NP | Out-Null
    $exitCode = $LASTEXITCODE

    if ($exitCode -gt 7) {
        throw "Robocopy failed with exit code $exitCode."
    }

    Sync-FontFiles -SourcePath $SourcePath -DestinationPath $DestinationPath
    Write-Host ("[{0:HH:mm:ss}] Sync complete." -f (Get-Date))
}

function Invoke-RainmeterRefresh {
    param([string]$ExecutablePath)

    if ($SkipRefresh) {
        Write-Host ("[{0:HH:mm:ss}] Refresh skipped." -f (Get-Date))
        return
    }

    if (-not $ExecutablePath) {
        Write-Warning 'Rainmeter.exe was not found. Synced files, but did not refresh Rainmeter.'
        return
    }

    Write-Host ("[{0:HH:mm:ss}] Refreshing Rainmeter..." -f (Get-Date))
    Start-Process -FilePath $ExecutablePath -ArgumentList '!RefreshApp' | Out-Null
}

$rainmeterPath = Resolve-RainmeterExecutable -ConfiguredPath $RainmeterExe

Write-Host 'Starting Rainmeter watcher...'
Write-Host "Source: $SourceRoot"
Write-Host "Target: $TargetRoot"
if ($rainmeterPath) {
    Write-Host "Rainmeter: $rainmeterPath"
}
else {
    Write-Warning 'Rainmeter.exe was not detected in the default install paths.'
}

Invoke-SkinSync -SourcePath $SourceRoot -DestinationPath $TargetRoot
Invoke-RainmeterRefresh -ExecutablePath $rainmeterPath

if (-not $Watch) {
    return
}

$state = [hashtable]::Synchronized(@{
    Pending      = $false
    LastEventUtc = [DateTime]::MinValue
})

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $SourceRoot
$watcher.IncludeSubdirectories = $true
$watcher.Filter = '*'
$watcher.NotifyFilter = [System.IO.NotifyFilters]'FileName, DirectoryName, LastWrite, CreationTime'

$eventAction = {
    $sharedState = $event.MessageData
    $sharedState.Pending = $true
    $sharedState.LastEventUtc = [DateTime]::UtcNow

    $changeType = $event.SourceEventArgs.ChangeType
    $fullPath = $event.SourceEventArgs.FullPath

    if ($changeType -eq [System.IO.WatcherChangeTypes]::Renamed) {
        $oldPath = $event.SourceEventArgs.OldFullPath
        Write-Host ("[{0:HH:mm:ss}] Renamed: {1} -> {2}" -f (Get-Date), $oldPath, $fullPath)
        return
    }

    Write-Host ("[{0:HH:mm:ss}] {1}: {2}" -f (Get-Date), $changeType, $fullPath)
}

$subscriptions = @(
    (Register-ObjectEvent -InputObject $watcher -EventName Changed -MessageData $state -Action $eventAction)
    (Register-ObjectEvent -InputObject $watcher -EventName Created -MessageData $state -Action $eventAction)
    (Register-ObjectEvent -InputObject $watcher -EventName Deleted -MessageData $state -Action $eventAction)
    (Register-ObjectEvent -InputObject $watcher -EventName Renamed -MessageData $state -Action $eventAction)
)

$watcher.EnableRaisingEvents = $true
Write-Host 'Watching for changes.'
Write-Host 'Press Ctrl+C to stop.'

try {
    while ($true) {
        Start-Sleep -Milliseconds 200

        if (-not $state.Pending) {
            continue
        }

        $elapsedMilliseconds = ([DateTime]::UtcNow - $state.LastEventUtc).TotalMilliseconds
        if ($elapsedMilliseconds -lt $DebounceMilliseconds) {
            continue
        }

        $state.Pending = $false

        try {
            Invoke-SkinSync -SourcePath $SourceRoot -DestinationPath $TargetRoot
            Invoke-RainmeterRefresh -ExecutablePath $rainmeterPath
        }
        catch {
            Write-Error $_
        }
    }
}
finally {
    foreach ($subscription in $subscriptions) {
        Unregister-Event -SourceIdentifier $subscription.SourceIdentifier -ErrorAction SilentlyContinue
        $subscription | Remove-Job -Force -ErrorAction SilentlyContinue
    }

    $watcher.Dispose()
}
