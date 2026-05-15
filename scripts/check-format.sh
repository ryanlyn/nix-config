#!/usr/bin/env bash
set -euo pipefail

mapfile -t nix_files < <(
  git ls-files --cached --others --exclude-standard '*.nix' |
    while IFS= read -r path; do
      [ -f "$path" ] && printf '%s\n' "$path"
    done
)

if [ "${#nix_files[@]}" -eq 0 ]; then
  exit 0
fi

nixfmt --check "${nix_files[@]}"
