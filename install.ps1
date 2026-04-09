<#
.SYNOPSIS
    oh-my-terminal installation script
.DESCRIPTION
    Automatically configures Windows Terminal, installs Nerd Fonts, and sets up Oh My Posh.
.PARAMETER ConfigMode
    Network mode: Auto (auto-detect), CN (China mirror), Global (direct)
.PARAMETER SkipFont
    Skip font installation
.PARAMETER Silent
    Silent installation mode
#>

param(
    [string]$ConfigMode = "Auto",
    [switch]$SkipFont = $false,
    [switch]$Silent = $false
)

$ErrorActionPreference = "Stop"

# --- 1. Permission and Environment Check ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[Error] Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

# Network detection
$isCN = $false
if ($ConfigMode -eq "CN") { $isCN = $true }
elseif ($ConfigMode -eq "Auto") {
    Write-Host "Detecting network environment..." -ForegroundColor Cyan
    $test = Test-Connection -ComputerName "github.com" -Count 1 -Quiet -ErrorAction SilentlyContinue
    if (-not $test) {
        $isCN = $true
        Write-Host ">> GitHub connection limited, switching to China mirror." -ForegroundColor Yellow
    }
}

# Base URL
$repoUser = "yangjingo"
$repoName = "oh-my-terminal"
$rawUrl = "https://raw.githubusercontent.com/$repoUser/$repoName/main"
if ($isCN) { $rawUrl = "https://ghproxy.com/$rawUrl" }

# --- 2. Dependency Management ---
function Install-Dependency {
    param([string]$Name, [string]$Id)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Host "Installing dependency: $Name..." -ForegroundColor Cyan
        winget install --id $Id --silent --accept-package-agreements --accept-source-agreements
    } else {
        Write-Host "Dependency already installed: $Name" -ForegroundColor Green
    }
}

Install-Dependency "oh-my-posh" "JanDeDobbeleer.OhMyPosh"
Install-Dependency "git" "Git.Git"

# --- 3. Font Installation ---
function Install-NerdFont {
    param([string]$FontName = "FiraCode")

    $fontsPath = "C:\Windows\Fonts"
    $fontPattern = "$FontName*Nerd*Font*"

    # Check if font already installed
    $existingFonts = Get-ChildItem -Path $fontsPath -Filter "$FontName*" -ErrorAction SilentlyContinue
    if ($existingFonts | Where-Object { $_.Name -match "Nerd" }) {
        Write-Host "Nerd Font already installed: $FontName" -ForegroundColor Green
        return
    }

    Write-Host "Downloading $FontName Nerd Font..." -ForegroundColor Cyan

    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$FontName.zip"
    if ($isCN) {
        $fontUrl = "https://ghproxy.net/$fontUrl"
    }

    $tempZip = "$env:TEMP\nerd-font.zip"
    $extractPath = "$env:TEMP\nerd-font-extract"

    try {
        # Download
        Invoke-WebRequest -Uri $fontUrl -OutFile $tempZip -UseBasicParsing
        Write-Host "Download complete." -ForegroundColor Green

        # Extract
        Expand-Archive -Path $tempZip -DestinationPath $extractPath -Force

        # Install fonts
        $shell = New-Object -ComObject Shell.Application
        $fontsFolder = $shell.Namespace(0x14)

        $fontFiles = Get-ChildItem -Path $extractPath -Include "*.ttf", "*.otf" -Recurse |
            Where-Object { $_.Name -match "NerdFont(Mono)?-\w+\.ttf$" }

        foreach ($fontFile in $fontFiles) {
            $destPath = "$fontsPath\$($fontFile.Name)"
            if (-not (Test-Path $destPath)) {
                $fontsFolder.CopyHere($fontFile.FullName, 0x10)
                Write-Host "Installed: $($fontFile.Name)" -ForegroundColor Gray
            }
        }

        # Cleanup
        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        Remove-Item $extractPath -Recurse -Force -ErrorAction SilentlyContinue

        Write-Host "Font installation complete: $FontName Nerd Font" -ForegroundColor Green
    }
    catch {
        Write-Host "[Warning] Font download failed: $_" -ForegroundColor Yellow
        Write-Host "You can manually download from: https://www.nerdfonts.com/font-downloads" -ForegroundColor Yellow
    }
}

if (-not $SkipFont) {
    Install-NerdFont -FontName "FiraCode"
}

# --- 4. Terminal-Icons Installation ---
function Install-TerminalIcons {
    if (-not (Get-Module -ListAvailable -Name Terminal-Icons -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Terminal-Icons module..." -ForegroundColor Cyan
        Install-Module -Name Terminal-Icons -Repository PSGallery -Force -Scope CurrentUser
        Write-Host "Terminal-Icons installed." -ForegroundColor Green
    } else {
        Write-Host "Terminal-Icons already installed." -ForegroundColor Green
    }
}

Install-TerminalIcons

# --- 5. Windows Terminal Configuration ---
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-not (Test-Path $settingsPath)) {
    $settingsPath = "$env:LOCALAPPDATA\Microsoft\WindowsTerminal\settings.json"
}

if (Test-Path $settingsPath) {
    Write-Host "Configuring Windows Terminal..." -ForegroundColor Cyan

    $conf = Get-Content $settingsPath -Raw | ConvertFrom-Json

    # Set default profile font
    if (-not $conf.profiles) { $conf | Add-Member -MemberType NoteProperty -Name "profiles" -Value @{} -Force }
    if (-not $conf.profiles.defaults) { $conf.profiles | Add-Member -MemberType NoteProperty -Name "defaults" -Value @{} -Force }

    $fontSettings = @{
        "font" = @{
            "face" = "FiraCode Nerd Font"
        }
    }

    foreach ($key in $fontSettings.Keys) {
        if ($conf.profiles.defaults.PSObject.Properties.Name -contains $key) {
            $conf.profiles.defaults.$key = $fontSettings[$key]
        } else {
            $conf.profiles.defaults | Add-Member -MemberType NoteProperty -Name $key -Value $fontSettings[$key] -Force
        }
    }

    # Configure color scheme - Claude Code style (Obsidian Black + Terracotta Orange)
    $schemes = @(
        @{
            "name" = "Claude"
            "background" = "#0A0A0A"
            "foreground" = "#FAF9F5"
            "black" = "#0A0A0A"
            "red" = "#D97757"
            "green" = "#A8B5A0"
            "yellow" = "#D97757"
            "blue" = "#9A9B8C"
            "purple" = "#B0AEA5"
            "cyan" = "#A8B5A0"
            "white" = "#FAF9F5"
            "brightBlack" = "#6B6B6B"
            "brightRed" = "#D97757"
            "brightGreen" = "#A8B5A0"
            "brightYellow" = "#D97757"
            "brightBlue" = "#9A9B8C"
            "brightPurple" = "#B0AEA5"
            "brightCyan" = "#A8B5A0"
            "brightWhite" = "#FAF9F5"
        },
        @{
            "name" = "Codex"
            "background" = "#0D1117"
            "foreground" = "#C9D1D9"
            "black" = "#010409"
            "red" = "#F85149"
            "green" = "#7EE787"
            "yellow" = "#D29922"
            "blue" = "#58A6FF"
            "purple" = "#BC8CFF"
            "cyan" = "#39C5CF"
            "white" = "#F0F6FC"
            "brightBlack" = "#6E7681"
            "brightRed" = "#FF7B72"
            "brightGreen" = "#AFF5B4"
            "brightYellow" = "#E3B341"
            "brightBlue" = "#79C0FF"
            "brightPurple" = "#D2A8FF"
            "brightCyan" = "#56D4DD"
            "brightWhite" = "#FFFFFF"
        }
    )

    if (-not $conf.schemes) {
        $conf | Add-Member -MemberType NoteProperty -Name "schemes" -Value @() -Force
    }

    foreach ($scheme in $schemes) {
        $existing = $conf.schemes | Where-Object { $_.name -eq $scheme.name }
        if ($existing) {
            $conf.schemes = $conf.schemes | Where-Object { $_.name -ne $scheme.name }
        }
        $conf.schemes += $scheme
    }

    if (-not $conf.profiles.defaults.colorScheme) {
        $conf.profiles.defaults | Add-Member -MemberType NoteProperty -Name "colorScheme" -Value "Claude" -Force
    }

    $conf | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding utf8
    Write-Host "Windows Terminal configuration updated." -ForegroundColor Green
}

# --- 6. PowerShell Profile Activation ---
$themePath = "$PSScriptRoot\themes\1shell-claude.omp.json"
$profileContent = @"
# <oh-my-terminal>
oh-my-posh init pwsh --config '$themePath' | Invoke-Expression
Import-Module Terminal-Icons

# PSReadLine 自动补全和历史搜索
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# 命令联想预测（仅 PowerShell 7+ 支持）
if (`$PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption -PredictionSource History
}
# </oh-my-terminal>
"@

if (-not (Test-Path $PROFILE)) {
    New-Item -Path $PROFILE -Type File -Force | Out-Null
}

$oldProfile = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($oldProfile -notlike "*oh-my-terminal*") {
    Add-Content -Path $PROFILE -Value "`n$profileContent"
    Write-Host "PowerShell Profile updated." -ForegroundColor Green
} else {
    Write-Host "PowerShell Profile already configured." -ForegroundColor Yellow
}

Write-Host "`nInstallation complete! Please restart your terminal." -ForegroundColor Green