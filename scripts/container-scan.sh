#!/usr/bin/env bash
# container-scan.sh — scan a container image for OS/library CVEs with Trivy.
# Usage: ./scripts/container-scan.sh <image:tag>
source "$(dirname "$0")/lib/common.sh"

[[ $# -ge 1 ]] || die "Usage: $0 <image:tag>   e.g. $0 nginx:1.27"
IMAGE="$1"

log "Scanning container image '$IMAGE' (trivy image)..."
require trivy

REPORT="${REPORT_DIR}/trivy-image-report.json"
if trivy image \
      --severity HIGH,CRITICAL \
      --exit-code 1 \
      --ignore-unfixed \
      --format json --output "$REPORT" \
      "$IMAGE"; then
  ok "No fixable HIGH/CRITICAL vulnerabilities in '$IMAGE'. Report: $REPORT"
else
  error "Vulnerabilities found in '$IMAGE' — review $REPORT."
  exit 1
fi
