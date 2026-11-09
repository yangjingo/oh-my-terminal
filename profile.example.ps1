# PowerShell Profile Example
# Copy this file to your $PROFILE location and adjust paths

# fnm (Fast Node Manager) - uncomment if you use fnm
# fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

# <oh-my-terminal>
oh-my-posh init pwsh --config '$env:USERPROFILE\oh-my-terminal\themes\1shell-claude.omp.json' | Invoke-Expression
Import-Module Terminal-Icons

# PSReadLine: fuzzy history search and menu completion
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Command prediction (PowerShell 7+ only)
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Set-PSReadLineOption -PredictionSource History
}
# </oh-my-terminal>
