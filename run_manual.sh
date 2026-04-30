#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# Pre-Market Intelligence System — Manual Test Runner
# ─────────────────────────────────────────────────────────────────────────────
#
# HOW THIS WORKS:
#   This script passes the full contents of CLAUDE.md directly to the Claude
#   Code CLI using --print (non-interactive) mode, triggering an immediate run of
#   the entire pre-market pipeline. It is functionally identical to a Routine
#   run, just fired on demand rather than on schedule.
#
# REQUIREMENTS:
#   - Claude Code CLI must be installed:
#       curl -fsSL https://claude.ai/install.sh | bash
#   - You must be authenticated:
#       claude login
#   - Run this script from inside the premarket-routine/ directory so that
#     CLAUDE.md can reference config.json, indicators.md, etc. by relative path
#
# SCHEDULED RUNS:
#   For automated weekday 8:30 AM ET runs, register this project as a Routine
#   at claude.ai/code — see README.md for step-by-step instructions.
#   Do NOT use cron or a scheduler daemon; Claude Code Routines handle this.
#
# USAGE:
#   cd premarket-routine
#   bash run_manual.sh
#
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Pre-Market Intelligence System — Manual Run"
echo "  $(date '+%A, %B %d, %Y — %I:%M %p')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verify claude CLI is available
if ! command -v claude &> /dev/null; then
  echo "ERROR: claude CLI not found."
  echo "Install with: curl -fsSL https://claude.ai/install.sh | bash"
  exit 1
fi

# Verify CLAUDE.md exists
if [ ! -f "CLAUDE.md" ]; then
  echo "ERROR: CLAUDE.md not found. Run this script from the premarket-routine/ directory."
  exit 1
fi

echo "Starting manual pre-market intelligence run..."
echo ""

# Execute the routine by passing CLAUDE.md contents directly to Claude
claude --print "$(cat CLAUDE.md)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Run complete."
echo "  Log:    run_log.txt"
echo "  Report: report_$(date +%Y-%m-%d).html"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
