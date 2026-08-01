---
globs: ["*.ts", "*.tsx", "*.js", "*.jsx", "*.go", "*.py", "*.rs", "*.zig", "*.md"]
alwaysApply: true
description: Comment Policy
---

## Comment Policy

### Unacceptable Comments
- Comments that repeat what code does 
- Commented-out code (delete it)
- Obvious comments ("incrementing counter")
- Comments instead of good naming
- Comments about updates to old code ("<- now supports xyz")

### Principle
Code should be self-documenting. If you need a comment to explain WHAT the code does, consider refactoring to make it clearer.

### Go doc comments (and any language's API comments)
- A doc comment describes the **contract** from the caller's side — what the
  symbol does and any surprising behavior. It is NOT a narration of the body.
- Keep the WHY, cut the mechanics. One line of non-obvious intent beats a
  paragraph re-describing code the reader can already see.
- Never enumerate callers or internal call sites ("used by handlers, authz,
  metrics readers"). That duplicates what grep shows and rots the moment a
  caller changes.
- Implementation/algorithm notes — if truly needed — go *inside* the function
  body, not the doc comment.
- Start with the symbol name; prefer one declarative sentence. Use "reports
  whether" for bools.

Too verbose (mechanics + caller list, rots on change):
    // GetSystem returns a System for user-facing reads. A tombstoned (Deleting)
    // System is reported as ErrSystemNotFound so it behaves exactly like an
    // unknown id across every caller (handlers, authz resolveSystem, metrics
    // readers). Teardown code that must keep seeing a tombstoned System uses
    // getSystemRaw.

Strategic (contract + the one non-obvious why):
    // GetSystem returns the System for user-facing reads, reporting a
    // tombstoned (Deleting) System as ErrSystemNotFound. Teardown paths that
    // must still see it use getSystemRaw.
