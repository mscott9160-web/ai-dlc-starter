# Changelog

## Unreleased

- Added maintainer-verified state labels, deterministic gates, and immutable approval snapshots for Plan and Design handoffs.
- Added small, standard, and large classification with a maintainer-selected small-change bypass.
- Renamed Validate to CI Triage and positioned it before merge.
- Added repository setup documentation and an idempotent GitHub CLI setup script.
- Added five rerunnable evaluation fixtures for each workflow.
- Replaced copy-paste installation guidance with `gh aw add` and `gh aw update` source tracking.
- Moved shared boundaries and stage contracts to the central Aurora Agentic Team process repository.
- Departure from gh-aw documentation: dynamic `add-comment.allows-comment-ids` expressions do not compile in gh-aw v0.89.21 or v0.90.3. Plan and Design use bounded custom safe-output jobs instead.