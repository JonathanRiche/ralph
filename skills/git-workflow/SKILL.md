---
name: git-workflow
description: Git workflow patterns - branching, committing, rebasing, and PR best practices
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: version-control
---

## What I do

Guide you through git workflow best practices for branching, committing, and collaboration.

## Branch Naming

```
feat/<issue-id>-<short-description>   # New features
fix/<issue-id>-<short-description>    # Bug fixes
chore/<description>                   # Maintenance tasks
refactor/<description>                # Code refactoring
docs/<description>                    # Documentation
```

Examples:
- `feat/core-abc-user-auth`
- `fix/core-xyz-null-pointer`
- `chore/update-dependencies`

## Creating Branches

```bash
# From main
git checkout main
git pull origin main
git checkout -b feat/my-feature

# From another branch
git checkout feat/base-branch
git pull origin feat/base-branch
git checkout -b feat/my-feature
```

## Commit Messages

Follow conventional commits:

```
<type>: <description>

[optional body]
[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code change that neither fixes nor adds
- `test`: Adding tests
- `chore`: Maintenance

Examples:
```
feat: add user authentication flow

- Implement login/logout endpoints
- Add session management
- Create auth middleware

Closes #123
```

## Staying Up to Date

```bash
# Rebase onto latest base branch
git fetch origin
git rebase origin/main

# Or merge (creates merge commit)
git fetch origin
git merge origin/main
```

## Handling Conflicts

```bash
# During rebase
git status                    # See conflicted files
# Edit files to resolve
git add <resolved-files>
git rebase --continue

# Abort if needed
git rebase --abort
```

## Pushing

```bash
# First push (set upstream)
git push -u origin feat/my-feature

# Subsequent pushes
git push

# After rebase (use with caution!)
git push --force-with-lease
```

## Pull Request Checklist

Before creating PR:
- [ ] Tests pass locally
- [ ] Linter passes
- [ ] Commits are clean and logical
- [ ] Branch is up to date with base
- [ ] No merge conflicts

## Useful Commands

```bash
git status                    # Current state
git log --oneline -10         # Recent commits
git diff                      # Unstaged changes
git diff --staged             # Staged changes
git stash                     # Temporarily save changes
git stash pop                 # Restore stashed changes
git branch -a                 # List all branches
git remote -v                 # Show remotes
```

## Safety Rules

- **NEVER force push to main/master**
- **NEVER rebase shared/public branches**
- Use `--force-with-lease` instead of `--force`
- Always pull before starting new work
- Commit early, commit often

## Undoing Things

```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Undo staged file
git restore --staged <file>

# Discard local changes
git restore <file>
```
