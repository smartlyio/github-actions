# Smartly GitHub actions

* [`action-monorepo-promote`](./action-monorepo-promote/action.yml): Given a monorepo composed of multiple action folders, deletes all other actions and moves all the
  contents of the main action to the root of the repo.
* [`auto-tagger`](./auto-tagger/action.yml): Creates a new version (tag+branch) for a repository based on the labels "major, minor, patch" associated with the current pull-request.
* [`check-branch-behind`](./check-branch-behind/action.yml): Checks if the current revision is at head of the default branch.
* [`get-base-branch`](./get-base-branch/action.yml): Gets the base branch of a git repository.
* [`get-next-semantic-version`](./get-next-semantic-version/action.yml): Calculates the next semantic version.
* [`release-action-node`](./release-action-node/action.yml): Releases a node.js action.

## Release flow

1. Whenever you need to crate/change an action, open a PR.
2. Assign a label to the PR matching the type of change (patch, minor, major).
3. When the PR is merged:
   1. A new tag will be created on the default branch, e.g. `my-action-v1.2.3`.
   2. A branch matching the major version will be pushed, containing only the code of the altered action, e.g. `my-action-v1`. 
   3. You can then invoke the action with `uses: smartlyio/github-actions@my-action-v1`.
   4. To use a specific version of the action, you need to use: `uses: smartlyio/github-actions/my-action@my-action-v1.2.3`.