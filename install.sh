#!/bin/sh

set -eu

ESC=$(printf '\033')
COLOR_INFO="${ESC}[1;34m"
COLOR_SUCCESS="${ESC}[1;32m"
COLOR_WARN="${ESC}[1;33m"
COLOR_ERROR="${ESC}[1;31m"
COLOR_RESET="${ESC}[0m"
log_info() { printf "%s[INFO]%s %s\n" "$COLOR_INFO" "$COLOR_RESET" "$1"; }
log_success() { printf "%s[SUCCESS]%s %s\n" "$COLOR_SUCCESS" "$COLOR_RESET" "$1"; }
log_warn() { printf "%s[WARN]%s %s\n" "$COLOR_WARN" "$COLOR_RESET" "$1"; }
log_error() { printf "%s[ERROR]%s %s\n" "$COLOR_ERROR" "$COLOR_RESET" "$1" >&2; }

detect_os() {
  KERNEL=$(uname -s)
  case "$KERNEL" in
  Linux)
    if [ -f /proc/sys/kernel/osrelease ] && grep -qi "microsoft" /proc/sys/kernel/osrelease 2>/dev/null; then
      OS_TYPE="WSL"
    elif [ -f /proc/version ] && grep -qi "microsoft" /proc/version 2>/dev/null; then
      OS_TYPE="WSL"
    else
      OS_TYPE="Linux"
    fi
    ;;
  Darwin)
    OS_TYPE="macOS"
    ;;
  *BSD* | DragonFly)
    OS_TYPE="BSD"
    ;;
  *)
    OS_TYPE="unknown"
    ;;
  esac
  echo "$OS_TYPE"
}

make_link() {
  _src="$1"
  _dst="$2"

  _dst_dir=$(dirname "$_dst")
  if [ ! -d "$_dst_dir" ]; then
    log_info "Creating parent directory: $_dst_dir"
    mkdir -p "$_dst_dir"
  fi

  if [ -L "$_dst" ]; then
    log_warn "$_dst is already a soft link. Removing existing link..."
    rm "$_dst"
  elif [ -e "$_dst" ]; then
    _timestamp=$(date +%Y%m%d_%H%M%S)
    _backup="$_dst.backup.$_timestamp"
    log_warn "$_dst exists as a real file/folder. Backing up to $_backup..."
    mv "$_dst" "$_backup"
  fi

  log_success "Linking $_dst -> $_src"
  ln -s "$_src" "$_dst"
}

main() {
  OS=$(detect_os)
  DOT_DIR=$(cd "$(dirname "$0")" && pwd)

  # Alacritty
  # make_link "$DOT_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

  # Emacs
  make_link "$DOT_DIR/emacs/early-init.el" "$HOME/.config/emacs/early-init.el"
  make_link "$DOT_DIR/emacs/init.el" "$HOME/.config/emacs/init.el"

  # foot
  # if [ "$OS" = "Linux" ]; then
  #   make_link "$DOT_DIR/foot/foot.ini" "$HOME/.config/foot/foot.ini"
  # fi

  # Ghostty
  if [ "$OS" = "macOS" ]; then
    make_link "$DOT_DIR/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
  else
    make_link "$DOT_DIR/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
  fi

  # Helix
  # make_link "$DOT_DIR/helix" "$HOME/.config/helix"

  # Kitty
  # make_link "$DOT_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

  # Neovim
  make_link "$DOT_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"

  # Niri
  # if [ "$OS" = "Linux" ]; then
  #   make_link "$DOT_DIR/niri/config.kdl" "$HOME/.config/niri/config.kdl"
  # fi

  # OmniWM
  # if [ "$OS" = "macOS" ]; then
  #   make_link "$DOT_DIR/omniwm/settings.toml" "$HOME/.config/omniwm/settings.toml"
  # fi

  # Vim
  # make_link "$DOT_DIR/vim/init.vim" "$HOME/.vimrc"

  # VSCode
  if [ "$OS" = "macOS" ]; then
    make_link "$DOT_DIR/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
    make_link "$DOT_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  else
    make_link "$DOT_DIR/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
    make_link "$DOT_DIR/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
  fi

  # WezTerm
  # make_link "$DOT_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

  # Bash/Zsh (macOS/Linux)
  if [ "$OS" = "macOS" ]; then
    make_link "$DOT_DIR/zsh/zshrc" "$HOME/.zshrc"
    make_link "$DOT_DIR/zsh/zprofile" "$HOME/.zprofile"
  else
    make_link "$DOT_DIR/bash/bash_profile" "$HOME/.bash_profile"
    make_link "$DOT_DIR/bash/bashrc" "$HOME/.bashrc"
  fi
}

main "$@"
