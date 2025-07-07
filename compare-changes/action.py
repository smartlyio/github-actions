#!/usr/bin/env python3
import os
import json
import yaml
import fnmatch


def convert_github_patterns_to_fnmatch(github_patterns):
    """
    Convert GitHub Actions path patterns to fnmatch-compatible patterns.

    Handles common GitHub Actions path wildcard patterns:
    - dir/** -> dir/*
    - dir/**/* -> dir/*

    Returns a list of converted patterns.
    """
    fnmatch_patterns = []

    for pattern in github_patterns:
        # Handle dir/** pattern (matches anything inside dir)
        if pattern.endswith("**"):
            converted = pattern[:-2] + "*"
            fnmatch_patterns.append(converted)
        # Handle dir/**/* pattern (matches anything inside dir)
        elif pattern.endswith("**/*"):
            converted = pattern[:-4] + "*"
            fnmatch_patterns.append(converted)
        # Keep other patterns as is
        else:
            fnmatch_patterns.append(pattern)

    return fnmatch_patterns


def extract_path_patterns(config):
    """Extract path patterns from workflow config YAML."""
    # GitHub Actions workflows use 'on:' as a top-level key to define triggers.
    # When manually parsing YAML with PyYAML, 'on:' might be interpreted as either:
    #  - The string key 'on' (intended behavior)
    #  - The boolean key True (valid YAML conversion)
    #
    # This workaround checks for both possible keys to ensure we can extract
    # path patterns regardless of how PyYAML interpreted the 'on:' keyword.
    #
    # Example:
    # # .github/workflows/*.yml:
    # on: # <- This is the 'on:' key
    #   push:
    if "push" in config.get("on", []):
        workflow_config = config["on"]
    elif "push" in config.get(True, {}):
        workflow_config = config[True]
    else:
        return []

    push = workflow_config["push"]

    if isinstance(push, dict) and "paths" in push:
        return push["paths"]

    raise Exception(
        f"Error: wildcard file does not contain paths in expected format: {workflow_config}"
    )


def check_for_matches(path_patterns, changed_files):
    """Check if any changed file matches any path pattern."""
    for changed_file in changed_files:
        for pattern in path_patterns:
            # For patterns without slashes that aren't directory patterns,
            # ensure they only match at the root level
            if "/" not in pattern and "*" in pattern and "/" in changed_file:
                # Skip files in subdirectories for root-level patterns
                continue

            if fnmatch.fnmatch(changed_file, pattern):
                print(f"File '{changed_file}' matches pattern '{pattern}'")
                print(
                    "Returning early as an optimisation, there may be more matches not listed here."
                )
                return True
    return False


def main():
    # Get inputs from environment variables
    changes_json = os.environ.get("INPUT_CHANGES", "[]")
    wildcard_name = os.environ.get("INPUT_WILDCARD")
    wildcard_file = f".github/workflows/wildcard-{wildcard_name}.yml"

    # Validate inputs
    if not wildcard_name:
        raise Exception("Error: No wildcard name specified")

    if not os.path.exists(wildcard_file):
        raise Exception(f"Error: Wildcard file not found: {wildcard_file}")

    try:
        changed_files = json.loads(changes_json)
    except json.JSONDecodeError:
        changed_files = []

    try:
        # Load and parse wildcard config
        reading_mode = "r"
        with open(wildcard_file, reading_mode) as f:
            config = yaml.safe_load(f)

        # Extract path patterns
        path_patterns = extract_path_patterns(config)

        # Print path patterns one per line
        print(
            f"Found {len(path_patterns)} GitHub Actions path patterns in wildcard file."
        )

        # Convert GitHub Actions patterns to fnmatch-compatible patterns
        fnmatch_patterns = convert_github_patterns_to_fnmatch(path_patterns)
        print("Converted patterns to fnmatch-compatible ones:")
        for before, after in zip(path_patterns, fnmatch_patterns):
            if before == after:
                print(f"- (unchanged) '{before}'")
            else:
                print(f"- '{before}' -> '{after}'")

        # Check for matches (using converted patterns)
        matched = check_for_matches(fnmatch_patterns, changed_files)

        # Output the result to GitHub Actions
        appending_mode = "a"
        with open(os.environ["GITHUB_OUTPUT"], appending_mode) as f:
            f.write(f"changed={str(matched).lower()}\n")

        # Print the result
        if not matched:
            print("Compared all changes with all patterns, found no matches.")

        print(f"Result for {wildcard_name}: changed={str(matched).lower()}")

    except Exception as e:
        raise Exception(f"Error processing wildcard file: {str(e)}")


if __name__ == "__main__":
    main()
