#!/usr/bin/env bash
set -Eeumo pipefail

tag_prefix="$TAG_PREFIX"
latest_tag="$LATEST_TAG"
force_push="$FORCE_PUSH"
tag_without_prefix=$(echo "$latest_tag" | sed -E "s/^${tag_prefix}v//")

if [[ "$tag_without_prefix" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  major=${BASH_REMATCH[1]}

  branch_name="${tag_prefix}v${major}"

  if [[ "$force_push" == "true" ]]; then
    git branch -d "$branch_name" || true
  fi

  # Create and push branch
  git checkout -b "$branch_name"
  git branch --set-upstream-to="origin/$branch_name" || true

  if [[ "$force_push" == "true" ]]; then
    git push --force -u origin "$branch_name"
  else
    git push -u origin "$branch_name"
  fi

else
  echo "Bad tag format";
  exit 1
fi