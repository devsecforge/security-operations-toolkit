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
                         │  ① Secret scan   (gitleaks)   ── gate        │
                         │  ② SAST          (semgrep)  ──┐              │
                         │  ③ SCA (deps)    (trivy fs) ──┼─▶ SARIF ─▶ 🛡 │
                         │                               ┘   upload  Security
                         │  ④ ShellCheck    (lint)       ── gate       tab
                         └──────────────────────────────────────────────┘
```

## Components

| Stage | Tool | What it catches | Mode |
|-------|------|-----------------|------|
| Secret scanning | gitleaks | Committed keys, tokens, passwords | Gate (fails on finding) |
| SAST | Semgrep | Insecure code patterns | Report → Security tab |
| SCA | Trivy (fs) | Vulnerable dependencies + secrets | Report → Security tab |
| Lint | ShellCheck | Shell bugs/foot-guns | Gate (fails on error) |

> The local gate (`run-all.sh`) also includes IaC (`trivy config`) and container image
> (`trivy image`) scans; these run on demand locally rather than in the CI workflow.

## Design principles

- **Shift left, but enforce right.** Same scanners locally and in CI — no "works on my machine."
- **High signal.** Gate on HIGH/CRITICAL and fixable issues to avoid alert fatigue.
- **Transparent results.** Everything uploads as SARIF to the GitHub Security tab.
- **Extensible.** Each stage is an isolated script; add DAST/SBOM/signing without touching others.

## Reports

All local scans write machine-readable output to `reports/` (git-ignored). CI publishes SARIF
to the Security tab and, for scheduled runs, surfaces newly disclosed CVEs weekly.
