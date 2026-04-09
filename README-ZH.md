# Oh My Terminal

一个简洁的终端配置框架，让你的终端更美观。支持 **Windows (PowerShell)** 和 **Linux/macOS (Bash)**。

## 特性

- 自动安装依赖，一键配置
- 基于 Oh My Posh 的美观提示符主题
- 自动安装 Nerd Font 字体（支持国内镜像）
- **Windows**: Terminal-Icons 模块提供文件/文件夹图标，Windows Terminal 配色方案集成
- **Linux/macOS**: Bash 历史搜索，自动安装字体和主题
- **智能 Tab 补全** - 菜单式补全，可视化选择（PowerShell）
- **历史记忆搜索** - 上下箭头智能过滤，输入几个字符即可快速定位历史命令
- **命令联想预测** - 基于历史记录的智能提示（仅 PowerShell 7+ 支持）

## 系统要求

### Windows
- **PowerShell 7+（必需）** - 获得流畅性能、丰富色彩和完整交互功能的必备条件
- 需要以管理员身份运行（用于字体安装）

### Linux / macOS
- **Bash 4+**
- **curl** 和 **unzip**（通常系统自带）

## 安装

### ⭐ 使用 AI Agent 快速安装（**推荐**）

> **最简单的安装方式！** 使用 AI Agent（如 Claude）自动完成安装：

```
clone 这个仓库，帮我安装 claude style 的 oh-my-posh 主题，https://github.com/yangjingo/oh-my-terminal
```

AI 助手会自动帮你完成整个安装过程 —— 坐下来，享受即可！

### Linux / macOS

```bash
# 克隆仓库
git clone https://github.com/yangjingo/oh-my-terminal.git

# 运行安装脚本
cd oh-my-terminal
bash install.sh
```

#### 安装选项

```bash
# 自动检测网络（默认）
bash install.sh

# 强制使用国内镜像
bash install.sh --cn

# 跳过字体安装
bash install.sh --skip-font

# 静默安装
bash install.sh --silent
```

### Windows

```powershell
# 克隆仓库
git clone https://github.com/yangjingo/oh-my-terminal.git

# 运行安装脚本（以管理员身份运行）
cd oh-my-terminal
./install.ps1
```

#### 安装选项

```powershell
# 自动检测网络（默认）
./install.ps1

# 强制使用国内镜像
./install.ps1 -ConfigMode CN

# 跳过字体安装
./install.ps1 -SkipFont

# 静默安装
./install.ps1 -Silent
```

## 主题

内置两个自定义主题：

### Claude 主题（默认）

温暖的陶土色系，灵感来自 Claude Code 的设计美学。

![Claude 主题预览](./asserts/1shell-claude.png)

```bash
# Bash
eval "$(oh-my-posh init bash --config '/path/to/themes/1shell-claude.omp.json')"
```
```powershell
# PowerShell
oh-my-posh init pwsh --config 'C:\path\to\themes\1shell-claude.omp.json' | Invoke-Expression
```

### Codex 主题

科技感配色，高对比度设计，清晰易读。

![Codex 主题预览](./asserts/pure-codex.png)

```bash
# Bash
eval "$(oh-my-posh init bash --config '/path/to/themes/pure-codex.omp.json')"
```
```powershell
# PowerShell
oh-my-posh init pwsh --config 'C:\path\to\themes\pure-codex.omp.json' | Invoke-Expression
```

### 切换主题

**Linux / macOS** — 编辑 `~/.bashrc`：
```bash
# 修改 oh-my-posh init 行中的主题路径
eval "$(oh-my-posh init bash --config '$HOME/.config/oh-my-terminal/themes/pure-codex.omp.json')"
```

**Windows** — 编辑 PowerShell 配置文件：
```powershell
# 查看配置文件路径
$PROFILE

# 复制示例配置
Copy-Item ".\profile.example.ps1" $PROFILE -Force
```

## 文件结构

```
oh-my-terminal/
├── install.sh                  # Linux/macOS 安装脚本
├── install.ps1                 # Windows PowerShell 安装脚本
├── profile.example.sh          # Bash 配置文件模板
├── profile.example.ps1         # PowerShell 配置文件模板
├── SKILL.md                    # AI Agent 安装指南
├── themes/
│   ├── 1shell-claude.omp.json  # Claude 主题（温暖陶土色系）
│   └── pure-codex.omp.json     # Codex 主题（科技感多彩配色）
├── asserts/
│   ├── 1shell-claude.png       # Claude 主题预览
│   └── pure-codex.png          # Codex 主题预览
├── oh-my-terminal.json       # Scoop 安装清单
├── LICENSE
└── README.md
```

### 文件说明

| 文件 | 说明 |
|------|------|
| `install.sh` | Linux/macOS 安装脚本。自动安装 oh-my-posh、FiraCode Nerd Font，配置 bash。 |
| `install.ps1` | Windows 安装脚本。自动安装 oh-my-posh、git、FiraCode Nerd Font、Terminal-Icons 模块，配置 Windows Terminal。 |
| `profile.example.sh` | Bash 配置文件模板。追加到 `~/.bashrc` 后可自定义。 |
| `profile.example.ps1` | PowerShell 配置文件模板。复制到 `$PROFILE` 位置后可自定义。 |
| `SKILL.md` | AI Agent 自动安装指引。 |
| `themes/` | Oh My Posh JSON 主题文件，跨平台通用。 |
| `asserts/` | 主题预览截图。 |
| `oh-my-terminal.json` | Scoop 安装清单，可通过 `scoop install` 安装。 |

## 许可证

[MIT License](LICENSE)

## 致谢

- 灵感来源于 [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- 基于 [Oh My Posh](https://ohmyposh.dev) 构建
- 图标来自 [Terminal-Icons](https://github.com/devblackops/Terminal-Icons)
- 字体来自 [Nerd Fonts](https://www.nerdfonts.com)
