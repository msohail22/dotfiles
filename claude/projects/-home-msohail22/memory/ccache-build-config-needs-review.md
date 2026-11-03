---
name: ccache-build-config-needs-review
description: He does not yet understand the shared-ccache + worktree build setup on arrakis; remind him to study it.
metadata:
  node_type: memory
  type: feedback
  originSessionId: 4c0fa0b3-c06d-447f-8f4a-b3145a4cc49e
  modified: 2026-10-31T03:51:33.236Z
---

Mohammed said on 2026-10-31, about the ClickHouse build setup on the arrakis
server (shared ccache at 100 GB, one build directory per git worktree, the
15-minute master build timer): "I don't really understand this config we are
moving forward with it and constantly remind me that I would need to look into
it further as well too".

**Why:** he approved the design on trust, not on understanding. He wants the
gap flagged rather than hidden, so it does not turn into a config he cannot
debug alone later.

**How to apply:** when a reply touches ccache (`max_size`, `base_dir`,
`CCACHE_BASEDIR`, hit rates), the per-worktree build directories, or the
`clickhouse-master-build` timer, add one short line reminding him this is the
config he still needs to study. One line, not a lecture, and no repeating the
whole explanation. Relevant pieces live in [[dotfiles-is-source-of-truth]].
