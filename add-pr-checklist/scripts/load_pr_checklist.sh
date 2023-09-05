#!/usr/bin/env bash
set -euo pipefail
DIR="$(dirname "$(readlink -f "$0")")"

CHECKLIST_FILE="${CHECKLIST_FILE:-}"

DEFAULT_CHECKLIST_FILE="$(readlink -f "$DIR/../assets/PR_CHECKLIST.md")"

if [[ -z "$CHECKLIST_FILE" ]] || [[ ! -f "$CHECKLIST_FILE" ]]; then
  # Use default file
  echo "Using default checklist file: $DEFAULT_CHECKLIST_FILE"
  echo "checklist_file=$DEFAULT_CHECKLIST_FILE" >> "$GITHUB_OUTPUT"
  exit 0
fi

CHECKLIST_FILE="$(readlink -f "$CHECKLIST_FILE")"
echo "Using custom checklist file: $CHECKLIST_FILE"
echo "checklist_file=$CHECKLIST_FILE" >> "$GITHUB_OUTPUT"

# BUMP