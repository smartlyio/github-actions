#!/usr/bin/env bash
set -Eeumo pipefail

tag_prefix="$TAG_PREFIX"
label_name="$LABEL_NAME"

latest_tag=$(git tag --list --sort=-version:refname "${tag_prefix}v*" | head -n 1 || true)
if [[ -z "$latest_tag" ]]; then
  latest_tag="${tag_prefix}v0.0.0"
fi
tag_without_prefix=$(echo "$latest_tag" | sed -E "s/^${tag_prefix}v//")

if [[ "$tag_without_prefix" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  major=${BASH_REMATCH[1]}
  minor=${BASH_REMATCH[2]}
  patch=${BASH_REMATCH[3]}

  case "$label_name" in
    major)
      major=$((major+1))
      minor=0
      patch=0
      ;;
    minor)
      minor=$((minor+1))
      patch=0
      ;;
    patch)
      patch=$((patch+1))
      ;;
  esac

  new_tag="${tag_prefix}v${major}.${minor}.${patch}"
  echo "The new tag is: $new_tag"
  echo "new_tag=$new_tag" >> "$GITHUB_OUTPUT"
else
  echo "Bad tag format";
  exit 1
fi
