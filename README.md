# 🚀 AI Engineering Optimization Stack

**Universal, Local-First Optimization & Quality Stack for AI Coding Agents (Claude Code, Codex CLI, Hermes Agent, Cursor).**

Proven to cut token context consumption by **~99%**, eliminate AI code slop, enforce senior engineering minimalism, and prevent regressions in production without sending proprietary code to third-party servers.

---

## ⚡ 1-Liner Quick Installation

Run this inside **any** project repository (Node.js, Python, TypeScript, SQL, Bash, Go, Rust, React, etc.):

```bash
curl -fsSL https://raw.githubusercontent.com/sativaglobaleducation/optimization-stack/main/install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/sativaglobaleducation/optimization-stack.git
./optimization-stack/install.sh /path/to/your/project
```

---

## 🧩 The Triad Components

### 1. 🪓 Ponytail (Anti-Overengineering & Anti-Slop)
Channels a pragmatic senior developer who questions YAGNI, reaches for standard library features before third-party packages, and prefers 1 clean line over 50 lines of boilerplate.
* **The Senior Dev Ladder:** YAGNI $\rightarrow$ Reuse existing code $\rightarrow$ Stdlib $\rightarrow$ Native platform features $\rightarrow$ Installed deps $\rightarrow$ 1-line diff $\rightarrow$ Minimum code.
* **Results:** ~54% smaller diffs, ~20% token output savings, zero speculative abstraction.

### 2. 🧠 code-review-graph (Local AST Knowledge Graph via SQLite & FastMCP)
* Parses the entire codebase using **Tree-sitter** (TypeScript, JavaScript, Python, SQL, Bash, Go, Rust, etc.).
* Stores symbols, calls, imports, and architectural communities in a **local SQLite database** (`.code-review-graph/graph.db`) with **FTS5 full-text search**.
* Serves graph context to AI agents via **FastMCP standard stdio**.
* **Impact:** Agents inspect only the affected functions and blast radius instead of reading 100k+ lines of full files.
* **Privacy:** 100% local. Zero external cloud API calls.

### 3. 🛡️ Automated Pre-Commit Risk & Token Telemetry Hook
Calculates the *Blast Radius*, *Risk Score*, and *Token Savings* on every git commit in 1 to 2 seconds:

```
Incremental: 1 files updated, 1 nodes, 31 edges (postprocess=full)
Analyzed 6 changed file(s):
  - 0 changed function(s)/class(es)
  - 0 affected flow(s)
  - 0 test gap(s)
  - Overall risk score: 0.00
┌─────────────────────── Token Savings ────────────────────────┐
│ Full context would be:     66,935 tokens                     │
│ Graph context used:            99 tokens                     │
│ Saved:                     66,836 tokens (~100%)             │
└──────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Supported AI Coding Environments
* **Claude Code CLI:** Native MCP support via `.mcp.json`.
* **OpenAI Codex CLI:** Native MCP integration & hook lifecycle.
* **Hermes Agent:** Bundled skills (`ponytail` & `ponytail-audit`).
* **Cursor / VS Code:** FastMCP stdio server compatible.

---

## 🔒 Security & Compliance
* Zero code or AST data leaves the host machine.
* Compatible with strict HIPAA / LGPD / GDPR environments.
