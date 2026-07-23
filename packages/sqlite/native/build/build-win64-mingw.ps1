[CmdletBinding()]
param(
    [string]$Compiler = $(if ($env:CC) { $env:CC } else { "gcc" }),
    [string]$Archiver = $(if ($env:AR) { $env:AR } else { "ar" })
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $PSCommandPath
$nativeDir = Split-Path -Parent $scriptDir
$sourceDir = Join-Path $nativeDir "sqlite-amalgamation-3530300"
$sourceFile = Join-Path $sourceDir "sqlite3.c"
$targetDir = Join-Path $nativeDir "sqlite-3530300_win64_mingw"
$libDir = Join-Path $targetDir "lib"
$archiveFile = Join-Path $libDir "libsqlite3.a"
$buildDir = Join-Path ([System.IO.Path]::GetTempPath()) ("jik-sqlite-" + [guid]::NewGuid())
$compileFlags = @("-O2", "-DSQLITE_OMIT_LOAD_EXTENSION")

if (-not (Test-Path -LiteralPath $sourceFile)) {
    throw "SQLite source not found: $sourceFile"
}

$compilerTarget = (& $Compiler -dumpmachine).Trim()
if ($compilerTarget -ne "x86_64-w64-mingw32") {
    throw "expected an x86_64-w64-mingw32 compiler, got: $compilerTarget"
}

New-Item -ItemType Directory -Force -Path $libDir | Out-Null
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

try {
    $objectFile = Join-Path $buildDir "sqlite3.o"
    & $Compiler @compileFlags -c $sourceFile -o $objectFile
    if ($LASTEXITCODE -ne 0) {
        throw "SQLite compilation failed"
    }

    & $Archiver rcsD $archiveFile $objectFile
    if ($LASTEXITCODE -ne 0) {
        throw "SQLite archiving failed"
    }
}
finally {
    if (Test-Path -LiteralPath $buildDir) {
        Remove-Item -LiteralPath $buildDir -Recurse -Force
    }
}

$sourceHash = (Get-FileHash -LiteralPath $sourceFile -Algorithm SHA256).Hash.ToLowerInvariant()
$archiveHash = (Get-FileHash -LiteralPath $archiveFile -Algorithm SHA256).Hash.ToLowerInvariant()
$compilerVersion = (& $Compiler --version | Select-Object -First 1).Trim()
$archiverVersion = (& $Archiver --version | Select-Object -First 1).Trim()
$buildHost = [System.Runtime.InteropServices.RuntimeInformation]::OSDescription.Trim()
$buildTime = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")
$buildInfo = @(
    "sqlite_version=3.53.3"
    "source_file=sqlite-amalgamation-3530300/sqlite3.c"
    "source_sha256=$sourceHash"
    "archive_file=lib/libsqlite3.a"
    "archive_sha256=$archiveHash"
    "target=$compilerTarget"
    "compiler=$compilerVersion"
    "archiver=$archiverVersion"
    "compile_flags=$($compileFlags -join ' ')"
    "host=$buildHost"
    "built_at_utc=$buildTime"
)
$buildInfo | Set-Content -LiteralPath (Join-Path $targetDir "build-info.txt") -Encoding utf8

Write-Host "Built $archiveFile"
