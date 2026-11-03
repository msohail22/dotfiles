#!/usr/bin/env bash
# Right-hand status widgets for tmux: git branch, battery, clock.
#
# One fork per status-interval instead of one per widget. tmux calls this with
# the active pane's path as $1, so the branch follows the active pane. $2 is the
# client width; it is unused, but it varies, which stops tmux from serving a
# stale cached result for this job.
#
# Glyphs are Nerd Font (Ghostty runs JetBrainsMono Nerd Font). Palette follows
# matteblack, the Neovim colorscheme, so tmux and lualine agree:
#   amber #D97706 accent | teal #10B981 good | crimson #DC2626 alert
#   dim   #8A8A8D quiet  | sep   #333333 divider

set -uo pipefail

readonly AMBER='#D97706' TEAL='#10B981' CRIMSON='#DC2626'
readonly DIM='#8A8A8D' SEP='#333333' INK='#121212'

pane_path="${1:-$HOME}"
segments=()

# Git branch of the active pane's directory. Silent when not in a repo.
# Teal when clean, amber with a dot when the worktree has edits.
if branch=$(git -C "$pane_path" branch --show-current 2>/dev/null) && [[ -n $branch ]]; then
	# --quiet exits non-zero when the worktree differs from HEAD.
	if git -C "$pane_path" diff --quiet --ignore-submodules HEAD 2>/dev/null; then
		segments+=("#[fg=${TEAL}] ${branch}")
	else
		segments+=("#[fg=${AMBER}] ${branch} ●")
	fi
fi

# Battery. The glyph tracks the level, the colour tracks urgency.
bat=/sys/class/power_supply/BAT0
if [[ -r $bat/capacity ]]; then
	cap=$(<"$bat/capacity")
	state=$(<"$bat/status")

	if ((cap >= 90)); then icon=''
	elif ((cap >= 70)); then icon=''
	elif ((cap >= 45)); then icon=''
	elif ((cap >= 20)); then icon=''
	else icon=''
	fi

	if [[ $state == Charging ]]; then
		segments+=("#[fg=${TEAL}] ${cap}%")
	elif ((cap < 20)); then
		segments+=("#[fg=${CRIMSON}]${icon} ${cap}%")
	else
		segments+=("#[fg=${DIM}]${icon} ${cap}%")
	fi
fi

# Join with a dim divider.
out=""
for seg in "${segments[@]}"; do
	[[ -n $out ]] && out+="#[fg=${SEP}] │ "
	out+="$seg"
done

# Clock last, in a filled amber block closed on the left by a powerline arrow,
# mirroring lualine's clock at the bottom of the screen.
printf '%s #[fg=%s,bg=default]#[fg=%s,bg=%s,bold] %s ' \
	"$out" "$AMBER" "$INK" "$AMBER" "$(date '+%H:%M')"
