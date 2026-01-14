#!/bin/bash
# Ralph Wiggum - Long-running AI agent loop using opencode + bd
# Usage: ./ralph.sh [-m model] [-n max_iterations]
#
# Examples:
#   ./ralph.sh                           # Default: 10 iterations, default model
#   ./ralph.sh -n 5                       # 5 iterations
#   ./ralph.sh -m anthropic/claude-sonnet # Use specific model
#   ./ralph.sh -m openai/gpt-4o -n 20     # Specific model, 20 iterations

set -e

# Parse arguments
MAX_ITERATIONS=100
MODEL="opencode/gpt-5.2"

while getopts "m:n:h" opt; do
	case $opt in
	m) MODEL="$OPTARG" ;;
	n) MAX_ITERATIONS="$OPTARG" ;;
	h)
		echo "Usage: ./ralph.sh [-m model] [-n max_iterations]"
		echo ""
		echo "Options:"
		echo "  -m MODEL    Model to use (default: opencode/gpt-5.2)"
		echo "  -n NUM      Max iterations (default: 10)"
		echo "  -h          Show this help"
		echo ""
		echo "Examples:"
		echo "  ./ralph.sh -m anthropic/claude-sonnet -n 5"
		exit 0
		;;
	\?)
		echo "Invalid option: -$OPTARG" >&2
		exit 1
		;;
	esac
done
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROGRESS_FILE="$SCRIPT_DIR/progress.txt"
ARCHIVE_DIR="$SCRIPT_DIR/archive"
LAST_BRANCH_FILE="$SCRIPT_DIR/.last-branch"

# Get current git branch
get_current_branch() {
	git -C "$SCRIPT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo ""
}

# Archive previous run if branch changed
CURRENT_BRANCH=$(get_current_branch)
if [ -f "$LAST_BRANCH_FILE" ] && [ -n "$CURRENT_BRANCH" ]; then
	LAST_BRANCH=$(cat "$LAST_BRANCH_FILE" 2>/dev/null || echo "")

	if [ -n "$LAST_BRANCH" ] && [ "$CURRENT_BRANCH" != "$LAST_BRANCH" ]; then
		# Archive the previous run
		DATE=$(date +%Y-%m-%d)
		# Strip "ralph/" prefix from branch name for folder
		FOLDER_NAME=$(echo "$LAST_BRANCH" | sed 's|^ralph/||' | sed 's|/|_|g')
		ARCHIVE_FOLDER="$ARCHIVE_DIR/$DATE-$FOLDER_NAME"

		echo "Archiving previous run: $LAST_BRANCH"
		mkdir -p "$ARCHIVE_FOLDER"
		[ -f "$PROGRESS_FILE" ] && cp "$PROGRESS_FILE" "$ARCHIVE_FOLDER/"
		echo "   Archived to: $ARCHIVE_FOLDER"

		# Reset progress file for new run
		echo "# Ralph Progress Log" >"$PROGRESS_FILE"
		echo "Branch: $CURRENT_BRANCH" >>"$PROGRESS_FILE"
		echo "Started: $(date)" >>"$PROGRESS_FILE"
		echo "---" >>"$PROGRESS_FILE"
	fi
fi

# Track current branch
if [ -n "$CURRENT_BRANCH" ]; then
	echo "$CURRENT_BRANCH" >"$LAST_BRANCH_FILE"
fi

# Initialize progress file if it doesn't exist
if [ ! -f "$PROGRESS_FILE" ]; then
	echo "# Ralph Progress Log" >"$PROGRESS_FILE"
	echo "Branch: $CURRENT_BRANCH" >>"$PROGRESS_FILE"
	echo "Started: $(date)" >>"$PROGRESS_FILE"
	echo "---" >>"$PROGRESS_FILE"
fi

# Check if bd is available and has work
if ! command -v bd &>/dev/null; then
	echo "Error: bd CLI not found. Install it or run 'bd onboard' first."
	exit 1
fi

# Show initial work status
echo "Checking for available work..."
bd ready --limit 5 2>/dev/null || echo "No bd database found - run 'bd init' first"

echo ""
echo "Starting Ralph - Max iterations: $MAX_ITERATIONS"
echo "Using model: $MODEL"

# Read prompt file content
PROMPT_FILE="$SCRIPT_DIR/prompt.md"
if [ ! -f "$PROMPT_FILE" ]; then
	echo "Error: prompt.md not found at $PROMPT_FILE"
	exit 1
fi
PROMPT_CONTENT=$(cat "$PROMPT_FILE")

for i in $(seq 1 $MAX_ITERATIONS); do
	echo ""
	echo "═══════════════════════════════════════════════════════"
	echo "  Ralph Iteration $i of $MAX_ITERATIONS"
	echo "═══════════════════════════════════════════════════════"

	# Run opencode with the ralph prompt as message
	OUTPUT=$(opencode run -m "$MODEL" "$PROMPT_CONTENT" 2>&1 | tee /dev/stderr) || true

	# Sync bd state after each iteration
	bd sync 2>/dev/null || true

	# Check for completion signal
	if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
		echo ""
		echo "Ralph completed all tasks!"
		echo "Completed at iteration $i of $MAX_ITERATIONS"

		# Final sync
		bd sync 2>/dev/null || true
		exit 0
	fi

	echo "Iteration $i complete. Continuing..."
	sleep 2
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing all tasks."
echo "Check $PROGRESS_FILE for status."
echo ""
echo "Remaining work:"
bd ready --limit 10 2>/dev/null || true
exit 1
