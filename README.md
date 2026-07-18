<div align="center">

# 🛡️ Security Operations Toolkit

**A drop-in DevSecOps gate that catches secrets, vulnerable dependencies, insecure code, and cloud misconfigurations — locally and in CI.**

[![Security CI](https://github.com/devsecforge/security-operations-toolkit/actions/workflows/security-ci.yml/badge.svg)](https://github.com/devsecforge/security-operations-toolkit/actions/workflows/security-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Shell](https://img.shields.io/badge/Shell-4EAA25?logo=gnubash&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?logo=aqua&logoColor=white)
![Semgrep](https://img.shields.io/badge/Semgrep-1B2A4A?logo=semgrep&logoColor=white)

</div>

---

## 📖 Overview

Most security tooling lives *only* in CI, so developers get feedback minutes after they push — or
not until a PR fails. This toolkit runs the **same scanners locally and in CI**, so issues surface
before they ever leave your machine, and the pipeline enforces them as a hard gate.

One command — `make scan` — runs a five-stage security check. The same stages run automatically on
every pull request and upload their results to the GitHub **Security tab**.

## ✨ Features

- 🔑 **Secret scanning** — `gitleaks` blocks committed keys, tokens, and passwords.
- 🧠 **SAST** — `semgrep` flags insecure code patterns (curated `p/ci` + `p/security-audit` rules).
- 📦 **SCA** — `trivy fs` finds known CVEs in your dependencies.
- 🏗️ **IaC scanning** — `trivy config` catches Terraform / Kubernetes / Docker misconfigurations.
- 🐳 **Container scanning** — `trivy image` scans built images for OS & library CVEs.
- 🤖 **CI-native** — GitHub Actions pipeline with SARIF upload, CodeQL, ShellCheck & Dependabot.
- 🧩 **Composable** — each stage is an isolated script; add DAST/SBOM/signing without rewrites.

## 🖼️ Screenshots

> _Placeholder — add real screenshots once you run it:_
> - `docs/img/ci-run.png` — a green Security CI run
> - `docs/img/security-tab.png` — findings in the GitHub Security tab

## 🏛️ Architecture

See **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** for the full diagram. In short:

```
make scan ─┐                         ┌─ gitleaks (secrets)
           ├─ scripts/run-all.sh ────┼─ semgrep  (SAST)
git push ──┘   =  Security CI job    ├─ trivy fs (SCA)
                                     ├─ trivy config (IaC)
                                     └─ trivy image (containers)  → SARIF → 🛡 Security tab
```

## ⚙️ Installation

**Prerequisites** (install what you need — scripts skip/warn on missing optional tools):

```bash
# macOS (Homebrew)
brew install trivy semgrep gitleaks shellcheck make

# Linux (see each tool's docs for apt/dnf or install scripts)
# Trivy:   https://trivy.dev/latest/getting-started/installation/
# Semgrep: pip install semgrep
# gitleaks: https://github.com/gitleaks/gitleaks#installing
```

Clone:

```bash
git clone https://github.com/devsecforge/security-operations-toolkit.git
cd security-operations-toolkit
```

## 🚀 Usage

```bash
make help                 # list all commands
make scan                 # run the full local gate (secrets + SAST + SCA + IaC)
make secrets              # just the secret scan
make sast                 # just SAST
make sca                  # just dependency CVE scan
make iac                  # just IaC misconfig scan
make image IMG=nginx:1.27 # scan a container image
make lint                 # shellcheck the scripts
```

Or call scripts directly:

```bash
./scripts/run-all.sh ./path/to/scan            # full gate on a path
./scripts/container-scan.sh myapp:latest       # container image
```

Reports are written to `reports/` (git-ignored) as JSON.

## 📁 Folder Structure

```
security-operations-toolkit/
├── scripts/
│   ├── lib/common.sh        # shared logging + tool checks
│   ├── secret-scan.sh       # gitleaks
│   ├── sast-scan.sh         # semgrep
│   ├── sca-scan.sh          # trivy fs (dependencies)
│   ├── iac-scan.sh          # trivy config
│   ├── container-scan.sh    # trivy image
│   └── run-all.sh           # orchestrator
├── .github/
│   ├── workflows/security-ci.yml
│   ├── ISSUE_TEMPLATE/
│   ├── dependabot.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── ARCHITECTURE.md
│   └── THREAT_MODEL.md
├── Makefile
├── requirements.txt
├── SECURITY.md · CONTRIBUTING.md · CHANGELOG.md · LICENSE
└── README.md
```

## 🧰 Technology Stack

`Bash` · `GitHub Actions` · `Trivy` · `Semgrep` · `gitleaks` · `CodeQL` · `ShellCheck` · `Dependabot`

## 🔐 Security

Vulnerability reporting process: **[SECURITY.md](SECURITY.md)**. Threat model: **[docs/THREAT_MODEL.md](docs/THREAT_MODEL.md)**.

## 🗺️ Roadmap

- [ ] DAST stage (OWASP ZAP baseline)
- [ ] SBOM generation (Syft) + artifact signing (Cosign)
- [ ] Kubernetes runtime security demo (Falco)
- [ ] Pre-commit hook wrapper
- [ ] Policy-as-code gate (OPA/Conftest)

See the full log in **[CHANGELOG.md](CHANGELOG.md)**.

## ❓ FAQ

<details>
<summary><b>Do I need every tool installed?</b></summary>
No. Each script checks for its tool and fails with a clear message; the orchestrator reports which
stages ran. Install only the scanners you want.
</details>

<details>
<summary><b>Why gate only on HIGH/CRITICAL?</b></summary>
To keep signal high and avoid alert fatigue. Lower-severity findings are still reported in the JSON
output and Security tab — they just don't block the build. Tune thresholds in each script.
</details>

<details>
<summary><b>Can I use this in a non-GitHub CI?</b></summary>
Yes — the scripts are plain Bash. Call <code>run-all.sh</code> from GitLab CI, Jenkins, etc. The
provided workflow is GitHub-specific but easy to port.
</details>

## 🤝 Contributing

PRs welcome — see **[CONTRIBUTING.md](CONTRIBUTING.md)**. Please run `make lint` first.

## 📄 License

[MIT](LICENSE) © 2026 devsecforge

---

<div align="center">
<sub>Built as part of an open DevSecOps portfolio. ⭐ Star it if it's useful.</sub>
</div>
