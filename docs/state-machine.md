# AI-DLC State Machine

The only maintainer is `mscott9160-web`. A workflow is triggered only by a maintainer-owned request or approval label; no AI-owned status label is a trigger.

| State | Label | Who may apply it | Workflow it triggers |
| --- | --- | --- | --- |
| Plan requested | `plan-requested` | Maintainer | Plan |
| Plan proposed | `plan-proposed` | AI | None |
| Small plan approved | `plan-approved-small` | Maintainer | Implement |
| Design plan approved | `plan-approved-design` | Maintainer | Design |
| Design proposed | `design-proposed` | AI | None |
| Design approved | `design-approved` | Maintainer | Implement |
| Implementation proposed | `implementation-proposed` | AI | None |
| Review requested | `review-requested` | Maintainer | Review |
| Review proposed | `review-proposed` | AI | None |
| CI triage requested | `ci-triage-requested` | Maintainer | CI Triage after a failed CI run |
| CI triage proposed | `ci-triage-proposed` | AI | None |
| Release requested | `release-requested` | Maintainer | Release |
| Release proposed | `release-proposed` | AI | None |
| Incident triage requested | `incident-triage-requested` | Maintainer | Operate |
| Incident proposed | `incident-proposed` | AI | None |

## Approval checks

Every gated workflow reads the label event from the issue or pull request timeline. It stops after one explanatory comment unless the required label exists and its actor is `mscott9160-web`. Approval labels never appear in a safe-output label allowlist.

## Handoff artifacts

| Stage | Artifact | Next stage reads | Snapshot check |
| --- | --- | --- | --- |
| Plan | One issue comment marked `<!-- ai-dlc-plan-artifact -->` | Design or Implement | The comment must exist and its `updated_at` must not be later than the approval-label event. |
| Design | One issue comment marked `<!-- ai-dlc-design-artifact -->` | Implement | The comment must exist and its `updated_at` must not be later than the approval-label event. |
| Implement | One draft pull request | Review and CI Triage | The PR links to the source issue and quotes implemented acceptance criteria. |
| CI Triage | One PR comment | Developer | It reads only failed CI evidence before merge. |

Plan uses `plan-approved-small` only for the documented small classification. Standard and large plans require `plan-approved-design`, then `design-approved`, before Implement can run.