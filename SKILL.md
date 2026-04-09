# Oh My PowerShell — AI Agent Installation Skill

This document guides AI agents (Claude, Codex, etc.) through installing the oh-my-terminal terminal framework.

## Overview

oh-my-terminal provides beautiful Oh My Posh themes for terminal prompts. It supports:
- **Windows**: PowerShell 7+ with Oh My Posh, Terminal-Icons, and Windows Terminal integration
- **Linux/macOS**: Bash with Oh My Posh, Nerd Fonts, and history search

## Detection

1. Detect the OS: `uname -s` (Linux/macOS) or `$PSVersionTable` (Windows PowerShell)
2. Detect the shell: `$SHELL` on Linux, `$Host.Name` on Windows

## Installation Steps

### Linux / macOS (Bash)

```bash
# 1. Clone repository
git clone https://github.com/yangjingo/oh-my-terminal.git

# 2. Run the installer
cd oh-my-terminal
bash install.sh

# 3. For China users, use mirror
bash install.sh --cn
```

The installer will:
- Download Oh My Posh binary to `~/.local/bin/`
- Install FiraCode Nerd Font to `~/.local/share/fonts/`
- Copy themes to `~/.config/oh-my-terminal/themes/`
- Append configuration to `~/.bashrc`

If run from the cloned repo directory, the installer detects local themes and copies them automatically.

### Windows (PowerShell 7+)

```powershell
# 1. Clone repository
git clone https://github.com/yangjingo/oh-my-terminal.git

# 2. Run installer as Administrator
cd oh-my-terminal
.\install.ps1

# 3. For China users
.\install.ps1 -ConfigMode CN
```

The installer will:
- Install Oh My Posh and Git via winget
- Install FiraCode Nerd Font system-wide
- Install Terminal-Icons PowerShell module
- Configure Windows Terminal color schemes (Claude + Codex)
- Update PowerShell profile with theme and PSReadLine settings

## Themes

Two themes are available in `themes/`:

| Theme | File | Style |
|-------|------|-------|
| **Claude** (default) | `1shell-claude.omp.json` | Warm terracotta (#D97757), cat emoji 🐱 prefix |
| **Codex** | `pure-codex.omp.json` | Tech blue/green (#58A6FF/#7EE787), atom emoji ⚛️ prefix |

Both themes include: user, path, git status, python venv, execution time, memory usage, and command status segments.

## Manual Profile Setup

If the user prefers manual setup or the installer fails:

### Bash (~/.bashrc)

```bash
# Append to ~/.bashrc
export PATH="$PATH:$HOME/.local/bin"
eval "$(oh-my-posh init bash --config '/path/to/themes/1shell-claude.omp.json')"

# History search with up/down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
```

### PowerShell ($PROFILE)

```powershell
oh-my-posh init pwsh --config 'C:\path\to\themes\1shell-claude.omp.json' | Invoke-Expression
Import-Module Terminal-Icons

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption -PredictionSource History
}
```

## Verification

After installation, verify by:

```bash
# Linux/macOS
oh-my-posh --version
source ~/.bashrc

# Windows PowerShell
oh-my-posh --version
. $PROFILE
```

The prompt should display the selected theme with colored segments.

## Troubleshooting

- **Font issues**: Ensure "FiraCode Nerd Font" is set in the terminal emulator settings
- **China network**: Use `--cn` flag or `-ConfigMode CN` for mirror support
- **oh-my-posh not found**: Check `~/.local/bin` (Linux) or `winget list` (Windows) is in PATH
- **WSL users**: Run the Linux installer inside WSL; set the font in Windows Terminal settings
