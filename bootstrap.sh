#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

install_packages() {
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        if [[ -s "$SCRIPT_DIR/packages/apt" ]]; then
            xargs sudo apt-get install -y < "$SCRIPT_DIR/packages/apt"
        fi
    elif command -v dnf >/dev/null 2>&1; then
        if [[ -s "$SCRIPT_DIR/packages/dnf" ]]; then
            xargs sudo dnf install -y < "$SCRIPT_DIR/packages/dnf"
        fi
    elif command -v pacman >/dev/null 2>&1; then
        if [[ -s "$SCRIPT_DIR/packages/pacman" ]]; then
            xargs sudo pacman -Syu --needed --noconfirm < "$SCRIPT_DIR/packages/pacman"
        fi
    elif command -v brew >/dev/null 2>&1; then
        if [[ -s "$SCRIPT_DIR/packages/brew" ]]; then
            xargs brew install < "$SCRIPT_DIR/packages/brew"
        fi
    else
        printf 'Nicht unterstütztes Betriebssystem: kein Paketmanager gefunden.\n' >&2
        return 1
    fi
}

install_packages

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ -f "$SCRIPT_DIR/id_ed25519" ]]; then
    install -m 600 "$SCRIPT_DIR/id_ed25519" "$HOME/.ssh/id_ed25519"
fi
if [[ -f "$SCRIPT_DIR/id_ed25519.pub" ]]; then
    install -m 644 "$SCRIPT_DIR/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
fi

if ! ssh -o BatchMode=yes -T git@github.com 2>&1 | grep -qi "authenticated"; then
    printf 'Hinweis: GitHub-SSH-Authentifizierung ist nicht eingerichtet.\n' >&2
fi

REPO_DIR="$SCRIPT_DIR"
if [[ ! -d "$REPO_DIR/.git" ]]; then
    REPO_DIR="$HOME/dotfiles"
fi

if [[ ! -d "$REPO_DIR/.git" ]]; then
    git clone git@github.com:hawiwo/dotfiles.git "$HOME/dotfiles"
fi

stow --dir="$REPO_DIR" --target="$HOME" bash git zsh
