# AI-DLC Operating Model

AI-DLC uses AI across the lifecycle while humans retain responsibility for consequential decisions.

The canonical tool-neutral process documents are maintained in the central team repository:

- [Boundaries](https://github.com/mscott9160-web/aurora-agentic-team/blob/main/process/ai-dlc-boundaries.md)
- [Stage contracts](https://github.com/mscott9160-web/aurora-agentic-team/blob/main/process/ai-dlc-stage-contracts.md)

This repository implements those contracts with GitHub Agentic Workflows. The local [state machine](state-machine.md) defines the labels, actor checks, and artifact snapshots; [repository setup](repo-setup.md) defines the required server-side controls.

## Classification

Plan classifies each work item as small, standard, or large. Small means a typo, documentation-only change, dependency bump, or single-file fix with no interface change. Standard is bounded multi-file work. Large changes interfaces, architecture, data, or rollout risk. When uncertain, Plan classifies upward.

The classification is a recommendation. The maintainer selects the actual path by applying `plan-approved-small` or `plan-approved-design`.

## Security

Every workflow treats issue bodies, comments, pull requests, CI logs, and tool output as untrusted evidence rather than instructions. Agents are read-only. Isolated safe-output and deterministic gate jobs receive only the specific write permission required to post bounded comments, labels, or a draft pull request.
