# Release

Uses the `gh` cli tool to create release with an increasing semantiv versioning number, `v0.0.1`, `v0.1.0`, `v1.0.0` and so on. Also autogenerates release notes.

## Example

```yml
name: Release
on:
  workflow_call:
    inputs:
      type:
        required: true
        type: string
    outputs:
      tag:
        description: "Whether to trigger release workflows"
        value: ${{ jobs.github.outputs.tag }}

permissions:
  contents: write

jobs:
  github:
    name: GitHub
    runs-on: ubuntu-24.04
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Create GitHub release
        id: release
        uses: smartlyio/github-actions@release-v1
        with:
          type: ${{ inputs.type }} # patch, minor, or major
    outputs:
      tag: ${{ steps.release.outputs.tag }}
```
