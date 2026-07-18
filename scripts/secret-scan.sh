#!/usr/bin/env bash
# secret-scan.sh — detect hard-coded secrets/credentials with gitleaks.
# Usage: ./scripts/secret-scan.sh [path]
source "$(dirname "$0")/lib/common.sh"

[[ $# -ge 1 ]] && TARGET="$1"

log "Scanning '$TARGET' for hard-coded secrets (gitleaks)..."
require gitleaks

REPORT="${REPORT_DIR}/gitleaks-report.json"
if gitleaks detect \
      --source "$TARGET" \
      --report-format json \
      --report-path "$REPORT" \
      --no-banner \
      --redact; then
  ok "No leaked secrets found. Report: $REPORT"
else
  error "Potential secrets detected — review $REPORT before committing/pushing."
  exit 1
fi
