# Security Operations Toolkit — developer entrypoints.
.DEFAULT_GOAL := help
SHELL := /bin/bash

.PHONY: help secrets sast sca iac image scan lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

secrets: ## Scan for hard-coded secrets (gitleaks)
	@bash scripts/secret-scan.sh

sast: ## Static analysis (semgrep)
	@bash scripts/sast-scan.sh

sca: ## Dependency CVE scan (trivy fs)
	@bash scripts/sca-scan.sh

iac: ## IaC misconfiguration scan (trivy config)
	@bash scripts/iac-scan.sh

image: ## Scan a container image: make image IMG=nginx:1.27
	@bash scripts/container-scan.sh $(IMG)

scan: ## Run the full local security gate
	@bash scripts/run-all.sh

lint: ## Lint all shell scripts (shellcheck)
	@shellcheck scripts/*.sh scripts/lib/*.sh
