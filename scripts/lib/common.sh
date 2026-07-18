#!/usr/bin/env bash
# common.sh — shared helpers for all toolkit scripts.
# Source this at the top of every script: source "$(dirname "$0")/lib/common.sh"
set -euo pipefail

# ── Colors (disabled when not a TTY) ─────────────────────────────
if [[ -t 1 ]]; then
  RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m'; BOLD=$'\033[1m'; RESET=$'\033[0m'
else
  RED=""; GREEN=""; YELLOW=""; BLUE=""; BOLD=""; RESET=""
fi

log()   { printf '%s[*]%s %s\n' "$BLUE"   "$RESET" "$*"; }
ok()    { printf '%s[+]%s %s\n' "$GREEN"  "$RESET" "$*"; }
warn()  { printf '%s[!]%s %s\n' "$YELLOW" "$RESET" "$*" >&2; }
error() { printf '%s[x]%s %s\n' "$RED"    "$RESET" "$*" >&2; }
die()   { error "$*"; exit 1; }

# require <command> — fail with a helpful message if a tool is missing.
require() {
  command -v "$1" >/dev/null 2>&1 || die "Required tool '$1' not found. Install it and retry (see README)."
}

# soft_require <command> — warn and skip instead of failing (for optional tools).
soft_require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    warn "Optional tool '$1' not found — skipping this stage."
    return 1
  fi
}

# Project root (repo root regardless of where the script is called from).
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REPORT_DIR="${ROOT_DIR}/reports"
mkdir -p "$REPORT_DIR"

# Target directory to scan (defaults to repo root, override with $TARGET).
TARGET="${TARGET:-$ROOT_DIR}"
