#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Helpers ──────────────────────────────────────────────────────────────────

info()    { printf '\033[0;34m[info]\033[0m  %s\n' "$*"; }
success() { printf '\033[0;32m[ok]\033[0m    %s\n' "$*"; }
warn()    { printf '\033[0;33m[warn]\033[0m  %s\n' "$*"; }
die()     { printf '\033[0;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)  echo "linux" ;;
        *)      die "Unsupported OS: $(uname -s)" ;;
    esac
}

command_exists() { command -v "$1" &>/dev/null; }

symlink() {
    local src="$1" dst="$2"
    local dst_dir
    dst_dir="$(dirname "$dst")"

    mkdir -p "$dst_dir"

    if [ -L "$dst" ]; then
        if [ "$(readlink "$dst")" = "$src" ]; then
            success "Already linked: $dst"
            return
        fi
        warn "Replacing existing symlink: $dst"
        rm "$dst"
    elif [ -e "$dst" ]; then
        warn "Backing up existing file/dir: $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -s "$src" "$dst"
    success "Linked: $dst → $src"
}

# ── Package installation ──────────────────────────────────────────────────────

install_for_macos() {
    local pkg="$1"
    if ! command_exists brew; then
        die "Homebrew is not installed. Install it from https://brew.sh and re-run."
    fi
    info "Installing $pkg via Homebrew..."
    brew install "$pkg"
}

install_for_linux() {
    local pkg="$1"
    if command_exists apt-get; then
        sudo apt-get install -y "$pkg"
    elif command_exists dnf; then
        sudo dnf install -y "$pkg"
    elif command_exists pacman; then
        sudo pacman -S --noconfirm "$pkg"
    else
        die "No supported package manager found (apt/dnf/pacman). Install $pkg manually."
    fi
}

ensure_installed() {
    local cmd="$1"
    local pkg="${2:-$1}"
    local os="$3"

    if command_exists "$cmd"; then
        success "$cmd is already installed"
        return
    fi

    info "$cmd not found — installing..."
    if [ "$os" = "macos" ]; then
        install_for_macos "$pkg"
    else
        install_for_linux "$pkg"
    fi
    success "$cmd installed"
}

# ── Neovim: Linux needs the AppImage or snap because distro packages are old ──

install_neovim_linux() {
    if command_exists nvim; then
        success "neovim is already installed"
        return
    fi

    info "Installing Neovim (latest stable) on Linux..."

    if command_exists snap; then
        sudo snap install nvim --classic
    elif command_exists apt-get || command_exists dnf || command_exists pacman; then
        # Try distro package first; warn if it might be outdated
        warn "Installing Neovim from distro package — may not be the latest version."
        if command_exists apt-get;  then sudo apt-get install -y neovim
        elif command_exists dnf;    then sudo dnf install -y neovim
        elif command_exists pacman; then sudo pacman -S --noconfirm neovim
        fi
    else
        die "Cannot install Neovim automatically. Please install it manually: https://neovim.io"
    fi

    success "neovim installed"
}

# ── Symlinks ──────────────────────────────────────────────────────────────────

setup_symlinks() {
    info "Setting up symlinks..."
    symlink "$DOTFILES_DIR/nvim"          "$HOME/.config/nvim"
    symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
}

# ── Main ──────────────────────────────────────────────────────────────────────

main() {
    local os
    os="$(detect_os)"
    info "Detected OS: $os"

    if [ "$os" = "macos" ]; then
        ensure_installed nvim  neovim "$os"
        ensure_installed tmux  tmux   "$os"
    else
        install_neovim_linux
        ensure_installed tmux tmux "$os"
    fi

    setup_symlinks
    success "Done! Open a new terminal and launch nvim to let lazy.nvim install plugins."
}

main "$@"
