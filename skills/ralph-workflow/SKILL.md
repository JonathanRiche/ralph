---
name: ralph-workflow
description: Autonomous coding agent workflow - pick issues, implement, test, commit, and track progress
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: autonomous
---

## What I do

Guide you through the Ralph autonomous agent workflow for picking up issues, implementing them, and tracking progress.

## The Ralph Loop

Each iteration of Ralph follows this workflow:

1. **Find work**: `bd ready` to get available issues
2. **Read context**: Check `progress.txt` for patterns and learnings
3. **Branch**: Create feature branch from base branch
4. **Claim**: `bd update <id> --status in_progress`
5. **Understand**: `bd show <id>` for full details
6. **Implement**: Write the code
7. **Quality**: Run tests, lint, typecheck
8. **Commit**: `feat: [Issue ID] - [Issue Title]`
9. **Close**: `bd close <id>`
10. **Document**: Append to `progress.txt`

## Progress File Format

Always APPEND to `progress.txt`, never replace:

```markdown
## [Date/Time] - [Issue ID]
- What was implemented
- Files changed
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
  - Useful context
---
```

## Codebase Patterns Section

At the TOP of `progress.txt`, maintain a patterns section:

```markdown
## Codebase Patterns
- Pattern 1: Use X for Y
- Pattern 2: Always do Z when changing W
```

Only add **general, reusable** patterns here.

## Branch Strategy

Default (using main):
```bash
git checkout main
git pull origin main
git checkout -b feat/<issue-id>-<description>
```

Custom base branch (e.g., feat/dashboard-component):
```bash
git checkout feat/dashboard-component
git pull origin feat/dashboard-component
git checkout -b feat/<issue-id>-<description>
```

**NEVER touch production branches unless explicitly allowed.**

## Commit Message Format

```
feat: [Issue ID] - [Issue Title]

- Bullet point of what changed
- Another change
```

Examples:
- `feat: core-abc - Add user authentication`
- `fix: core-xyz - Fix null pointer in dashboard`
- `chore: core-123 - Update dependencies`

## Quality Gates

Before committing, ensure:
- [ ] Tests pass
- [ ] Linter passes
- [ ] Type check passes
- [ ] Build succeeds

```bash
bun test        # or your test command
bun run lint    # or your lint command
bun run build   # or your build command
```

## Frontend Issues

For UI changes, delegate browser testing to a subagent:

```
Task tool with subagent_type: "general"

"Use Playwright MCP to verify [UI change]:
1. Navigate to [URL]
2. Test [specific behavior]
3. Report results"
```

## Stop Condition

After completing an issue:
1. Run `bd ready` again
2. If no issues remain, output: `<promise>COMPLETE</promise>`
3. If issues remain, end normally (next iteration continues)

## AGENTS.md Updates

Before committing, check if you learned something worth preserving:
- API patterns specific to a module
- Non-obvious requirements
- File dependencies
- Testing approaches

Add to nearby `AGENTS.md` files if genuinely reusable.

## Tips

- Work on ONE issue per iteration
- Commit frequently
- Keep changes focused and minimal
- Follow existing code patterns
- Always `bd sync` before pushing
