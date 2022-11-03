#!/usr/bin/env bash

set -euo pipefail

tag_name="${TAG_NAME/#refs\/tags\//}"
release_name="${RELEASE_NAME/#refs\/tags\//}"
JQ_FILTER='{
  "tag_name": $tag_name,
  "name": $release_name,
  "body": $body,
  "draft": false,
  "prerelease": false
}'
RELEASE_SPEC="$(jq -c -n --arg body "$RELEASE_BODY" --arg tag_name "$tag_name" --arg release_name "$release_name" "$JQ_FILTER")"

curl -f \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $GITHUB_TOKEN" \
     -d "$RELEASE_SPEC" \
     "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" | jq -r '"Created release " + .name + " on " + .target_commitish + "\n\n" + .body'
