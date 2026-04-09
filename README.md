# Oh My Terminal

A minimal terminal configuration framework for a beautiful shell experience. Works on **Windows (PowerShell)** and **Linux/macOS (Bash)**.

[中文文档](./README-ZH.md)

## Features

- Easy installation with automatic dependency management
- Beautiful prompt themes powered by Oh My Posh
- Automatic Nerd Font installation (supports China mirror)
- **Windows**: File/folder icons with Terminal-Icons module, Windows Terminal color scheme integration
- **Linux/macOS**: Bash history search, automatic font and theme setup
- **Smart Tab Completion** - Menu-style completions with visual selection (PowerShell)
- **History Search** - Navigate through history with Up/Down arrows, filtered by what you've typed
- **Command Prediction** - AI-like suggestions based on your command history (PowerShell 7+ only)

## Requirements

### Windows
- **PowerShell 7+ (Required)** - Essential for optimal performance, rich colors, and full interactive features
- Run as Administrator (for font installation)

### Linux / macOS
- **Bash 4+**
- **curl** and **unzip** (usually pre-installed)

## Installation

### ⭐ Quick Install with AI Agent (**Recommended**)

> **The easiest way to get started!** Use an AI agent (like Claude) to install automatically:

```
clone this repo and help me install the claude style oh-my-posh theme, https://github.com/yangjingo/oh-my-terminal
```

The AI agent will handle the entire installation process for you - sit back and enjoy!

### Linux / macOS

```bash
# Clone the repository
git clone https://github.com/yangjingo/oh-my-terminal.git

# Run the installation script
cd oh-my-terminal
bash install.sh
```

#### Installation Options

```bash
# Auto-detect network (default)
bash install.sh

# Force China mirror mode
bash install.sh --cn

# Skip font installation
bash install.sh --skip-font

# Silent mode
bash install.sh --silent
```

### Windows

```powershell
# Clone the repository
git clone https://github.com/yangjingo/oh-my-terminal.git

# Run the installation script (as Administrator)
cd oh-my-terminal
./install.ps1
```

#### Installation Options

```powershell
# Auto-detect network (default)
./install.ps1

# Force China mirror mode
./install.ps1 -ConfigMode CN

# Skip font installation
./install.ps1 -SkipFont

# Silent mode
./install.ps1 -Silent
```

## Themes

Two custom themes are included:

### Claude Theme (Default)

Warm terracotta palette inspired by Claude Code's aesthetic.

![Claude Theme Preview](./asserts/1shell-claude.png)

```bash
# Bash
eval "$(oh-my-posh init bash --config '/path/to/themes/1shell-claude.omp.json')"
```
```powershell
# PowerShell
oh-my-posh init pwsh --config 'C:\path\to\themes\1shell-claude.omp.json' | Invoke-Expression
```

### Codex Theme

Tech-focused palette with vibrant colors for high contrast.

![Codex Theme Preview](./asserts/pure-codex.png)

```bash
# Bash
eval "$(oh-my-posh init bash --config '/path/to/themes/pure-codex.omp.json')"
```
```powershell
# PowerShell
oh-my-posh init pwsh --config 'C:\path\to\themes\pure-codex.omp.json' | Invoke-Expression
```

### Switch Themes

**Linux / macOS** — edit your `~/.bashrc`:
```bash
# Change the theme path in the oh-my-posh init line
eval "$(oh-my-posh init bash --config '$HOME/.config/oh-my-terminal/themes/pure-codex.omp.json')"
```

**Windows** — edit your PowerShell profile:
```powershell
# View your profile path
$PROFILE

# Copy example profile
Copy-Item ".\profile.example.ps1" $PROFILE -Force
```

## Files

```
oh-my-terminal/
├── install.sh                  # Linux/macOS installation script
├── install.ps1                 # Windows PowerShell installation script
├── profile.example.sh          # Bash profile template
├── profile.example.ps1         # PowerShell profile template
├── SKILL.md                    # AI Agent installation guide
├── themes/
│   ├── 1shell-claude.omp.json  # Claude theme (warm terracotta palette)
│   └── pure-codex.omp.json     # Codex theme (tech-focused vibrant colors)
├── asserts/
│   ├── 1shell-claude.png       # Claude theme preview
│   └── pure-codex.png          # Codex theme preview
├── oh-my-terminal.json       # Scoop manifest for package distribution
├── LICENSE
├── README.md
└── README-ZH.md                # Chinese documentation
```

### File Descriptions

| File | Description |
|------|-------------|
| `install.sh` | Linux/macOS installation script. Installs oh-my-posh, FiraCode Nerd Font, and configures bash. |
| `install.ps1` | Windows installation script. Installs oh-my-posh, git, FiraCode Nerd Font, Terminal-Icons module, and configures Windows Terminal. |
| `profile.example.sh` | Bash profile template. Append to `~/.bashrc` and customize as needed. |
| `profile.example.ps1` | PowerShell profile template. Copy to `$PROFILE` location and customize as needed. |
| `SKILL.md` | Instructions for AI agents to install this framework automatically. |
| `themes/` | Oh My Posh JSON theme files. Compatible with all platforms. |
| `asserts/` | Theme preview screenshots. |
| `oh-my-terminal.json` | Scoop manifest for installing via `scoop install`. |

## License

[MIT License](LICENSE)

## Acknowledgments

- Inspired by [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- Powered by [Oh My Posh](https://ohmyposh.dev)
- Icons by [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
- Fonts by [Nerd Fonts](https://www.nerdfonts.com)
