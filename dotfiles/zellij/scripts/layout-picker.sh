#!/usr/bin/env bash
set -euo pipefail

layouts_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zellij/layouts"

[ -d "$layouts_dir" ] || {
  echo "No layouts directory: $layouts_dir" >&2
  exit 1
}

choice="$(
  find "$layouts_dir" -maxdepth 1 -type f \( -name '*.kdl' -o -name '*.yaml' -o -name '*.yml' \) \
    -printf '%f\n' \
    | sed -E 's/\.(kdl|yaml|yml)$//' \
    | sort -u \
    | fzf --prompt='Layout > ' --height=40% --reverse --border
)"

[ -n "${choice:-}" ] || exit 0

zellij -s "$choice" -n "$choice"
