---
name: code-review
description: Code review checklist - quality, security, performance, and maintainability checks
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: review
---

## What I do

Guide you through a comprehensive code review checklist for quality, security, and maintainability.

## Quick Checklist

### Correctness
- [ ] Does the code do what it's supposed to do?
- [ ] Are edge cases handled?
- [ ] Are error conditions handled properly?
- [ ] Is the logic correct?

### Code Quality
- [ ] Is the code readable and self-documenting?
- [ ] Are variable/function names descriptive?
- [ ] Is there unnecessary duplication?
- [ ] Is complexity appropriate?

### Testing
- [ ] Are there tests for new functionality?
- [ ] Do tests cover edge cases?
- [ ] Are tests readable and maintainable?
- [ ] Do all tests pass?

### Security
- [ ] Is user input validated/sanitized?
- [ ] Are there SQL injection risks?
- [ ] Are there XSS vulnerabilities?
- [ ] Are secrets hardcoded? (they shouldn't be)
- [ ] Are permissions checked properly?

### Performance
- [ ] Are there obvious performance issues?
- [ ] N+1 query problems?
- [ ] Unnecessary re-renders (React)?
- [ ] Memory leaks?
- [ ] Expensive operations in loops?

## Detailed Review Areas

### Functions
- Single responsibility?
- Reasonable length (< 50 lines preferred)?
- Clear inputs and outputs?
- Side effects documented?

### Error Handling
- Errors caught appropriately?
- Meaningful error messages?
- Errors logged where needed?
- User-facing errors are friendly?

### Types (TypeScript)
- Proper types used (avoid `any`)?
- Null/undefined handled?
- Type assertions justified?
- Generics used appropriately?

### React Specific
- Components reasonably sized?
- Props interface defined?
- Keys provided for lists?
- useEffect dependencies correct?
- Memoization used appropriately?
- No state that could be derived?

### API/Backend
- Proper HTTP methods used?
- Status codes appropriate?
- Request validation in place?
- Response format consistent?
- Rate limiting considered?

### Database
- Migrations reversible?
- Indexes for queried columns?
- Transactions where needed?
- No N+1 queries?

## Review Comments

### Good comment patterns
```
"Consider using X here because Y"
"This could cause Z issue when..."
"Nit: prefer X over Y for consistency"
"Question: what happens when...?"
```

### Categorize feedback
- **Blocker**: Must fix before merge
- **Major**: Should fix, but can discuss
- **Minor**: Nice to have, optional
- **Nit**: Style/preference, take it or leave it

## Before Approving

1. All blockers resolved
2. Tests pass in CI
3. No merge conflicts
4. Documentation updated if needed
5. Breaking changes communicated

## Self-Review First

Before requesting review:
1. Re-read your own diff
2. Run tests locally
3. Check for debug code/console.logs
4. Verify no sensitive data committed
5. Ensure commits are clean
