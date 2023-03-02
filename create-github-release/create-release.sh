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

echo "Creating release:"
echo "$RELEASE_SPEC" | jq .

echo "Checking for existing release"
if response="$(curl -f \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $GITHUB_TOKEN" \
     "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/tags/$tag_name")"; then
    body_matches="$(echo "$response" | jq --arg body "$RELEASE_BODY" -r '.body == $body')"
    if [[ "$body_matches" == "true" ]]; then
        echo "Release already exists with the same content"
        exit 0
    else
        echo -e "Release already exists with a different description:\n\n"
        echo "$response" | jq .
        exit 1
    fi
fi

if ! response="$(curl -f \
     -H "Content-Type: application/json" \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer $GITHUB_TOKEN" \
     -d "$RELEASE_SPEC" \
     "https://api.github.com/repos/$GITHUB_REPOSITORY/releases")"; then
    echo "Failed to create release:"
    echo "$response"
    exit 1
else
    echo "$response" | jq -r '"Created release " + .name + " on " + .target_commitish + "\n\n" + .body'

    {
      echo "release-id=$(echo "$response" | jq -r '.id')"
    } >> "$GITHUB_OUTPUT"
fi
