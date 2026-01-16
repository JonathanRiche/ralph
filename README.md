# Ralph Beads

An autonomous AI agent loop that runs [opencode](https://opencode.ai) repeatedly until all issues are complete. Each iteration is a fresh opencode instance with clean context. Memory persists via git history, `progress.txt`, and [bd](https://github.com/steveyegge/beads) (beads) issue state.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/).

## Attribution

This project is adapted from [snarktank/ralph](https://github.com/snarktank/ralph). We've modified it to use:
- **bd** for issue tracking instead of `prd.json`
- **opencode** instead of `amp`
- **Playwright MCP** or **dev-browser** for browser testing (configurable)

## Prerequisites

- [opencode](https://opencode.ai) installed and authenticated
- [bd](https://github.com/steveyegge/beads) installed
- A git repository for your project

## Setup

### Option 1: Copy to your project

Copy the ralph files into your project:

```bash
# From your project root
cp /path/to/ralph-beads/ralph.sh ./
cp /path/to/ralph-beads/prompt.md ./
chmod +x ralph.sh
```

### Option 2: Install skills globally

Copy the skills to your opencode config for use across all projects:

```bash
cp -r skills/* ~/.config/opencode/skill/
```

### Initialize bd in your project

```bash
bd init
bd onboard  # Adds instructions to AGENTS.md
```

## Workflow

### 1. Create issues with bd

Create issues for your feature work:

```bash
# Single issue
bd create --title "Add user authentication" --description "Implement login/logout flow"

# Quick capture
bd q "Fix null pointer in dashboard"

# With priority (0=highest)
bd create --title "Critical bug" --type bug --priority 0
```

### 2. Run Ralph

```bash
./ralph.sh [options]
```

Options:
- `-n NUM` - Max iterations (default: 100)
- `-m MODEL` - Model to use (default: opencode/gpt-5.2-codex)
- `-b MODE` - Browser testing mode (default: playwright)
  - `playwright` - Use Playwright MCP via subagent
  - `dev-browser` - Use dev-browser skill directly
  - `none` - Disable browser testing
- `-h` - Show help

Examples:
```bash
./ralph.sh                              # Default settings
./ralph.sh -n 5                          # Max 5 iterations
./ralph.sh -m anthropic/claude-sonnet-4  # Use Claude
./ralph.sh -m opencode/gpt-5.2-codex -n 20  # GPT-5.2-codex, 20 iterations
./ralph.sh -b dev-browser               # Use dev-browser for UI testing
./ralph.sh -b none                      # Skip browser testing
```

Ralph will:
1. Run `bd ready` to find available work
2. Pick the first ready issue
3. Create a feature branch
4. Claim with `bd update <id> --status in_progress`
5. Implement that single issue
6. Run quality checks (typecheck, tests, lint)
7. Commit if checks pass
8. Close with `bd close <id>`
9. Append learnings to `progress.txt`
10. Repeat until all issues done or max iterations reached

## Key Files

| File | Purpose |
|------|---------|
| `ralph.sh` | The bash loop that spawns fresh opencode instances |
| `prompt.md` | Instructions given to each opencode instance |
| `custom_prompt.md` | Example with protected branches (use as template) |
| `progress.txt` | Append-only learnings for future iterations |
| `skills/` | Reusable opencode skills |

## Skills Included

| Skill | Description |
|-------|-------------|
| `bd` | Issue tracking CLI reference and commands |
| `playwright-testing` | Browser testing with Playwright MCP |
| `dev-browser` | Browser automation with persistent page state ([source](https://github.com/SawyerHood/dev-browser))* |
| `ralph-workflow` | The autonomous agent workflow guide |
| `git-workflow` | Git branching and commit best practices |
| `code-review` | Code review checklist |

*\* The `dev-browser` skill requires cloning the full source from [SawyerHood/dev-browser](https://github.com/SawyerHood/dev-browser). See the skill's SKILL.md for installation instructions.*

## Critical Concepts

### Each Iteration = Fresh Context

Each iteration spawns a **new opencode instance** with clean context. The only memory between iterations is:
- Git history (commits from previous iterations)
- `progress.txt` (learnings and context)
- bd issue state (which issues are done)

### Small Tasks

Each issue should be small enough to complete in one context window. If a task is too big, the LLM runs out of context before finishing.

Right-sized issues:
- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic
- Add a filter dropdown to a list

Too big (split these):
- "Build the entire dashboard"
- "Add authentication"
- "Refactor the API"

### AGENTS.md Updates Are Critical

After each iteration, Ralph updates relevant `AGENTS.md` files with learnings. opencode automatically reads these files, so future iterations benefit from discovered patterns, gotchas, and conventions.

### Feedback Loops

Ralph only works if there are feedback loops:
- Typecheck catches type errors
- Tests verify behavior
- Linter enforces style
- CI must stay green

### Browser Verification for UI

Frontend issues need browser verification. Two modes available via `-b` flag:

**Playwright MCP (default)** - Delegates to a subagent:
```
Task tool with subagent_type: "general"
"Use Playwright MCP to verify [UI change] at [URL]..."
```

**dev-browser** - Direct browser automation with persistent state:
```bash
./ralph.sh -b dev-browser
```
Uses the [dev-browser](https://github.com/SawyerHood/dev-browser) skill for writing small tsx scripts that maintain page state across executions.

### Stop Condition

When `bd ready` returns no issues, Ralph outputs `<promise>COMPLETE</promise>` and the loop exits.

## Debugging

Check current state:

```bash
# See ready work
bd ready

# See all issues
bd list

# See specific issue
bd show <id>

# See learnings from previous iterations
cat progress.txt

# Check git history
git log --oneline -10
```

## Customizing prompt.md

Edit `prompt.md` to customize Ralph's behavior:
- Add project-specific quality check commands
- Include codebase conventions
- Add common gotchas for your stack
- Protect specific branches (see `custom_prompt.md`)

### Protected Branches Example

If you need to protect `main` and use a feature branch as base:

```bash
cp custom_prompt.md prompt.md
# Edit prompt.md to set your base branch
```

## Archiving

Ralph automatically archives previous runs when you switch branches. Archives are saved to `archive/YYYY-MM-DD-branch-name/`.

## bd Quick Reference

```bash
bd ready                    # Find available work
bd show <id>                # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>               # Complete work
bd sync                     # Sync with git
bd list                     # List all issues
bd create --title "..."     # Create issue
```

## References

- [Geoffrey Huntley's Ralph article](https://ghuntley.com/ralph/)
- [snarktank/ralph](https://github.com/snarktank/ralph) - Original implementation
- [opencode documentation](https://opencode.ai/docs/)
- [bd (beads)](https://github.com/steveyegge/beads) - Issue tracking
- [dev-browser](https://github.com/SawyerHood/dev-browser) - Browser automation skill

## License

MIT
