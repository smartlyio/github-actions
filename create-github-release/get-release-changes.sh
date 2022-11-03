#!/usr/bin/env bash

set -euo pipefail

{
  echo 'changes<<EOF_RELEASE_CHANGES'
  echo "$PR_DATA" | jq -r '.data.search.edges[] | .node | "- " + "#" + (.number | tostring) + " " + .title + " [" + .mergeCommit.author.name + "]"'
  echo 'EOF_RELEASE_CHANGES'
} >> "$GITHUB_OUTPUT"
