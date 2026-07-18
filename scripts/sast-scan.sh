#!/usr/bin/env bash
# sast-scan.sh — Static Application Security Testing with Semgrep.
# Usage: ./scripts/sast-scan.sh [path]
source "$(dirname "$0")/lib/common.sh"

[[ $# -ge 1 ]] && TARGET="$1"

log "Running SAST on '$TARGET' (semgrep, ruleset: p/ci + p/security-audit)..."
require semgrep

REPORT="${REPORT_DIR}/semgrep-report.json"
# --config auto pulls curated community rules; pin rulesets in CI for reproducibility.
if semgrep scan \
      --config "p/ci" \
      --config "p/security-audit" \
      --error \
      --json --output "$REPORT" \
      "$TARGET"; then
  ok "SAST passed with no blocking findings. Report: $REPORT"
else
  error "SAST found issues — review $REPORT."
  exit 1
fi
