# require-semver-label

Validates that PR is good-to-go as far as [release](https://github.com/smartlyio/github-actions/tree/master/release) is concerned.

## Example

```yml
name: Validate
on:
  pull_request:

jobs:
  validate:
    name: Validate
    runs-on: ubuntu-24.04
    steps:
      - name: Checkout
        uses: actions/checkout

      - name: Require semantic version label
        id: semver
        uses: anttiharju/actions/require-semver-label@v0
    outputs:
      release_type: ${{ steps.semver.outputs.bump }}
```
