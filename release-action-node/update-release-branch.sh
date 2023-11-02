#!/usr/bin/env bash

set -euo pipefail


package_version="$(jq -r .version < package.json)"
release_branch="v${package_version//.*/}"
git checkout -b "${release_branch}"
[[ "${DRY_RUN,,}" == "false" ]] && git push -u origin "${release_branch}"
