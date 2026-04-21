#!/usr/bin/env bash

set -euo pipefail


package_version="$(jq -r .version < package.json)"
release_branch="v${package_version//.*/}"
git checkout -b "${release_branch}"
if [[ "${DRY_RUN,,}" == "false" ]]; then
    git push -u origin "${release_branch}"
else
    echo "[dry run] Push changes to ${release_branch}" 1>&2
fi
