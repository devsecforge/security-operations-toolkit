#!/usr/bin/env bash
# iac-scan.sh — Infrastructure-as-Code security scan (Terraform/K8s/Docker) with Trivy config.
# Usage: ./scripts/iac-scan.sh [path]
source "$(dirname "$0")/lib/common.sh"

[[ $# -ge 1 ]] && TARGET="$1"

log "Scanning IaC/config in '$TARGET' for misconfigurations (trivy config)..."
require trivy

REPORT="${REPORT_DIR}/trivy-iac-report.json"
if trivy config \
      --severity HIGH,CRITICAL \
      --exit-code 1 \
      --format json --output "$REPORT" \
      "$TARGET"; then
  ok "No HIGH/CRITICAL IaC misconfigurations. Report: $REPORT"
else
  error "IaC misconfigurations found — review $REPORT."
  exit 1
fi
