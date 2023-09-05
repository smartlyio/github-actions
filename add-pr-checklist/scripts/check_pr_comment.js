// https://github.com/actions/github-script

module.exports = async ({github, context}) => {
    // https://octokit.github.io/rest.js/v20#issues-list-comments
    // https://docs.github.com/en/rest/issues/comments?apiVersion=2022-11-28#list-issue-comments

    // No need to paginate, if there is a comment it will be near the top
    const {data: comments} = await github.rest.issues.listComments({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number,
    });

    const prComment = comments.find((c) => c.body.includes('<!-- add-pr-comment:pr_checklist -->'))

    if (prComment == null) {
        console.log('PR checklist comment not found')
        return null
    }

    console.log('PR checklist comment found', {prComment})

    return prComment.id
}