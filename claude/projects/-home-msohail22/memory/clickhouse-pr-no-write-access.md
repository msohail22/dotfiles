---
name: clickhouse-pr-no-write-access
description: On ClickHouse/ClickHouse he has pull access only; PRs move by maintainer self-assignment, not by requesting reviewers.
metadata:
  type: project
---

On `ClickHouse/ClickHouse` his permissions are `pull: true` only — `push`, `triage`,
`maintain` and `admin` are all false (verified 2026-10-21 via
`gh api repos/ClickHouse/ClickHouse --jq .permissions`). So he CANNOT request or assign
reviewers, add the `can be tested` label, approve, or merge. GitHub's docs are explicit:
"To request a review, you need write access to the repository."

His PRs merge when a ClickHouse maintainer **self-assigns**. Across his 6 merged PRs
(121890, 122273, 122447, 122457, 122519, 122565) `requested_reviewers` was empty on all
six and `assignees` held the person who then approved and merged, within 1-6 days.

The only lever he has is a PR comment. The measurable difference: PRs where he
@-mentioned the one human already tied to that code or issue got picked up (122565 named
rschu1ze, who had suggested the feature in #37288 — merged in 2 days). PRs where he wrote
"can anyone review this pr" or addressed the `clickgapai`/Codex bots are the ones still
open. The merge gate also needs `CH Inc sync` green, which produces the
`pr-synced-to-cloud` label: all 6 merged PRs have that label, none of the open ones do.

**Why:** suggesting `gh pr edit --add-reviewer` wastes his time with a 403, and treating
an AI-reviewer thread as the gate is what stalled 5 PRs.

**How to apply:** for a stuck ClickHouse PR, run git blame on the changed file, resolve
every bot ❌ thread first, then write one comment naming the blame owner with a concrete
repro. Never suggest assigning, labelling or requesting review. See
[[read-docs-before-acting]].
