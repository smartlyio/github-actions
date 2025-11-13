#!/usr/bin/env python3
import sys
import yaml
from pathlib import Path


def main():
    if len(sys.argv) != 2:
        print("Usage: action.py <workflow-file>", file=sys.stderr)
        raise ValueError("Invalid command line arguments")

    workflow_file = Path(sys.argv[1])

    if not workflow_file.exists():
        print(f"Error: Workflow file {workflow_file} does not exist", file=sys.stderr)
        raise FileNotFoundError(f"Workflow file {workflow_file} does not exist")

    try:
        with open(workflow_file, "r") as f:
            workflow = yaml.safe_load(f)
    except yaml.YAMLError as e:
        print(f"Error parsing YAML: {e}", file=sys.stderr)
        raise ValueError(f"Error parsing YAML: {e}")

    if "jobs" not in workflow:
        print("Error: No jobs found in workflow", file=sys.stderr)
        raise ValueError("No jobs found in workflow")

    jobs = workflow["jobs"]

    # Check if finish-ci job exists
    if "finish-ci" not in jobs:
        print("Error: No 'finish-ci' job found in workflow", file=sys.stderr)
        raise ValueError("No 'finish-ci' job found in workflow")

    finish_job = jobs["finish-ci"]

    # Get the needs list from the finish job
    finish_needs = finish_job.get("needs", [])
    if isinstance(finish_needs, str):
        finish_needs = [finish_needs]

    # Get all other job names (excluding the finish-ci job itself)
    all_jobs = set(jobs.keys()) - {"finish-ci"}

    # Convert needs list to set for comparison
    needs_set = set(finish_needs)

    # Find missing jobs
    missing_jobs = all_jobs - needs_set

    # Report results
    if missing_jobs:
        print("Error: Job 'finish-ci' is missing the following jobs in its 'needs' list:")
        for job in sorted(missing_jobs):
            print(f"  - {job}")
        print()
        print("Expected 'needs' list for 'finish-ci':")
        expected_needs = sorted(all_jobs)
        print("needs:")
        for job in expected_needs:
            print(f"  - {job}")
        raise ValueError("Invalid GHA config file")

    print("✓ Branch protection validation passed: 'finish-ci' job correctly lists all other jobs in its 'needs'")


if __name__ == "__main__":
    main()
