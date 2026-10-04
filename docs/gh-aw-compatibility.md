# gh-aw Compatibility

## Marked comment updates

The gh-aw documentation describes `safe-outputs.add-comment.allows-comment-ids` as accepting a dynamic expression. Both gh-aw v0.89.21 and v0.90.3 reject expressions for this field with `expected array or null, got string`.

AI-DLC therefore uses a custom safe-output job for Plan and Design artifacts. The agent supplies one typed body; the isolated writer searches only the triggering issue for a fixed hidden marker and creates or updates that one comment. The agent retains read-only permissions.

Do not replace these custom jobs with `allows-comment-ids` until the compiler accepts the documented expression form. Re-run `gh aw compile --validate --approve` after updating gh-aw.