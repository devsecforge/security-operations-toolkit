# Changelog

All notable changes to this project are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]
### Planned
- DAST stage (OWASP ZAP baseline scan)
- Kubernetes runtime security demo (Falco)
- SBOM generation (Syft) + signing (Cosign)

## [1.0.0] - 2026-07-18
### Added
- Local security gate: secret, SAST, SCA, IaC and container scans.
- `run-all.sh` orchestrator with per-stage summary.
- Shared helper library (`scripts/lib/common.sh`).
- GitHub Actions `Security CI` pipeline with SARIF upload to the Security tab.
- CodeQL, ShellCheck, Dependabot, and a weekly scheduled scan.
- Project docs: architecture overview and threat model.
- Repository governance: SECURITY, CONTRIBUTING, issue/PR templates, MIT license.
