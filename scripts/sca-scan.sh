#!/usr/bin/env bash
# sca-scan.sh — Software Composition Analysis (dependency vulns) with Trivy.
# Usage: ./scripts/sca-scan.sh [path]
source "$(dirname "$0")/lib/common.sh"

[[ $# -ge 1 ]] && TARGET="$1"

log "Scanning dependencies in '$TARGET' for known CVEs (trivy fs)..."
require trivy

REPORT="${REPORT_DIR}/trivy-deps-report.json"
# Fail the build only on HIGH/CRITICAL to keep signal high.
if trivy fs \
      --scanners vuln \
      --severity HIGH,CRITICAL \
      --exit-code 1 \
      --format json --output "$REPORT" \
      "$TARGET"; then
  ok "No HIGH/CRITICAL dependency vulnerabilities. Report: $REPORT"
else
  error "HIGH/CRITICAL dependency vulnerabilities found — review $REPORT."
  exit 1
fi
