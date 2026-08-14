@/Users/danielmichaels/.codex/AGENTS.md

- always use errors.Is over err == in golang.
- always prefer `jq` over `python -m json.tool`
- NEVER PUT THIS OR ANYTHING LIKE THIS IN A GIT COMMIT OR PR: Co-Authored-By: Claude Opus xxx <noreply@anthropic.com>
- Use Test Driven Development whenever possible unless its a small script, throwaway code block etc. Otherwise we should be using TDD
- Always refer to the nats-mcp MCP server when asked NATS questions or any NATS projects 
- Always use error groups and single flight where possible
- For NATS work in Go, prefer Synadia's orbit.go extensions (`github.com/synadia-io/orbit.go`) over hand-rolled equivalents — especially `natsext.RequestMany` + `RequestManyStall` for scatter/gather request-reply (e.g. `$SRV` micro discovery). Also consider `jetstreamext`, `kvcodec`, `natssysclient`, `natscontext` where they fit. Confirm the exact API via the nats-mcp server first.
- Never create GitHub PR saying claude did it or wrote it or is attributed
- Workflow or ## Editing Conventions section

Always show a preview or example of changes before editing real files; wait for user confirmation before applying broad edits.

## Testing section
- Use TDD: write or update tests first, then implement, and verify all tests pass before committing.
## Debugging section
- Before asserting a root cause during debugging, gather concrete evidence; don't commit to a hypothesis until verified against logs/code.
## Planning section
- For planning, use the /create-plan workflow — do NOT use the superpowers writing-plans or full brainstorming flow unless explicitly asked.
## Code Review section
Verify code review feedback against the actual codebase before agreeing or pushing back; match existing patterns.
- Before implementing any query or data-access change, flag the performance/cost implications first; if it could full-scan or hit large tables, propose a cached or indexed alternative before writing it. For non-SQL/distributed changes, flag eventual-consistency, network-partition, and other CAP trade-offs up front rather than after.
- if mockups or renders are mentioned prefer /frontend-design unless specifically requested to use another skill or using artifacts over ascii.
- Browser automation: default to the firefox-devtools MCP (`mcp__firefox-devtools__*`) — I use Firefox, and Chrome is often not running, which hangs claude-in-chrome. Batch-load the Firefox tools in ONE ToolSearch call. Only use claude-in-chrome or the /web-browser skill if I explicitly ask for Chrome.
## Comment policy

Use comments only to explain behavior, intent, invariants, constraints, or trade-offs that cannot be inferred from the code itself.

- Do not narrate code changes or mention previous turns, user requests, tickets, issues, or implementation history.
- Do not restate what the code plainly does; prefer clear names and structure instead.
- Keep comments concise, accurate, and next to the code they explain.
- Update or remove comments when the behavior they describe changes.
- Treat comments as part of the code: they must be useful to a future reader, not a changelog or conversation log.
