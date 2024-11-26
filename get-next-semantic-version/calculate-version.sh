#!/usr/bin/env bash

set -euo pipefail

calculate_version() {
    local bump="$1"
    local previous_version="$2"
    local prefix=
    local version=
    # shellcheck disable=SC2001
    prefix="$(echo "$previous_version" | sed -e 's/^\([a-zA-Z]*\).*/\1/')"
    # shellcheck disable=SC2001
    version="$(echo "$previous_version" | sed -e 's/^[a-ZA-Z]\(.*\)/\1/')"

    local without_patch="${version%.*}"
    local major="${version//.*/}"
    local minor="${without_patch//*./}"
    local patch="${version//*./}"

    if [[ "$bump" == "major" ]]; then
        major=$(( major + 1 ))
    elif [[ "$bump" == "minor" ]]; then
        minor=$(( minor + 1 ))
    elif [[ "$bump" == "patch" ]]; then
        patch=$(( patch + 1 ))
    elif [[ "$bump" == "" ]]; then
        echo "No version to bump" 1>&2
        exit 0
    else
        echo "Unknown version bump $bump" 1>&2
        exit 1
    fi

    echo "$prefix$major.$minor.$patch"
}


calculate_version "$1" "$2"
