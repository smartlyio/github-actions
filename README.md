# Find changes

This action outputs list of changed files as JSON. It works in `pull_request`, `merge_group`, and `push` events, supporting all merge types: `merge commit`, `squash`, and `rebase`.

If you use this, you should have either [merge queues](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue) (GitHub Enterprise feature) or `Require branches to be up to date before merging` branch protection rule enabled.

## Usage example

See [here](../.github/workflows/find-changes.yml).
