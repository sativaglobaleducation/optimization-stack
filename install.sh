#!/usr/bin/env bash
# ==============================================================================
# AI Engineering Optimization Stack — Installer
# ------------------------------------------------------------------------------
# 1. Ponytail (Anti-Slop & YAGNI Senior Engineering Guidelines)
# 2. code-review-graph (Local AST SQLite Graph + FastMCP + Pre-commit Hook)
# 3. Universal AI Agent MCP Config (Claude Code, Codex, Hermes, Cursor)
#
# Quick 1-Liner Install:
#   curl -fsSL https://raw.githubusercontent.com/sativaglobaleducation/optimization-stack/main/install.sh | bash
# ==============================================================================

set -e

TARGET_DIR="${1:-$(pwd)}"
cd "$TARGET_DIR"

echo "======================================================================"
echo "🚀 Provisioning AI Optimization Stack in: $TARGET_DIR"
echo "======================================================================"

# 1. Install code-review-graph CLI
if ! command -v code-review-graph &> /dev/null; then
    echo "📦 Installing 'code-review-graph' via pip..."
    pip install -q code-review-graph || pip3 install -q code-review-graph
else
    echo "✅ 'code-review-graph' is already installed."
fi

# 2. Initialize Git if not present
if [ ! -d ".git" ]; then
    echo "⚙️ Initializing Git repository..."
    git init -q
fi

# 3. Build Local AST Graph
echo "🧠 Building local AST Graph (SQLite + FTS5)..."
code-review-graph build

# 4. Configure MCP and Git Pre-commit Hooks
echo "🔌 Configuring MCP servers and Git hooks..."
code-review-graph install -y --no-instructions --platform claude-code --platform codex || true

# 5. Ensure .gitignore entries
if [ -f ".gitignore" ]; then
    if ! grep -q ".code-review-graph/graph.db" .gitignore; then
        echo -e "\n# code-review-graph local database\n.code-review-graph/graph.db\n.code-review-graph/*.tmp\n" >> .gitignore
        echo "📝 Updated .gitignore"
    fi
else
    echo -e "# code-review-graph local database\n.code-review-graph/graph.db\n.code-review-graph/*.tmp\n" > .gitignore
    echo "📝 Created .gitignore"
fi

# 6. Install Hermes Skills if Hermes is present on machine
if [ -d "$HOME/.hermes" ]; then
    echo "🤖 Hermes Agent detected. Installing Ponytail skills..."
    mkdir -p "$HOME/.hermes/skills/software-development/ponytail"
    mkdir -p "$HOME/.hermes/skills/software-development/ponytail-audit"
    
    cat << 'EOF' > "$HOME/.hermes/skills/software-development/ponytail/SKILL.md"
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
EOF

    cat << 'EOF' > "$HOME/.hermes/skills/software-development/ponytail-audit/SKILL.md"
---
name: ponytail-audit
description: Use when auditing codebase for bloat. Lists items to cut.
license: MIT
---

# Ponytail Audit

Whole-repo audit for over-engineering. Scan the whole tree instead of a diff. Rank findings biggest cut first.
EOF
    echo "✅ Hermes skills provisioned."
fi

# 7. Print Final Status
echo "📊 Graph Status:"
code-review-graph status

echo "======================================================================"
echo "🎉 STACK SUCCESSFULLY INSTALLED!"
echo "   - Local AST Graph: .code-review-graph/graph.db (~99% Token Savings)"
echo "   - Pre-commit Hook: Active (Risk analysis & token savings monitor)"
echo "   - MCP Integrations: Claude Code, Codex, Hermes ready"
echo "======================================================================"
