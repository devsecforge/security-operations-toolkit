# Contributing

Thanks for your interest in improving the Security Operations Toolkit!

## Getting Started

1. Fork and clone the repo.
2. Install the tool dependencies (see [README → Installation](README.md#-installation)).
3. Create a branch: `git checkout -b feat/short-description`.

## Ground Rules

- **Shell:** all scripts must pass `shellcheck` (CI enforces this).
- **Style:** scripts start with `set -euo pipefail` and source `scripts/lib/common.sh`.
- **No secrets, ever.** The secret-scan stage runs on every PR.
- **Small PRs.** One logical change per pull request.
- **Docs:** update the README/docs when you change behavior.

## Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add DAST stage using OWASP ZAP
fix: handle missing trivy binary gracefully
docs: clarify installation on macOS
```

## Pull Requests

- Fill out the PR template.
- Ensure all CI checks pass.
- Link any related issue.

By contributing you agree your work is licensed under the project's [MIT License](LICENSE).
