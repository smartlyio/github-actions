#!/usr/bin/env bash

set -euo pipefail

if [ -f action.yml ]; then
  RUNS_USING="$(yq -r '.runs.using' < action.yml)"
  if ! echo "$RUNS_USING" | grep '^node[[:digit:]]\+' 1>/dev/null; then
    echo "Unable to determine node version from action.yaml runs.using: $RUNS_USING"
    exit 1
  fi
  echo node-version="${RUNS_USING/node/}.x" >> "$GITHUB_OUTPUT"
elif [ -f .node-version ]; then
  NODE_VERSION="$(cat .node-version)"
  if [[ $NODE_VERSION =~ '^[0-9]+\.[0-9]+\.[0-9]+$' ]]; then
    echo "Unable to determine node version from .node-version: $NODE_VERSION"
    exit 1
  fi
  echo node-version="${NODE_VERSION}" >> "$GITHUB_OUTPUT"
else
  echo "Directory does not contain neither action.yml nor .node-version file"
  exit 1
fi
