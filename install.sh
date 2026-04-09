#!/usr/bin/env bash
#
# oh-my-terminal Linux installation script
# Installs Oh My Posh, Nerd Fonts, and configures bash.
#
# Usage:
#   ./install.sh              # Auto-detect network
#   ./install.sh --cn         # Force China mirror
#   ./install.sh --skip-font  # Skip font installation
#   ./install.sh --silent     # Silent mode
#

set -euo pipefail

# --- Defaults ---
CN_MIRROR=false
SKIP_FONT=false
SILENT=false

# --- Parse Args ---
for arg in "$@"; do
    case "$arg" in
        --cn)        CN_MIRROR=true ;;
        --skip-font) SKIP_FONT=true ;;
        --silent)    SILENT=true ;;
        --help|-h)
            echo "Usage: $0 [--cn] [--skip-font] [--silent]"
            echo ""
            echo "  --cn         Force China mirror"
            echo "  --skip-font  Skip Nerd Font installation"
            echo "  --silent     Silent installation"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            exit 1
            ;;
    esac
done

info()  { $SILENT && return; echo -e "\033[36m$*\033[0m"; }
ok()    { $SILENT && return; echo -e "\033[32m$*\033[0m"; }
warn()  { echo -e "\033[33m$*\033[0m"; }
err()   { echo -e "\033[31m$*\033[0m"; }

# --- 1. Network Detection ---
if [ "$CN_MIRROR" = false ]; then
    info "Detecting network environment..."
    if ! curl -sI --connect-timeout 5 https://github.com > /dev/null 2>&1; then
        CN_MIRROR=true
        warn ">> GitHub connection limited, switching to China mirror."
    fi
fi

REPO_USER="yangjingo"
REPO_NAME="oh-my-terminal"
RAW_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/main"
if [ "$CN_MIRROR" = true ]; then
    RAW_URL="https://ghproxy.com/${RAW_URL}"
fi

# --- 2. Install Oh My Posh ---
install_oh_my_posh() {
    if command -v oh-my-posh &>/dev/null; then
        ok "Oh My Posh already installed: $(oh-my-posh --version)"
        return
    fi

    info "Installing Oh My Posh..."
    local tmpdir
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" > /dev/null

    if [ "$CN_MIRROR" = true ]; then
        curl -sLO https://ghproxy.com/https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -o oh-my-posh
    else
        curl -sLO https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
    fi

    chmod +x posh-linux-amd64
    mkdir -p "$HOME/.local/bin"
    mv posh-linux-amd64 "$HOME/.local/bin/oh-my-posh"

    popd > /dev/null
    rm -rf "$tmpdir"

    # Ensure ~/.local/bin is in PATH
    export PATH="$HOME/.local/bin:$PATH"
    grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

    ok "Oh My Posh installed successfully."
}

install_oh_my_posh

# --- 3. Install Nerd Font ---
install_nerd_font() {
    local font_name="FiraCode"
    local font_dir="$HOME/.local/share/fonts"
    local font_marker="$font_dir/.nerd-font-installed"

    if [ -f "$font_marker" ]; then
        ok "Nerd Font already installed: $font_name"
        return
    fi

    info "Downloading $font_name Nerd Font..."

    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${font_name}.zip"
    if [ "$CN_MIRROR" = true ]; then
        font_url="https://ghproxy.net/${font_url}"
    fi

    local tmpdir
    tmpdir=$(mktemp -d)
    local zipfile="$tmpdir/${font_name}.zip"

    if curl -fSL --connect-timeout 30 -o "$zipfile" "$font_url"; then
        mkdir -p "$font_dir"
        unzip -qo "$zipfile" -d "$tmpdir/extracted"

        # Install only the monospace variants
        find "$tmpdir/extracted" -name "*NerdFontMono*.ttf" -exec cp {} "$font_dir/" \;

        # Rebuild font cache
        if command -v fc-cache &>/dev/null; then
            fc-cache -f "$font_dir" 2>/dev/null
        fi

        touch "$font_marker"
        ok "Font installed: $font_name Nerd Font"
    else
        warn "[Warning] Font download failed."
        warn "You can manually download from: https://www.nerdfonts.com/font-downloads"
    fi

    rm -rf "$tmpdir"
}

if [ "$SKIP_FONT" = false ]; then
    install_nerd_font
fi

# --- 4. Clone / Update Themes ---
install_themes() {
    local theme_dir="$HOME/.config/oh-my-terminal/themes"

    # If running from a cloned repo with themes, copy them
    local script_dir
    script_dir="$(cd "$(dirname "$0")" && pwd)"
    if [ -d "$script_dir/themes" ]; then
        mkdir -p "$theme_dir"
        cp "$script_dir/themes/"*.omp.json "$theme_dir/"
        ok "Themes copied from local repository."
        return
    fi

    if [ -d "$theme_dir" ]; then
        ok "Themes directory already exists: $theme_dir"
        return
    fi

    info "Downloading themes..."
    mkdir -p "$theme_dir"

    for theme in 1shell-claude.omp.json pure-codex.omp.json; do
        curl -fSL -o "$theme_dir/$theme" "${RAW_URL}/themes/$theme" 2>/dev/null || {
            warn "Failed to download theme: $theme"
        }
    done

    ok "Themes downloaded to $theme_dir"
}

install_themes

# --- 5. Configure Bash Profile ---
configure_bash() {
    local bashrc="$HOME/.bashrc"
    local theme_dir="$HOME/.config/oh-my-terminal/themes"

    # Determine theme path
    local theme_path="$theme_dir/1shell-claude.omp.json"

    local block="# <oh-my-terminal>
export PATH=\"\$PATH:\$HOME/.local/bin\"
eval \"\$(oh-my-posh init bash --config '${theme_path}')\"

# Bash history search (up/down arrows filter by prefix)
bind '\"\\e[A\": history-search-backward'
bind '\"\\e[B\": history-search-forward'
# </oh-my-terminal>"

    if grep -q "oh-my-terminal" "$bashrc" 2>/dev/null; then
        warn "Bash profile already configured."
        return
    fi

    echo "" >> "$bashrc"
    echo "$block" >> "$bashrc"
    ok "Bash profile updated."
}

configure_bash

echo ""
ok "Installation complete! Please restart your terminal or run: source ~/.bashrc"
