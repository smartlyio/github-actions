#!/usr/bin/env bash

set -euo pipefail

if [[ "${USE_YARN,,}" == "true" ]]; then
    yarn install
    yarn run version
else
    npm install
    npm run version
fi
git_changes="$(git status --porcelain -- dist || true)"
if [ -n "$git_changes" ]; then
    git add -- dist
    git commit -m "Update compiled action"
    [[ "${DRY_RUN,,}" == "false" ]] && git push
fi
