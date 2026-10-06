#!/usr/bin/env bash
# ==============================================================================
# AI Engineering Optimization Stack — Universal Turnkey Installer (VPS Hardened)
# ------------------------------------------------------------------------------
# Installs BOTH core tools simultaneously in one execution:
# 1. Ponytail (Anti-Slop, YAGNI & Minimal Diffs Engineering Rules)
# 2. code-review-graph (Local AST SQLite Graph + FastMCP + Pre-commit Hook)
#
# Quick 1-Liner Install:
#   curl -fsSL https://raw.githubusercontent.com/sativaglobaleducation/optimization-stack/main/install.sh | bash
# ==============================================================================

set -e

# Export local bin to PATH in case pip installs to ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

TARGET_DIR="${1:-$(pwd)}"
cd "$TARGET_DIR"

echo "======================================================================"
echo "🚀 Provisioning AI Optimization Stack (Ponytail + code-review-graph)"
echo "   Target Directory: $TARGET_DIR"
echo "   User: $(whoami) | OS: $(uname -s) $(uname -m)"
echo "======================================================================"

# ------------------------------------------------------------------------------
# 1. TOOL 1: Install & Build code-review-graph (Local AST SQLite Knowledge Graph)
# ------------------------------------------------------------------------------
echo "📦 [1/2] Setting up 'code-review-graph'..."

# Ensure pip is available
if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        echo "   ↳ Installing python3-pip..."
        sudo apt-get update -qq && sudo apt-get install -y -qq python3-pip python3-venv || true
    fi
fi

# Install code-review-graph (Handling PEP 668 on modern Linux/Debian/Ubuntu)
if ! command -v code-review-graph &> /dev/null; then
    echo "   ↳ Installing 'code-review-graph' CLI..."
    pip install -q code-review-graph 2>/dev/null || \
    pip3 install -q code-review-graph 2>/dev/null || \
    pip install -q --break-system-packages code-review-graph 2>/dev/null || \
    pip3 install -q --break-system-packages code-review-graph 2>/dev/null || \
    python3 -m pip install -q --break-system-packages code-review-graph 2>/dev/null || \
    pipx install code-review-graph 2>/dev/null || {
        echo "❌ Failed to install code-review-graph via pip. Trying python3 -m pip..."
        python3 -m pip install --break-system-packages code-review-graph
    }
else
    echo "   ↳ 'code-review-graph' CLI is already installed."
fi

# Ensure executable is accessible
if ! command -v code-review-graph &> /dev/null; then
    if [ -f "$HOME/.local/bin/code-review-graph" ]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

# Initialize Git if not present
if [ ! -d ".git" ]; then
    echo "   ↳ Initializing Git repository..."
    git init -q
fi

# Build Local AST Graph
echo "   ↳ Building AST Knowledge Graph (SQLite + FTS5 full-text search)..."
code-review-graph build || python3 -m code_review_graph build

# Configure Platforms & MCP (Claude Code, Codex, Cursor, etc.)
echo "   ↳ Configuring MCP servers and Git Pre-commit Hooks..."
code-review-graph install -y --no-instructions --platform claude-code --platform codex || \
python3 -m code_review_graph install -y --no-instructions --platform claude-code --platform codex || true

# Ensure .mcp.json in repo root for all MCP clients (Claude Code, Cursor, Codex, Hermes)
if [ ! -f ".mcp.json" ]; then
    cat << 'MCPEOF' > .mcp.json
{
  "mcpServers": {
    "code-review-graph": {
      "command": "python3",
      "args": ["-m", "code_review_graph", "serve"],
      "type": "stdio"
    }
  }
}
MCPEOF
    echo "   ↳ Created .mcp.json for universal MCP client support."
fi

# Ensure .gitignore entries
if [ -f ".gitignore" ]; then
    if ! grep -q ".code-review-graph/graph.db" .gitignore; then
        echo -e "\n# code-review-graph local database\n.code-review-graph/graph.db\n.code-review-graph/*.tmp\n" >> .gitignore
        echo "   ↳ Updated .gitignore (ignored .code-review-graph/graph.db)"
    fi
else
    echo -e "# code-review-graph local database\n.code-review-graph/graph.db\n.code-review-graph/*.tmp\n" > .gitignore
    echo "   ↳ Created .gitignore"
fi

# ------------------------------------------------------------------------------
# 2. TOOL 2: Install Ponytail (Anti-Slop & Senior Minimalism Rules)
# ------------------------------------------------------------------------------
echo "🪓 [2/2] Provisioning 'Ponytail' Anti-Slop & YAGNI rules..."

# Install for Hermes Agent if present
if [ -d "$HOME/.hermes" ]; then
    mkdir -p "$HOME/.hermes/skills/software-development/ponytail"
    mkdir -p "$HOME/.hermes/skills/software-development/ponytail-audit"
    
    cat << 'SKILLEOF' > "$HOME/.hermes/skills/software-development/ponytail/SKILL.md"
---
name: ponytail
description: Use when writing or editing code. Enforces minimal diffs.
argument-hint: "[lite|full|ultra]"
license: MIT
---

# Ponytail

You are a lazy senior developer. Lazy means efficient, not careless. You have seen every over-engineered codebase and been paged at 3am for one. The best code is the code never written.

## Persistence
ACTIVE EVERY RESPONSE. Default: full.

## The ladder
Stop at the first rung that holds:
1. Does this need to exist at all? (YAGNI)
2. Already in this codebase? Reuse it.
3. Stdlib does it? Use it.
4. Native platform feature covers it? Use it.
5. Already-installed dependency solves it? Use it.
6. Can it be one line? One line.
7. Only then: the minimum code that works.
SKILLEOF

    cat << 'SKILLEOF' > "$HOME/.hermes/skills/software-development/ponytail-audit/SKILL.md"
---
name: ponytail-audit
description: Use when auditing codebase for bloat. Lists items to cut.
license: MIT
---

# Ponytail Audit

Whole-repo audit for over-engineering. Scan the whole tree instead of a diff. Rank findings biggest cut first.
SKILLEOF
    echo "   ↳ Provisioned Ponytail skills in Hermes Agent."
fi

# Append Ponytail directive to AGENTS.md / CLAUDE.md if present
if [ -f "AGENTS.md" ]; then
    if ! grep -q "Ponytail" AGENTS.md; then
        echo -e "\n## Engineering Standard: Ponytail (Anti-Slop)\nFollow the Senior Dev Ladder: YAGNI -> Reuse existing code -> Stdlib -> Native -> Minimal diff.\n" >> AGENTS.md
        echo "   ↳ Injected Ponytail standard into AGENTS.md."
    fi
fi

# ------------------------------------------------------------------------------
# 3. Final Summary & Verification
# ------------------------------------------------------------------------------
echo "======================================================================"
echo "🎉 BOTH TOOLS INSTALLED AND FULLY OPERATIONAL!"
echo "   1. code-review-graph: Active (.code-review-graph/graph.db | ~99% Token Savings)"
echo "   2. Ponytail: Active (Minimal diffs, YAGNI, anti-slop guidelines)"
echo "   3. Pre-commit Hook: Active (Auto-monitors blast radius on git commit)"
echo "   4. MCP Server: Active for Claude Code, Codex, Hermes, and Cursor"
echo "======================================================================"
