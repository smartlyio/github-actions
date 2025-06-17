#!/usr/bin/env python3

import os
import subprocess
import json
import sys


def fetch_diff_base(event_name, event_data):
    """Ensure the git repository has enough history to perform the diff."""

    valid_events = {"pull_request", "merge_group", "push"}

    if event_name not in valid_events:
        print(
            f"find-changes only works on {', '.join(valid_events)} events.",
            file=sys.stderr,
        )
        sys.exit(1)

    try:
        # Determine what commit we need to fetch
        target_commit = None

        if event_name == "push" and event_data.get("before"):
            target_commit = event_data["before"]
        elif event_name in ("pull_request", "merge_group"):
            return "HEAD~1"  # depends on actions/checkout with fetch-depth: 2 (handled in action.yml)

        if target_commit:
            # Fetch the specific commit we need
            subprocess.run(
                ["git", "fetch", "--depth=1", "--no-tags", "origin", target_commit],
                check=True,
                capture_output=True,
                text=True,
            )
            print(f"Fetched diff base: {target_commit}")
            return target_commit

    except subprocess.CalledProcessError as e:
        if (
            event_name == "push"
            and event_data.get("before") == "0000000000000000000000000000000000000000"
        ):
            print("Detected initial commit - returning empty change set")
            return None

        print(f"Warning: Error while fetching git history: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def run_git_diff(comparison_point):
    """Run git diff to get changed files."""
    if comparison_point is None:
        return []

    try:
        result = subprocess.run(
            ["git", "diff", "--name-only", comparison_point],
            capture_output=True,
            text=True,
            check=True,
        )
        # Filter out empty lines and return array of changed files
        return [file for file in result.stdout.splitlines() if file]
    except subprocess.CalledProcessError:
        print(f"Error running git diff against {comparison_point}", file=sys.stderr)
        sys.exit(1)


def get_event_data():
    """Load GitHub event data from the event path file."""
    event_path = os.environ.get("GITHUB_EVENT_PATH")
    print(f"Reading event from {event_path}")

    if not event_path:
        print(
            "Could not find event payload file.",
            file=sys.stderr,
        )
        sys.exit(1)

    try:
        with open(event_path) as f:
            event_data = json.load(f)
            if not event_data:
                print("Event payload does not provide data.", file=sys.stderr)
                sys.exit(1)
            return event_data
    except (IOError, json.JSONDecodeError) as e:
        print(f"Error reading event data: {e}", file=sys.stderr)
        sys.exit(1)


def get_event_name():
    """Get the GitHub event type from environment variables."""
    return os.environ.get("GITHUB_EVENT_NAME")


def main():
    """Main function to output changed files in GitHub Actions format."""
    event_name = get_event_name()
    event_data = get_event_data()

    # Fetch the diff base using the event data
    diff_base = fetch_diff_base(event_name, event_data)

    # Get an array of changed files using git diff
    array = run_git_diff(diff_base)

    # Write to GITHUB_OUTPUT file using the new approach
    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        files_output = json.dumps(array)
        appending_mode = "a"
        with open(github_output, appending_mode) as f:
            f.write(f"array={files_output}\n")

    # Log changed files
    plural = "s" if len(array) != 1 else ""
    if array:
        print(f"Found {len(array)} change{plural}:")
        for file in array:
            print(file)
    else:
        print("No changes found")


if __name__ == "__main__":
    main()
