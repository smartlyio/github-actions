# Smartly GitHub actions

* [`action-monorepo-promote`](./action-monorepo-promote/action.yml): Given a monorepo composed of multiple action folders, deletes all other actions and moves all the
  contents of the main action to the root of the repo.
* [`auto-tagger`](./auto-tagger/action.yml): Creates a new version (tag+branch) for a repository based on the labels "major, minor, patch" associated with the current pull-request.
* [`calculate-incremental-tag`](./calculate-incremental-tag/action.yml): Action to calculate a lightweight incremental tag.
* [`check-branch-behind`](./check-branch-behind/action.yml): Checks if the current revision is at head of the default branch.
* [`create-github-release`](./create-github-release/action.yml) Create a new GitHub tag and release, with a semantic version bump based on PR labels.
* [`create-simple-github-release`](./create-simple-github-release/action.yml) Create a GitHub tag and release with specified name and body text.
* [`get-base-branch`](./get-base-branch/action.yml): Gets the base branch of a git repository.
* [`get-repo-name`](./get-repo-name/action.yml): Gets the name of the current repository.
* [`get-next-semantic-version`](./get-next-semantic-version/action.yml): Calculates the next semantic version.
* [`git-init-userinfo`](./git-init-userinfo/action.yml): Sets the user name and email for git to use. Defaults to a GitHub actions user.
* [`kube-check-krane-manifests`](./kube-check-krane-manifests/action.yml): Runs a fake krane deploy to validate kubernetes resources definitions.
* [`release-action-node`](./release-action-node/action.yml): Releases a node.js action.
* [`setup-ruby`](./setup-ruby/action.yml): Sets up Ruby. A wrapper around https://github.com/ruby/setup-ruby to also support `macos-13` runners.
* [`publish-confluence`](./publish-confluence/action.yml): Fork of [markdown-confluence action](https://github.com/markdown-confluence/publish-action/) but with stricter docker image tag

## Release flow

1. Whenever you need to crate/change an action, open a PR.
2. Assign a label to the PR matching the type of change (patch, minor, major).
3. When the PR is merged:
   1. A new tag will be created on the default branch, e.g. `my-action-v1.2.3`.
   2. A branch matching the major version will be pushed, containing only the code of the altered action, e.g. `my-action-v1`. 
   3. You can then invoke the action with `uses: smartlyio/github-actions@my-action-v1`.
   4. To use a specific version of the action, you need to use: `uses: smartlyio/github-actions/my-action@my-action-v1.2.3`.
