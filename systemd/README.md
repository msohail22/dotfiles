# The 15-minute ClickHouse master build

Keeps a fresh `clickhouse` binary built from `upstream/master` on this laptop,
so a current binary is ready without waiting hours for a build.

## The three parts

```
    systemd user manager
            |
            |  every 15 min: :00 :15 :30 :45
            v
  clickhouse-master-build.timer       <- WHEN to run
            |
            |  starts
            v
  clickhouse-master-build.service     <- HOW to run it (priority, limits)
            |
            |  runs
            v
  ~/.local/bin/ch-master-build        <- WHAT to do (the actual work)
```

A **timer** holds only a schedule. It cannot do work. It starts a **service**.
A service is one process with rules attached: how low its priority is, how much
memory it may use, how long it may take. The service runs the **script**, which
is where every git and ninja command lives.

Everyday comparison: the timer is an alarm clock, the service is the house rule
that says "do chores quietly and stop by midnight", and the script is the chore
list.

Files in this repository (`install.sh` symlinks all three into place):

| Repository file | Lands at |
|---|---|
| `bin/ch-master-build` | `~/.local/bin/ch-master-build` |
| `systemd/user/clickhouse-master-build.service` | `~/.config/systemd/user/` |
| `systemd/user/clickhouse-master-build.timer` | `~/.config/systemd/user/` |

Everything is a **user** unit, so every command needs `--user`. Without it,
systemd looks at system units, finds nothing, and says the unit does not exist.

## What one tick actually does

```
 tick
  |
  v
 take the lock ---- held by another run? ---> say "skip", exit 0
  |
  v
 on AC power? ------ no ---------------------> say "skip", exit 0
  |
  v
 >= 80 GB free? ---- no ---------------------> ERROR, exit 1
  |
  v
 git fetch upstream master -- unreachable? --> say "skip", exit 0
  |
  v
 new SHA == .built-sha and binary exists? ---> say "skip", exit 0
  |
  v
 git reset --hard <new SHA> in the worktree
 contrib/update-submodules.sh
 cmake (Debug) + ninja clickhouse  > build.log
  |
  v
 move the ~/.local/bin/clickhouse-master symlink, write .built-sha
```

Note the difference between the two exits. `exit 0` after "skip" means nothing
needed doing, which is the normal case. `exit 1` means something is wrong and
the unit is marked failed, so it shows up in `systemctl --user status`.

## Debugging: the commands, and what each one is for

### Is it armed, and when does it next run?

```bash
systemctl --user list-timers clickhouse-master-build.timer
```

Five columns: `NEXT` is the next firing, `LEFT` how long until then, `LAST` the
previous firing, `PASSED` how long since, `ACTIVATES` the service it starts.

If the unit is not listed at all, the timer is not enabled:

```bash
systemctl --user is-enabled clickhouse-master-build.timer   # want: enabled
systemctl --user enable --now clickhouse-master-build.timer
```

### Is a build running right now?

```bash
systemctl --user is-active clickhouse-master-build.service
```

Three answers worth knowing:

- `activating` — **a build is running.** This is the normal busy state.
- `inactive` — idle, waiting for the next tick. Also normal.
- `failed` — the last run exited non-zero. Read the journal.

`active` almost never appears. `Type=oneshot` without `RemainAfterExit` goes
`inactive -> activating -> inactive`, so it skips `active` entirely. Do not read
`activating` as "stuck starting"; for a oneshot it means "doing the work".

### What is it doing, and what did it say?

```bash
# Follow live.
journalctl --user -fu clickhouse-master-build.service

# The last run only, newest at the bottom.
journalctl --user -u clickhouse-master-build.service -n 50 --no-pager

# Everything since this boot.
journalctl --user -u clickhouse-master-build.service -b --no-pager

# Just one day.
journalctl --user -u clickhouse-master-build.service --since 2026-10-29 --no-pager
```

The journal holds the script's own `say` lines: which SHA it is building, which
guard made it skip, whether it finished. It does **not** hold the compiler
output — that goes to a file, because tens of thousands of lines per build would
flood the journal:

```bash
tail -f ~/Github/worktrees/latest-build/build_master/build.log
rg -n "error:" ~/Github/worktrees/latest-build/build_master/build.log
```

### Why did it not build?

Run the script by hand. It prints the reason and exits:

```bash
~/.local/bin/ch-master-build
```

This is safe at any time. The lock makes a hand run and a timer run take turns
rather than collide. Expect one of:

| Message | Meaning | What to do |
|---|---|---|
| `skip: another build holds ...` | a build is already running | wait, or watch the journal |
| `skip: on battery` | the AC guard tripped | plug in, or `CH_ALLOW_BATTERY=1 ch-master-build` |
| `skip: cannot reach upstream (offline?)` | no network | nothing; the next tick retries |
| `skip: master unchanged at <sha>` | already current | nothing; this is success |
| `ERROR: only NNG free, need 80G` | disk guard | `ninja -C <build> -t clean`, or raise `CH_MIN_FREE_GB` |

### Did a tick get skipped because the previous build was still running?

That is by design, and systemd does it, not the script. A timer **will not start
a second instance, or queue one, while the triggered unit is still running.**
The `flock` in the script is only a backstop for a run started from a shell.

To see it for yourself, while a build is running:

```bash
systemctl --user start --no-block clickhouse-master-build.service
journalctl --user -u clickhouse-master-build.service | rg -c "Starting Build"
```

The count does not go up. The second start job merges into the running one.

`--no-block` is not optional here. A plain `systemctl --user start` on a running
oneshot waits for the job to finish, so it would hang for hours.

### Monitor it in one command

One-shot answer to "what is going on":

```bash
systemctl --user --no-pager --lines=5 status clickhouse-master-build.service
```

Live, refreshing every 5 seconds — state, next firing, and how many object
files exist so far, which is the only honest progress bar a cold build has:

```bash
watch -n5 '
  B=$HOME/Github/worktrees/latest-build/build_master
  echo "state : $(systemctl --user is-active clickhouse-master-build.service)"
  systemctl --user list-timers clickhouse-master-build.timer --no-pager | sed -n 2p
  echo "built : $(find "$B" -name "*.o" 2>/dev/null | wc -l) object files"
  echo "sha   : $(cat "$B/.built-sha" 2>/dev/null || echo "(none published yet)")"
  echo
  tail -n 5 "$B/build.log" 2>/dev/null || echo "(no build.log yet: submodules or cmake)"
'
```

Read `state` as: `activating` means building, `inactive` means idle and waiting,
`failed` means the last run exited non-zero. During the submodule and cmake
phases there is no `build.log` and no object files yet, so use the journal
instead:

```bash
journalctl --user -fu clickhouse-master-build.service
```

### Known failure: a submodule clone that was interrupted

Symptom, repeating every tick, with the service exiting `123`:

```
fatal: Unable to find current revision in submodule path 'contrib/<name>'
```

`123` is `xargs` reporting that one of its 163 child commands failed.

The message is about the submodule's **current** HEAD, not the commit being
checked out - which is the trap, because it reads like the target is missing.
When a run is killed during the submodule phase, a half-made clone is left
behind. Git had created the directory and the gitdir but had not yet set a
branch, so it wrote the placeholder `ref: refs/heads/.invalid` into HEAD and
fetched no refs. Every later `git submodule update` then fails trying to read
where that clone currently is.

Everyday comparison: the removal van has the address of the new house, but the
old house has been demolished, so there is nothing to move out of.

Diagnose it in this order. Only the second command tells the truth:

```bash
cd ~/Github/worktrees/latest-build
S=contrib/google-cloud-cpp           # the path from the error message
pin=$(git ls-tree HEAD "$S" | awk '{print $3}')

# Is the TARGET object present? "commit" means yes - not the problem.
git -C "$S" cat-file -t "$pin"

# Is the CURRENT HEAD broken? ".invalid" with no refs listed means yes.
cat "$(git -C "$S" rev-parse --git-dir)/HEAD"
git -C "$S" for-each-ref | head
```

Fix it by giving HEAD a real value. Fetch first only if `cat-file` said the
object is missing:

```bash
git -C "$S" fetch --depth=1 origin "$pin"    # only if the object is missing
git -C "$S" switch --detach "$pin"
git submodule status "$S"                    # leading space = in sync
```

A leading `-` in `submodule status` means not initialized, `+` means it sits on
a different commit than the pin, and a leading space means correct.

To check every submodule at once for this fault:

```bash
fd -H -t f '^HEAD$' ~/Github/ClickHouse/.git/worktrees/latest-build/modules \
  -x sh -c 'grep -q "\.invalid" {} && echo {}'
```

Ignore any hit under `logs/HEAD` - that is a reflog, not the real HEAD.

### Checking the units without installing them

```bash
# Syntax and directive check.
systemd-analyze verify systemd/user/clickhouse-master-build.service

# Does the schedule mean what it looks like?
systemd-analyze calendar '*:0/15' --iterations=6

# Is a timespan valid?
systemd-analyze timespan 20h
```

`systemd-analyze calendar` is the one to reach for whenever an `OnCalendar=`
line is in doubt. It prints the normalized form and the next few firings, so a
wrong guess shows up immediately instead of silently never running.

### After editing a unit in this repository

systemd caches unit files. It does not notice an edit on its own:

```bash
systemctl --user daemon-reload
systemctl --user restart clickhouse-master-build.timer
```

Editing the **script** needs no reload — the service runs it fresh every tick.
Editing a **unit** always needs `daemon-reload`.

To see what systemd currently believes, after any reload:

```bash
systemctl --user cat clickhouse-master-build.service        # the file as loaded
systemctl --user show -p MemoryHigh -p Nice -p TimeoutStartUSec \
    clickhouse-master-build.service                         # the values in force
```

`cat` shows the text; `show` shows the parsed result. When the two disagree, a
`daemon-reload` was missed.

### Stopping it

```bash
# Stop the build that is running now. The next tick still fires.
systemctl --user stop clickhouse-master-build.service

# Stop the schedule. Nothing new starts.
systemctl --user stop clickhouse-master-build.timer

# Turn it off across reboots too.
systemctl --user disable --now clickhouse-master-build.timer
```

Stopping the *service* alone does not disarm the schedule — systemd will warn
that the triggering unit is still active. Stop or disable the **timer** to
actually stop the loop.

### Does it survive logout and reboot?

User units stop at logout unless lingering is on:

```bash
loginctl show-user "$USER" | rg Linger      # want: Linger=yes
loginctl enable-linger "$USER"
```

With `Linger=yes` the timer runs from boot, before any login, and keeps running
after logout. `Persistent=true` in the timer covers the other case: if the
machine was asleep or off across a tick, one missed run happens on wake instead
of being lost.

### Is the resource throttling actually doing anything?

```bash
systemctl --user show -p ControlGroup clickhouse-master-build.service
cat /sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/cgroup.subtree_control
```

The second command lists the controllers delegated to the user manager. On this
machine it prints `cpu memory pids`. Because `io` is absent, `IOSchedulingClass=`
and `IOWeight=` in the service file have no effect here, and the service file
says so in a comment. `Nice=`, `CPUWeight=`, `MemoryHigh=` and `MemorySwapMax=`
all do work.

### Which commit is the published binary?

```bash
cat ~/Github/worktrees/latest-build/build_master/.built-sha
~/.local/bin/clickhouse-master --version
readlink -f ~/.local/bin/clickhouse-master
```

`.built-sha` is written **only after a successful build**, which is what makes
the "did master change?" check honest. A build that failed or was killed leaves
the old value, so the next tick retries the same commit instead of wrongly
deciding it is up to date.

## Tunables

Every one is an environment variable with a default, so a one-off run can
override it without editing the script:

| Variable | Default | Purpose |
|---|---|---|
| `CH_REPO` | `~/Github/ClickHouse` | main checkout, used read-only |
| `CH_REMOTE` | `upstream` | **not `origin`** — the fork's master is tens of thousands of commits behind |
| `CH_WORKTREE` | `~/Github/worktrees/latest-build` | the disposable worktree |
| `CH_BUILD` | `$CH_WORKTREE/build_master` | build tree |
| `CH_MIN_FREE_GB` | `80` | disk guard |
| `CH_SUBMODULE_PROCS` | `8` | parallel submodule fetches |
| `CH_ALLOW_BATTERY` | `0` | set to `1` to build on battery |

Example: a one-off build on battery, ignoring the disk guard.

```bash
CH_ALLOW_BATTERY=1 CH_MIN_FREE_GB=10 ~/.local/bin/ch-master-build
```

## One warning

The worktree at `$CH_WORKTREE` is **disposable**. Every run does
`git reset --hard` on it and on every submodule. Never leave work there. Work in
the main checkout at `$CH_REPO`, which this script only ever fetches into and
never changes branch on.
