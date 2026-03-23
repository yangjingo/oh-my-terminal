# PowerShell Profile Example
# Copy this file to your $PROFILE location and adjust paths

# fnm (Fast Node Manager) - uncomment if you use fnm
# fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

# <oh-my-powershell>
oh-my-posh init pwsh --config '$env:USERPROFILE\oh-my-powershell\themes\1shell-claude.omp.json' | Invoke-Expression
Import-Module Terminal-Icons

# PSReadLine 自动补全和历史搜索
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# 命令联想预测（仅 PowerShell 7+ 支持）
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption -PredictionSource History
}
# </oh-my-powershell>