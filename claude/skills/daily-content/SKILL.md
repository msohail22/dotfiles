---
name: daily-content
description: Use when drafting the daily tweets, writing up a merged PR, a Codeforces session, a low-level-lab update or a personal opinion, or when publishing a learning blog to msohail22.github.io. Triggers on "daily content", "draft today's tweets", "write up this PR", "publish the blog".
---

# Daily content

## Overview

One folder per day. Six files in it. Five are tweet drafts only. One — `learning-blog.md`
— is the only thing that ever becomes a blog post on the site, and the only tweet that
carries a URL.

```
blog-automation/
├── scripts/gather.sh         read-only; fills today's folder from gh + codeforces
├── archive/                  the pre-2026-10-25 posts
└── daily/YYYY-MM-DD/
    ├── prs.md                tweet only
    ├── learning-blog.md      tweet + PUBLISHED to msohail22.github.io
    ├── codeforces.md         tweet only
    ├── low-level-lab.md      tweet only
    ├── home-server.md        tweet only
    └── opinions.md           tweet only
```

**The X API is not used and must not be suggested.** It is pay-per-usage with no free
tier, and a post containing a URL costs $0.20 (verified at docs.x.com/x-api/getting-started/pricing).
Every tweet here is text in a file that Mohammed pastes into x.com himself. Never offer to
post one automatically.

## Procedure

```sh
# 1. Gather. Read-only. Creates the day folder and the five files if absent.
~/Github/notes/blog-automation/scripts/gather.sh            # today
~/Github/notes/blog-automation/scripts/gather.sh 2026-10-23 # a past day
```

It writes two hidden raw files beside the five: `.raw-prs.md` and `.raw-codeforces.md`.
Those are evidence, not output. Read them, then write the tweet into the real file.

2. Fill each file that has material. Leave a file untouched when nothing happened —
   an empty day is a true day. Do not invent activity.

## Empty days

Some days have nothing. That is normal and it is not a failure.

When `.raw-prs.md` and `.raw-codeforces.md` both report nothing, and Mohammed has not
said what else he did, **write no tweet.** Leave the six files as frontmatter only with
`status: draft`. Report "nothing to post today" and stop.

"Daily" describes the cadence of *checking*, not a quota of tweets. There is no duty to
produce one. Specifically, never:

- re-tweet an older merged PR as if it landed today
- turn reading or setup into a claimed "learning"
- write an opinion Mohammed has not stated
- round a day with no accepted submissions up to a Codeforces tweet

An empty file is honest. A padded one makes him defend a claim that is not true.

3. For `learning-blog.md` only, publish. See **Publishing a learning blog** below.

## The tweet files

Every file carries this frontmatter:

```yaml
---
day: 2026-10-25
kind: prs
status: draft        # draft | ready | tweeted
tweeted: no          # no | yes
---
```

Then the tweet text, as a fenced block so a paste is exact:

````
```tweet
Got my Arrow IPC metadata-version fix merged into @ClickHouseDB.

A 120-byte file claimed a format version that does not exist. ClickHouse
read it and reported a schema. Now it refuses.

#ClickHouse #OpenSource #CPlusPlus
```
````

Rules for the text:

- **280 characters, counted.** Count it; do not estimate. A URL counts as 23 regardless
  of real length.
- One tweet per fenced block. Several blocks in one file means several tweets.
- **ASD-STE100**: active voice, one idea per sentence, simple words.
- Lead with the result, not the setup. "Got it merged" before "I was reading".
- No emoji unless Mohammed asks. No "excited to share". No thread-bait.

### Project handles — verified only

| Project | Handle | Source of truth |
|---|---|---|
| ClickHouse | `@ClickHouseDB` | `~/Github/ClickHouse/README.md:32` |
| LLVM | **none** | `README.md` lists only Discourse and Discord |

**Never guess a handle.** If a project's handle is not in this table, read that project's
own `README.md` first. No handle found means hashtags only. A wrong @ tags a stranger.

### Per-file content

- **`prs.md`** — one tweet per PR that changed state today. State the defect and the fix in
  plain words, then tag the project and hashtag it. `.raw-prs.md` gives state, repo, number
  and URL. A **merged** PR is the brag; an opened one is "sent", not "landed". Never claim
  a merge that `gh` reports as `open`.
- **`learning-blog.md`** — the one that gets published. Needs a real outward source.
- **`codeforces.md`** — from `.raw-codeforces.md`, which lists problems accepted today,
  deduped, with rating. Tweet the idea learned, not the count. `#Codeforces`.
  Day boundaries are **local time (IST)**; jq's `strftime` is UTC, so never cross-check
  a date with it.
- **`low-level-lab.md`** — `msohail22/low-level-lab` work. Own repo, so no project tag.
- **`home-server.md`** — one change to the home server: what broke, what fixed it, what
  the hardware is. The long-form record lives in `notes/home-server/`; this file is the
  short public note drawn from it. No vendor is tagged unless Mohammed names one.
  A blog post that grows out of this takes `lane: homelab`.
- **`opinions.md`** — Mohammed's own take. Write nothing here unless he states the opinion.
  Do not generate opinions for him.

## Publishing a learning blog

Only `learning-blog.md` reaches the site. The site is Astro 7 + Preact at
`~/Github/msohail22.github.io`, which reads this repo through the git-ignored
`notes-content` symlink at build time. Nothing is copied.

**Pushing the notes repo does NOT publish.** No webhook watches it. The site rebuilds on a
push to the *site* repo, on a 06:00 UTC cron, or on a manual trigger. Push and walk away
and the post sits unpublished for up to a day.

### Frontmatter contract

Validated by a Zod schema at build time. A wrong enum fails the build, not the page.

```yaml
---
title: My first Linux kernel patch
slug: first-linux-kernel-patch
date: 2026-10-07
topic: linux-kernel
tags: [kernel, checkpatch]
status: done        # seed | drafting | done
lane: none          # clickhouse | homelab | low-level-lab | problem-solving | none
blog: ready         # no | ready | published
source: https://github.com/ClickHouse/ClickHouse/pull/125224
summary: One sentence. Used for the meta description and the RSS item.
---
```

`blog: ready` is the publish switch. Without it the post builds into nothing, silently.

`slug:` is the URL — `/blog/<slug>/`. Kebab-case, lowercase, no date. The build *fails*
with a named error if a `blog: ready` post has no slug, which is deliberate: a missing
slug is loud, while a missing `blog: ready` is silent.

`gather.sh` writes `learning-blog.md` with `title: ''`, `topic: unsorted` and `blog: no`.
That stub is valid on purpose — the Astro site globs the file whether or not it holds a
post, so an incomplete stub would break the build on an empty day. Fill in the real title,
topic, slug and summary when the post is written.

**`source:` must point OUTWARD** — at the pull request, commit, patch, mailing-list thread
or contest the post came from. Never at the post itself, and never at this repo.
A post that cites its own file is an update pretending to be an artifact.

Verify the source before publishing:

```sh
gh pr view <url> --json state,title,mergedAt
```

**No real external source? The post is not ready.** Say so rather than inventing one.

**`lane:`** is the audience thread the post feeds, not its subject. A post about C++ memory
ordering is `lane: none` unless it came out of ClickHouse work.

### Writing rules

- **ASD-STE100**: active voice, simple tenses, one idea per sentence, 20 words for
  instructions and 25 for description, six sentences per paragraph maximum.
- **First principles**: how it is really implemented, the design decision behind it, who
  made it and why, and the history. Not a summary.
- **Diagrams**: inline SVG, animated with CSS, coloured with `currentColor` so it follows
  the theme. Give box shapes an opaque `fill: var(--paper, #fff)` or connecting lines show
  through them and read as strikethrough.
- Use Mohammed's own words and real commands wherever notes already exist. Do not invent
  technical claims he will be asked to defend.

### Steps

```sh
# 1. Build locally BEFORE pushing. This catches a bad enum or a missing field.
cd ~/Github/msohail22.github.io
ln -sfn ../notes notes-content      # once per machine; git-ignored
npm run build                        # the post must appear in the route list
```

2. **Hand the git commands to Mohammed. Never run them.** Print one copy-ready block with
   real paths and the real commit message: the notes `git add`/`commit`/`push`, then
   `gh workflow run deploy.yml --repo msohail22/msohail22.github.io`. Step 3 of that block
   is what actually publishes; the push alone does not.

3. After it is live and the URL resolves, write the tweet into `learning-blog.md` with the
   `msohail22.github.io` URL. **Only ever that URL** — never a cross-post's.

## Cross-posting

There is none, by decision. Hashnode retired free GraphQL API access on 2026-05-13 and now
requires a $5/month Pro plan per publication; `gql.hashnode.com` also 301s away and the
live endpoint is `gql-beta.hashnode.com`. Do not propose Hashnode, dev.to or Medium
automation unless Mohammed raises it. He is not paying for this pipeline.
