---
name: playwright-testing
description: Browser testing with Playwright MCP - navigate, interact, snapshot, and screenshot web pages
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: testing
---

## What I do

Help you test web UIs using Playwright MCP tools for browser automation.

## IMPORTANT: Use a Subagent

**Do NOT call Playwright tools directly from the main agent.** Delegate browser testing to a subagent to keep context clean:

```
Task tool with subagent_type: "general"

Prompt: "Use Playwright MCP to test [description]:
1. Navigate to [URL]
2. Verify [elements/behavior]
3. Take screenshot if needed
4. Report: what worked, what failed"
```

## Playwright MCP Tools

### Navigation
```
playwright_browser_navigate
  - url: The URL to navigate to
  - browserType: "chromium" | "firefox" | "webkit" (default: chromium)
  - headless: true/false (default: true)
  - width/height: viewport size
```

### Page State
```
playwright_browser_snapshot
  - Returns accessibility tree of current page
  - Use to understand page structure and find elements

playwright_browser_take_screenshot
  - Captures current page as image
  - Useful for visual verification and progress logs
```

### Interactions
```
playwright_browser_click
  - selector: CSS selector or text content
  - ref: Element reference from snapshot

playwright_browser_type
  - selector: Target input element
  - text: Text to type
  - ref: Element reference from snapshot

playwright_browser_fill
  - selector: Target input element  
  - value: Value to fill

playwright_browser_select
  - selector: Select element
  - values: Options to select

playwright_browser_hover
  - selector: Element to hover over
```

### Forms & Input
```
playwright_browser_press
  - key: Key to press (Enter, Tab, Escape, etc.)

playwright_browser_scroll
  - direction: "up" | "down" | "left" | "right"
  - amount: pixels to scroll
```

### Waiting
```
playwright_browser_wait
  - selector: Wait for element
  - state: "visible" | "hidden" | "attached" | "detached"
  - timeout: milliseconds
```

## Testing Workflow

1. **Navigate** to the page under test
2. **Snapshot** to understand page structure
3. **Interact** with elements (click, type, etc.)
4. **Snapshot again** to verify changes
5. **Screenshot** for documentation if needed
6. **Report** findings back to main agent

## Example Subagent Prompt

```
"Use Playwright MCP to verify the login form:
1. Navigate to http://localhost:3000/login
2. Snapshot the page and find the email/password fields
3. Fill in test@example.com and password123
4. Click the submit button
5. Wait for navigation or error message
6. Snapshot and report what happened
7. Take a screenshot of the final state"
```

## Tips

- Always snapshot first to understand page structure
- Use element refs from snapshots for reliable targeting
- Set appropriate timeouts for slow-loading pages
- Run in headless mode for CI, headed for debugging
- Close browser when done to free resources
