#!/usr/bin/env bash

set -euo pipefail

tag_search="${TAG_SEARCH_PREFIX}*"
this_tag="${TAG_NAME/#refs\/tags\//}"

tags_list="$(git tag --sort=creatordate --list "$tag_search")"
if [[ "$TAG_SEARCH_REGEX" == "" ]]; then
    filtered_tags_list="$tags_list"
else
    filtered_tags_list="$(echo "$tags_list" | grep -P "$TAG_SEARCH_REGEX")"
fi
recent_tags="$(echo "$filtered_tags_list" | grep --color=no -B1 "^$this_tag\$")"
previous_tag="$(echo "$recent_tags" | head -n1)"

previous_tag_date="$(git log -1 --no-walk --pretty="format:%cI" "$previous_tag")"
this_tag_date="$(git log -1 --no-walk --pretty="format:%cI" "$this_tag")"

start_date="$(date -Is -d "$previous_tag_date")"
end_date="$(date -Is -d "$this_tag_date")"

echo "Previous tag: $previous_tag at $start_date"
echo "This tag: $this_tag at $end_date"

{
  echo "start_date=$start_date"
  echo "end_date=$end_date"
} >> "$GITHUB_OUTPUT"
