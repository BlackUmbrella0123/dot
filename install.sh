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

# Is a command on PATH?
has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# Is a macOS .app bundle installed? (GUI apps often aren't on PATH)
has_app() {
  [ "$OS" = "macOS" ] || return 1
  [ -d "/Applications/$1.app" ] || [ -d "$HOME/Applications/$1.app" ]
}

log_skip() { log_info "Skipping $1 (not installed)"; }

make_link() {
  _src="$1"
  _dst="$2"

  # Already pointing at the right place: nothing to do
  if [ -L "$_dst" ] && [ "$(readlink "$_dst")" = "$_src" ]; then
    log_info "Already linked: $_dst"
    return 0
  fi

  _dst_dir=$(dirname "$_dst")
  if [ ! -d "$_dst_dir" ]; then
    log_info "Creating parent directory: $_dst_dir"
    mkdir -p "$_dst_dir"
  fi

  if [ -L "$_dst" ]; then
    log_warn "$_dst links elsewhere ($(readlink "$_dst")). Replacing..."
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

  # Neovim
  if has_cmd nvim; then
    make_link "$DOT_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
  else
    log_skip "Neovim"
  fi

  # Rio
  if has_cmd rio; then
    make_link "$DOT_DIR/rio/config.toml" "$HOME/.config/rio/config.toml"
  else
    log_skip "Rio"
  fi

  # VSCode
  if has_cmd code || has_app "Visual Studio Code"; then
    if [ "$OS" = "macOS" ]; then
      make_link "$DOT_DIR/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
      make_link "$DOT_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    else
      make_link "$DOT_DIR/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
      make_link "$DOT_DIR/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
    fi
  else
    log_skip "VSCode"
  fi

}

main "$@"
