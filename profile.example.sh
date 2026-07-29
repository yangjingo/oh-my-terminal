# Bash Profile Example
# Append this content to your ~/.bashrc and adjust the theme path.

# fnm (Fast Node Manager) - uncomment if you use fnm
# eval "$(fnm env --shell bash)"

# <oh-my-terminal>
export PATH="$PATH:$HOME/.local/bin"
eval "$(oh-my-posh init bash --config '$HOME/.config/oh-my-terminal/themes/1shell-claude.omp.json')"

# Bash Line Editor: history suggestions and enhanced completion (Linux only)
if [ "$(uname -s)" = "Linux" ] && [ -f "$HOME/.local/share/blesh/ble.sh" ]; then
    source -- "$HOME/.local/share/blesh/ble.sh"
fi
# </oh-my-terminal>
