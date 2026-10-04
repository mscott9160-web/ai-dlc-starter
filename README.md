# AI-DLC Starter

A reusable, mechanically human-gated set of GitHub Agentic Workflows for the software development lifecycle.

## Lifecycle

| Stage | Workflow | Human gate |
|---|---|---|
| Plan | `ai-dlc-plan.md` | Apply `plan-requested` |
| Design | `ai-dlc-design.md` | Apply `plan-approved-design` to the unchanged Plan artifact |
| Implement | `ai-dlc-implement.md` | Apply `plan-approved-small`, or `design-approved` after Design |
| Review | `ai-dlc-review.md` | Apply `review-requested`; a human merges later |
| CI Triage | `ai-dlc-ci-triage.md` | Apply `ci-triage-requested` before a failed CI run is triaged |
| Release | `ai-dlc-release.md` | Apply `release-requested`; a human deploys outside the workflow |
| Operate | `ai-dlc-operate.md` | Apply `incident-triage-requested`; an incident commander approves remediation |

Small work bypasses Design only when the maintainer applies `plan-approved-small`. Standard and large work require Plan, Design, and Design approval before Implement. See [docs/state-machine.md](docs/state-machine.md).

## Use in a project

1. Tag a release of this repository, for example `v1.0.0`.
2. Install workflows from the pinned source with `gh aw add mscott9160-web/ai-dlc-starter/.github/workflows/ai-dlc-plan.md@v1.0.0`, then repeat for the remaining workflow source files.
3. Update installed workflows with `gh aw update`; gh-aw tracks each workflow's `source` automatically.
4. Run `./scripts/setup-repository.ps1 -Repo owner/repository -Maintainer mscott9160-web`.
5. Configure `COPILOT_GITHUB_TOKEN` manually as a repository Actions secret.
6. Compile with `gh aw compile --validate --approve` and run the fixtures in [evals/README.md](evals/README.md).

The shared tool-neutral policy lives in [Aurora Agentic Team](https://github.com/mscott9160-web/aurora-agentic-team/tree/main/process). This repository references it rather than copying process contracts.

Read [docs/ai-dlc-operating-model.md](docs/ai-dlc-operating-model.md) before enabling workflows.
See [docs/gh-aw-compatibility.md](docs/gh-aw-compatibility.md) for the verified marked-comment workaround.
