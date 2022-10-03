# Smartly GitHub actions

* [`action-monorepo-promote`](./action-monorepo-promote/action.yml): Given a monorepo composed of multiple action folders, deletes all other actions and moves all the
  contents of the main action to the root of the repo.
* [`auto-tagger`](./auto-tagger/action.yml): Creates a new version (tag+branch) for a repository based on the labels "major, minor, patch" associated with the current pull-request.
* [`check-branch-behind`](./check-branch-behind/action.yml): Checks if the current revision is at head of the default branch.
* [`get-base-branch`](./get-base-branch/action.yml): Gets the base branch of a git repository.
* [`get-next-semantic-version`](./get-next-semantic-version/action.yml): Calculates the next semantic version.
* [`release-action-node`](./release-action-node/action.yml): Releases a node.js action.