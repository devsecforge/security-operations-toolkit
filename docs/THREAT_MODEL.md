# Threat Model

A lightweight STRIDE-based threat model for a CI/CD pipeline protected by this toolkit.
The "system" is the path from a developer's commit to a deployed artifact.

## Assets
- Source code and its integrity
- CI/CD secrets (cloud creds, registry tokens, signing keys)
- Build artifacts / container images
- The pipeline's execution environment (runners)

## Trust boundaries
1. Developer workstation → Git remote
2. Git remote → CI runner
3. CI runner → cloud / registry
4. Third-party dependencies & Actions → build

## STRIDE analysis

| Threat | Example | Mitigation in this toolkit |
|--------|---------|----------------------------|
| **S**poofing | Malicious PR from a fork runs with elevated token | Least-privilege `permissions:` block; secrets not exposed to fork PRs |
| **T**ampering | Compromised dependency injects code | SCA (Trivy) + Dependabot + pinned Action versions |
| **R**epudiation | No trace of who changed a gate | Signed commits (recommended); CI logs; SARIF history |
| **I**nfo disclosure | Secret committed to repo | gitleaks on every push + local pre-push gate |
| **D**enial of service | Scan hangs the pipeline | Severity gating + per-stage isolation; jobs fail fast |
| **E**levation of privilege | IaC grants `*:*` IAM | Trivy config scan flags over-broad policies |

## Residual risks & roadmap
- **No DAST yet** → planned OWASP ZAP baseline stage.
- **No artifact signing** → planned Cosign + SBOM (Syft).
- **Runner supply chain** → pin Actions to commit SHAs (tracked issue).

## How findings are triaged
1. CI uploads SARIF → GitHub Security tab.
2. HIGH/CRITICAL block merge.
3. MEDIUM/LOW tracked as issues with a remediation SLA.
