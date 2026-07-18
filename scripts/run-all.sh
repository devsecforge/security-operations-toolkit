#!/usr/bin/env bash
# run-all.sh — orchestrate the full local security gate.
# Runs secret, SAST, SCA and IaC scans. Container scan is opt-in (needs an image arg).
# Usage: ./scripts/run-all.sh [path] [optional-image:tag]
source "$(dirname "$0")/lib/common.sh"

SCAN_PATH="${1:-$ROOT_DIR}"
IMAGE="${2:-}"
DIR="$(dirname "$0")"
FAILED=()

run_stage() {
  local name="$1"; shift
  printf '\n%s──── %s ────%s\n' "$BOLD" "$name" "$RESET"
  if "$@"; then ok "$name OK"; else warn "$name FAILED"; FAILED+=("$name"); fi
}

run_stage "Secret scan"    bash "$DIR/secret-scan.sh"    "$SCAN_PATH"
run_stage "SAST"           bash "$DIR/sast-scan.sh"      "$SCAN_PATH"
run_stage "SCA (deps)"     bash "$DIR/sca-scan.sh"       "$SCAN_PATH"
run_stage "IaC config"     bash "$DIR/iac-scan.sh"       "$SCAN_PATH"
[[ -n "$IMAGE" ]] && run_stage "Container image" bash "$DIR/container-scan.sh" "$IMAGE"

printf '\n%s════ SUMMARY ════%s\n' "$BOLD" "$RESET"
if [[ ${#FAILED[@]} -eq 0 ]]; then
  ok "All security stages passed. Reports in: $REPORT_DIR"
  exit 0
else
  error "Failed stages: ${FAILED[*]}"
  exit 1
fi
