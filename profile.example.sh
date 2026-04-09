# Bash Profile Example
# Append this content to your ~/.bashrc and adjust the theme path.

# fnm (Fast Node Manager) - uncomment if you use fnm
# eval "$(fnm env --shell bash)"

# <oh-my-terminal>
export PATH="$PATH:$HOME/.local/bin"
eval "$(oh-my-posh init bash --config '$HOME/.config/oh-my-terminal/themes/1shell-claude.omp.json')"

# Bash history search (up/down arrows filter by prefix)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# </oh-my-terminal>
