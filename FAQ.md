# FAQ / 常见问题

以下问题均来自真实安装过程中踩到的坑（Windows 10 + Windows PowerShell 5.1 环境）。

## 中文

### 1. 运行 install.ps1 后 Windows Terminal settings.json 中文乱码、配置损坏

**现象**：在 Windows PowerShell 5.1 下运行安装脚本后，`settings.json` 里的中文配置项（如 `命令提示符`）变成乱码（`鍛戒护鎻愮ず绗?`），JSON 无法解析，Windows Terminal 加载失败。

**原因**：PowerShell 5.1 的 `Get-Content` 默认按系统 ANSI 代码页（简体中文系统为 GBK）读取 UTF-8 文件，中文被读坏后再写回，配置就损坏了。PS 7 无此问题。

**解决**：

```powershell
# 先从备份恢复（脚本执行前请务必备份）
Copy-Item settings.json settings.json.bak

# 读写都显式指定 UTF-8，绕过默认编码
$raw  = [System.IO.File]::ReadAllText($settingsPath, [System.Text.Encoding]::UTF8)
$conf = $raw | ConvertFrom-Json
# ... 修改 $conf ...
$json = $conf | ConvertTo-Json -Depth 100
[System.IO.File]::WriteAllText($settingsPath, $json, (New-Object System.Text.UTF8Encoding $false))
```

### 2. winget 安装 Oh My Posh 失败："Please specify one of them using the --source option"

**现象**：`winget install --id JanDeDobbeleer.OhMyPosh` 报错，提示在多个源中找到同名包。

**解决**：显式指定源：

```powershell
winget install --id JanDeDobbeleer.OhMyPosh --source winget
```

### 3. 国内下载 FiraCode Nerd Font 极慢

**实测数据**（同一网络环境）：

| 下载通道 | 速度 | 26MB 文件耗时 |
|---|---|---|
| GitHub 直连 | ~20 KB/s | 20 分钟以上 |
| ghproxy.net（脚本内置 CN 镜像） | ~25 KB/s | 15 分钟以上 |
| **gh-proxy.com** | **~1 MB/s** | **26 秒** |

**解决**：把 `install.ps1` 中 CN 模式的字体下载地址前缀改为 `https://gh-proxy.com/`：

```powershell
$fontUrl = "https://gh-proxy.com/$fontUrl"
```

### 4. 没有管理员权限，装不了 Nerd Font

**现象**：公司环境通常没有管理员权限，`install.ps1` 因要求管理员而直接退出。

**解决**：Windows 10 1809+ 支持用户级字体安装，无需管理员：

1. 把字体 `.ttf` 复制到 `%LOCALAPPDATA%\Microsoft\Windows\Fonts\`
2. 在注册表 `HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts` 下为每个字体添加字符串值（名称如 `FiraCode Nerd Font Regular (TrueType)`，值为字体文件完整路径）

Windows Terminal 会立即识别新字体，重启终端即可生效。

### 5. PowerShell 5.1 下没有输入预测（灰色联想列表）

**原因**：`Set-PSReadLineOption -PredictionSource History` 和 `PredictionViewStyle ListView` 仅 PowerShell 7+ 支持。5.1 下历史搜索（↑/↓ 按前缀过滤）和 Tab 菜单补全仍可用。

**解决**：安装 PowerShell 7：

```powershell
winget install Microsoft.PowerShell
```

### 6. Profile 文件里中文注释乱码

**现象**：`profile.example.ps1` 复制过去后中文注释显示为乱码。

**原因**：PowerShell 5.1 读取不带 BOM 的 UTF-8 脚本时按 ANSI 解析。

**解决**：包含中文的 ps1 文件保存为 **UTF-8 with BOM**（PS 5.1 的 `Set-Content -Encoding UTF8` 默认带 BOM），或干脆使用英文注释。

### 7. 安装完成默认是 Claude 主题，如何切换到 Codex 主题？

编辑 PowerShell Profile（`$PROFILE`），把主题路径从 `1shell-claude.omp.json` 改为 `pure-codex.omp.json`：

```powershell
oh-my-posh init pwsh --config "$env:USERPROFILE\oh-my-terminal\themes\pure-codex.omp.json" | Invoke-Expression
```

同时可在 Windows Terminal 设置里把默认 `colorScheme` 改为 `Codex` 配色。

## English

### 1. settings.json gets corrupted (Chinese mojibake) after running install.ps1 on PowerShell 5.1

PS 5.1 reads UTF-8 files using the ANSI codepage (GBK on zh-CN systems), corrupting Chinese text in Windows Terminal's `settings.json`. Always back up first, and read/write via `[System.IO.File]::ReadAllText/WriteAllText` with explicit `UTF8Encoding($false)`. Not an issue on PowerShell 7.

### 2. winget fails with "Please specify one of them using the --source option"

Add `--source winget` to the install command.

### 3. Font download is extremely slow in China

Measured: GitHub direct ~20 KB/s, ghproxy.net ~25 KB/s, **gh-proxy.com ~1 MB/s**. Consider switching the CN mirror prefix in `install.ps1` to `https://gh-proxy.com/`.

### 4. Installing Nerd Fonts without admin rights

Copy `.ttf` files to `%LOCALAPPDATA%\Microsoft\Windows\Fonts\` and register each in `HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts` (e.g. `FiraCode Nerd Font Regular (TrueType)` → full path). Works on Windows 10 1809+, no admin required.

### 5. No inline command prediction on PowerShell 5.1

`PredictionSource History` / `PredictionViewStyle ListView` require PowerShell 7+ (`winget install Microsoft.PowerShell`). History search and MenuComplete work on 5.1.

### 6. Mojibake in Chinese comments inside .ps1 files

PS 5.1 parses BOM-less UTF-8 scripts as ANSI. Save as UTF-8 with BOM, or use English comments.

### 7. Default theme is Claude — how to switch to Codex?

Edit `$PROFILE` and point `oh-my-posh init pwsh --config` to `pure-codex.omp.json`; optionally set `colorScheme` to `Codex` in Windows Terminal settings.
