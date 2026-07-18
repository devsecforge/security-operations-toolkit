# Architecture

The Security Operations Toolkit is a set of composable scanners wired into two entrypoints:
a **local gate** (`run-all.sh` / `make scan`) developers run before pushing, and a
**CI gate** (`.github/workflows/security-ci.yml`) that enforces the same checks on every PR.

## Pipeline flow

```
                       ┌─────────────────────────────────────────────┐
                       │              Developer laptop               │
                       │   make scan  →  scripts/run-all.sh          │
                       └───────────────────┬─────────────────────────┘
                                           │ (same scanners)
   git push / PR                           ▼
┌───────────────┐        ┌──────────────────────────────────────────────┐
│   GitHub PR   │ ─────▶ │             Security CI workflow             │
└───────────────┘        │                                              │
                         │  ① Secret scan   (gitleaks)                  │
                         │  ② SAST          (semgrep)  ──┐              │
                         │  ③ SCA (deps)    (trivy fs) ──┼─▶ SARIF ─▶ 🛡 │
                         │  ④ IaC config    (trivy)    ──┤   upload   Security
                         │  ⑤ CodeQL        (github)   ──┘             tab
                         │  ⑥ ShellCheck    (lint)                      │
                         └──────────────────────────────────────────────┘
```

## Components

| Stage | Tool | What it catches | Fails build on |
|-------|------|-----------------|----------------|
| Secret scanning | gitleaks | Committed keys, tokens, passwords | Any finding |
| SAST | Semgrep | Insecure code patterns | Blocking rules |
| SCA | Trivy (fs) | Vulnerable dependencies | HIGH/CRITICAL |
| IaC | Trivy (config) | Terraform/K8s/Docker misconfig | HIGH/CRITICAL |
| Container | Trivy (image) | OS/library CVEs in images | Fixable HIGH/CRITICAL |
| Code analysis | CodeQL | Data-flow vulnerabilities | Configurable |
| Lint | ShellCheck | Shell bugs/foot-guns | Any error |

## Design principles

- **Shift left, but enforce right.** Same scanners locally and in CI — no "works on my machine."
- **High signal.** Gate on HIGH/CRITICAL and fixable issues to avoid alert fatigue.
- **Transparent results.** Everything uploads as SARIF to the GitHub Security tab.
- **Extensible.** Each stage is an isolated script; add DAST/SBOM/signing without touching others.

## Reports

All local scans write machine-readable output to `reports/` (git-ignored). CI publishes SARIF
to the Security tab and, for scheduled runs, surfaces newly disclosed CVEs weekly.
