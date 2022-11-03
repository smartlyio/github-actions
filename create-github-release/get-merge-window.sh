#!/usr/bin/env bash

set -euo pipefail

this_tag="${TAG_NAME/#refs\/tags\//}"

recent_tags="$(git tag --sort=creatordate --list 'v*' | grep -P 'v\d+\.\d+\.\d+' | grep --color=no -B1 "^$this_tag\$")"
previous_tag="$(echo "$recent_tags" | head -n1)"

previous_tag_date="$(git log -1 --tags --no-walk --pretty="format:%cI" "$previous_tag")"
this_tag_date="$(git log -1 --tags --no-walk --pretty="format:%cI" "$this_tag")"

start_date="$(date -Is -d "$previous_tag_date")"
end_date="$(date -Is -d "$this_tag_date")"

{
  echo "start_date=$start_date"
  echo "end_date=$end_date"
} >> "$GITHUB_OUTPUT"
