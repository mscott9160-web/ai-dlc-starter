const core = require("@actions/core");
const github = require("@actions/github");

const requiredLabel = process.env.REQUIRED_LABEL;
const requiredMarker = process.env.REQUIRED_MARKER;
const maintainer = process.env.MAINTAINER;
const octokit = github.getOctokit(process.env.GITHUB_TOKEN);
const { owner, repo } = github.context.repo;

async function resolveItem() {
  const payload = github.context.payload;
  if (payload.issue || payload.pull_request) return payload.issue || payload.pull_request;
  if (payload.workflow_run) {
    const { data } = await octokit.rest.actions.listWorkflowRunPullRequests({
      owner, repo, run_id: payload.workflow_run.id,
    });
    return data.pull_requests[0];
  }
  return undefined;
}

async function commentOnce(item, reason) {
  const marker = `<!-- ai-dlc-gate:${requiredLabel} -->`;
  const { data: comments } = await octokit.rest.issues.listComments({
    owner, repo, issue_number: item.number, per_page: 100,
  });
  if (comments.some((comment) => comment.body.includes(marker))) return;
  await octokit.rest.issues.createComment({
    owner,
    repo,
    issue_number: item.number,
    body: `${marker}\nAI-DLC gate blocked: ${reason}`,
  });
}

async function main() {
  const item = await resolveItem();
  if (!item) {
    core.setOutput("allowed", "false");
    return;
  }
  const { data: events } = await octokit.rest.issues.listEventsForTimeline({
    owner, repo, issue_number: item.number, per_page: 100,
    mediaType: { previews: ["mockingbird"] },
  });
  const labelEvent = events.filter((event) => event.event === "labeled" && event.label?.name === requiredLabel).pop();
  if (!labelEvent) {
    await commentOnce(item, `apply the \`${requiredLabel}\` approval label.`);
    core.setOutput("allowed", "false");
    return;
  }
  if (labelEvent.actor?.login !== maintainer) {
    await commentOnce(item, `\`${requiredLabel}\` must be applied by @${maintainer}.`);
    core.setOutput("allowed", "false");
    return;
  }
  let commentIds = "[]";
  if (requiredMarker) {
    const { data: comments } = await octokit.rest.issues.listComments({
      owner, repo, issue_number: item.number, per_page: 100,
    });
    const artifact = comments.find((comment) => comment.body.includes(requiredMarker));
    if (!artifact) {
      await commentOnce(item, `the required approved artifact (${requiredMarker}) is missing.`);
      core.setOutput("allowed", "false");
      return;
    }
    if (new Date(artifact.updated_at) > new Date(labelEvent.created_at)) {
      await commentOnce(item, `the approved artifact changed after \`${requiredLabel}\`; re-apply the label after review.`);
      core.setOutput("allowed", "false");
      return;
    }
    commentIds = JSON.stringify([artifact.id]);
  }
  core.setOutput("allowed", "true");
  core.setOutput("comment_ids", commentIds);
}

main().catch((error) => core.setFailed(error.message));