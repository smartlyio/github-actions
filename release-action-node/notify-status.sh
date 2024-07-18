#!/usr/bin/env bash

set -euo pipefail

if [[ "${CONTINUE_RELEASE,,}" == "false" ]]; then
  echo status=cancelled >> "$GITHUB_OUTPUT"
elif [[ "${BRANCH_UP_TO_DATE,,}" == "false" ]]; then
  echo status=skipped >> "$GITHUB_OUTPUT"
fi
