#!/usr/bin/env bash

set -euo pipefail

RUNS_USING="$(yq -r '.runs.using' < action.yml)"
if ! echo "$RUNS_USING" | grep '^node[[:digit:]]\+' 1>/dev/null; then
    echo "Unable to determine node version from action.yaml runs.using: $RUNS_USING"
    exit 1
fi
echo node-version="${RUNS_USING/node/}.x" >> "$GITHUB_OUTPUT"
