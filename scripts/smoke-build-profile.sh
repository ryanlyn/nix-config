#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  printf 'usage: %s <flake-attribute>\n' "$0" >&2
  exit 64
fi

nix build --no-link ".#$1"
