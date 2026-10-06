---
name: ponytail-audit
description: Use when auditing codebase for bloat. Lists items to cut.
license: MIT
---

# Ponytail Audit

Whole-repo audit for over-engineering. Scan the whole tree instead of a diff. Rank findings biggest cut first.

## Tags
- `delete:` dead code, unused flexibility, speculative feature. Replacement: nothing.
- `stdlib:` hand-rolled thing the standard library ships. Name the function.
- `native:` dependency or code doing what the platform already does. Name the feature.
- `reuse:` equivalent helper, util, or pattern already in this repo. Name the path.
- `yagni:` abstraction with one implementation, config nobody sets, layer with one caller.
- `shrink:` same logic, fewer lines. Show the shorter form.
