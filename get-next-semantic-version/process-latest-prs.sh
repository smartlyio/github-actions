#!/usr/bin/env bash

set -euo pipefail

FILTERED_PR_DATA="$(echo "$PR_DATA" | jq --arg commit "$LAST_TAG_COMMIT" '.search.edges[] | select(.node.mergeCommit.oid != $commit)')"

echo "$FILTERED_PR_DATA"

version=$(echo "$FILTERED_PR_DATA" | grep -m1 -oi major || echo "$PR_DATA" | grep -m1 -oi minor || echo "$PR_DATA" | grep -m1 -oi patch || echo "")
version_lower="${version,,}"
{
  echo "version=$version_lower"
  if [ -z "$version" ]; then
    echo "continue_release=false"
  else
    echo "continue_release=true"
  fi
} >> "$GITHUB_OUTPUT"

cat "$GITHUB_OUTPUT"
