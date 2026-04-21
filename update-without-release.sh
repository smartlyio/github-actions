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
    if [[ "${DRY_RUN,,}" == "false" ]]; then
        git push
    else
        echo "[dry run] Push changes" 1>&2
    fi
fi
