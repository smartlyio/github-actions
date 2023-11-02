#!/usr/bin/env bash

set -euo pipefailt

if [[ "${USE_YARN,,}" == "true" ]]; then
  yarn install
  yarn version --new-version "$VERSION"
else
  npm install
  npm version "$VERSION"
fi
[[ "${DRY_RUN,,}" == "false" ]] && git push && git push --tags
