# Repository Setup

Run the setup script from a trusted local checkout after authenticating `gh` as an administrator or repository owner:

```powershell
./scripts/setup-repository.ps1 -Repo owner/repository -Maintainer mscott9160-web
```

The script is idempotent. It creates missing state-machine labels, enforces pull-request branch protection on `main`, disables force pushes, requires one approving review, and creates the `production` environment with the maintainer as required reviewer. Re-running it reports unchanged settings.

The starter ships the `Validate Agentic Workflows` required check. Supply project checks as well with `-RequiredCheck 'Validate Agentic Workflows','Project CI'`.

The script does not create, print, or store tokens. Manually add the `COPILOT_GITHUB_TOKEN` Actions secret in the repository settings after confirming that the token is authorized for GitHub Copilot CLI use.

Deploy jobs must set `environment: production`. AI-DLC workflows do not deploy.

For CI Triage, replace the starter branch patterns in `ai-dlc-ci-triage.md` with the project's approved development branch patterns before enabling it.