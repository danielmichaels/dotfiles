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
