---
name: read-docs-before-acting
description: Read official docs and the real code before doing a task; never work from memory.
metadata:
  type: feedback
---

Before starting any task, read the actual source of truth: the official documentation
for the tool or flag, the code in the repo that the task touches, and the installed
version. Then act. Say which document was read and what it said.

**Why:** memory goes stale. Concrete case on 2026-10-19: the Claude Code setting
`includeCoAuthoredBy` was written into his `settings.json` from memory, but the docs
showed it has been deprecated since v2.0.62 and replaced by `attribution`. Reading the
docs caught it.

**How to apply:** if docs and memory disagree, the docs win. Check the version too, as
flags differ between versions. Related: [[dotfiles-is-source-of-truth]].
