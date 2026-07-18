# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| main    | ✅        |

## Reporting a Vulnerability

If you discover a security issue in this toolkit:

1. **Do not** open a public issue.
2. Use GitHub's **[Private vulnerability reporting](https://github.com/devsecforge/security-operations-toolkit/security/advisories/new)** (Security tab → "Report a vulnerability").
3. Include: affected file/script, reproduction steps, and impact.

You'll receive an acknowledgement within **72 hours** and a remediation timeline after triage.

## Scope

This project runs third-party scanners (Trivy, Semgrep, gitleaks). Vulnerabilities in those
upstream tools should be reported to their respective maintainers; issues in **how this toolkit
invokes or configures them** are in scope here.
