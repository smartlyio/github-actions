#!/usr/bin/env bash

set -euo pipefail

if [[ "${USE_YARN,,}" == "true" ]]; then
  yarn install
  yarn version --new-version "$VERSION"
else
  npm install
  npm version "$VERSION"
fi
if [[ "${DRY_RUN,,}" == "false" ]]; then
    git push && git push --tags
else
    echo "[dry run] Push new version" 1>&2
fi
