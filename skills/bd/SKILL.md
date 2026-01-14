---
name: bd
description: Issue tracking with bd (beads) CLI - find work, claim issues, update status, and close tasks
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: issue-tracking
---

## What I do

Help you manage issues using the bd (beads) CLI for lightweight issue tracking with first-class dependency support.

## Core Commands

### Finding Work
```bash
bd ready                    # Show ready work (no blockers, open/in_progress)
bd ready --limit 5          # Limit results
bd ready --assignee me      # Filter by assignee
bd ready --priority 1       # Filter by priority (0=highest)
bd list                     # List all issues
bd list --status open       # List by status
bd search "query"           # Search issues by text
```

### Viewing Issues
```bash
bd show <id>                # View full issue details
bd show                     # Show last touched issue
bd comments <id>            # View comments on an issue
```

### Claiming & Updating
```bash
bd update <id> --status in_progress  # Claim work
bd update <id> --status open         # Release back to pool
bd update <id> --claim               # Atomically claim (fails if already claimed)
bd update <id> --assignee "name"     # Assign to someone
bd update <id> --priority 1          # Set priority (0-4, 0=highest)
bd update <id> --title "new title"   # Update title
bd update <id> --description "..."   # Update description
bd update <id> --add-label "bug"     # Add label
bd update <id> --remove-label "bug"  # Remove label
```

### Completing Work
```bash
bd close <id>               # Close an issue
bd close <id> -r "reason"   # Close with reason
bd close                    # Close last touched issue
bd reopen <id>              # Reopen a closed issue
```

### Creating Issues
```bash
bd create --title "Title" --description "Description"
bd create --title "Bug" --type bug --priority 1
bd q "Quick task"           # Quick capture, outputs only ID
```

### Syncing
```bash
bd sync                     # Sync with git remote
bd status                   # Show database overview
bd info                     # Show database and daemon info
```

## Workflow Example

```bash
# 1. Find available work
bd ready

# 2. Claim an issue
bd update core-abc --status in_progress

# 3. View details
bd show core-abc

# 4. Do the work...

# 5. Close when done
bd close core-abc

# 6. Sync state
bd sync
```

## Dependencies

```bash
bd dep add <id> --blocks <other-id>    # Add dependency
bd dep remove <id> --blocks <other-id> # Remove dependency
bd graph <id>                          # Show dependency graph
bd blocked                             # Show blocked issues
```

## Tips

- Use `bd ready` not `bd list` to find actionable work
- Always `bd sync` before pushing to keep issue state in git
- Use `--claim` flag for atomic claim to avoid race conditions
- Priority 0 is highest, 4 is lowest
