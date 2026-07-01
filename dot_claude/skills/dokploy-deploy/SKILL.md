---
name: dokploy-deploy
description: >-
  Trigger and debug deployments to a self-hosted Dokploy instance from CI/CD
  (usually a GitHub Actions deploy step). Use this whenever a deploy to Dokploy
  isn't firing, a Dokploy API call returns 404 / {"code":"NOT_FOUND"} or
  {"message":"Branch Not Match"}, you're wiring a "Deploy to Dokploy" workflow
  step, choosing between the webhook vs API-key approach, or a merge-to-main
  isn't auto-deploying a self-hosted compose/app stack. Trigger even when
  "Dokploy" isn't named but the CI deploys to a self-hosted PaaS reachable over
  Tailscale/a private subnet, since the failure modes here are non-obvious and
  easy to misdiagnose.
---

# Deploying to Dokploy from CI

Dokploy is a self-hosted PaaS (Netlify/Heroku alternative). It deploys
"applications" and "compose" stacks. Getting CI to reliably trigger a deploy is
deceptively tricky because **several mechanisms exist, they behave differently,
and the error responses are ambiguous**. This skill encodes what actually works
and the traps that waste hours.

## The three ways to trigger a deploy — pick the webhook

| Mechanism | How | Use when |
|---|---|---|
| **Per-resource webhook** ✅ | `POST {host}/api/deploy/compose/{refreshToken}` (or `/api/deploy/application/{refreshToken}`) | **Default for CI.** Self-contained — the token in the URL is the auth. No API key, no resource-id lookup, no URL construction. |
| GitHub-App autoDeploy | Dokploy's GitHub integration redeploys on push | Only works if **GitHub can reach the Dokploy instance** (public host). Fails silently for private/tailnet Dokploy — GitHub's webhooks can't reach a LAN/tailnet address. |
| API-key API | `POST {host}/api/compose.deploy` + `x-api-key` + `{"composeId":"..."}` | Avoid for CI. Brittle: composeId drifts when stacks are recreated, and the base-URL must be exactly right (see gotchas). |

**Why the webhook wins:** it removes every moving part that breaks the API-key
path (resource ids, the key, and base-URL formatting). The token *is* a secret,
so store the full webhook URL in one CI secret.

## The working CI recipe (compose webhook)

Dokploy's **compose** webhook mimics a GitHub push: it reads the payload's `ref`
and matches it against the compose's configured branch. A bare POST therefore
fails with `{"message":"Branch Not Match"}` — that response means the token is
valid and you just need to send the branch.

```yaml
- name: Trigger Dokploy deployment
  env:
    DOKPLOY_DEPLOY_WEBHOOK: ${{ secrets.DOKPLOY_DEPLOY_WEBHOOK }}
  run: |
    status=$(curl -sS -o /tmp/dok.txt -w '%{http_code}' -X POST \
      "$DOKPLOY_DEPLOY_WEBHOOK" \
      -H 'x-github-event: push' \
      -H 'Content-Type: application/json' \
      -d '{"ref":"refs/heads/main"}')
    echo "Dokploy responded HTTP $status"; cat /tmp/dok.txt; echo
    test "$status" -ge 200 && test "$status" -lt 300
```

Success looks like `200 {"message":"Compose deployed successfully"}`.

Notes:
- **Application** webhooks (`/api/deploy/application/{token}`) generally accept a
  bare POST (no branch matching) — that's a key compose-vs-app difference. If a
  bare call works, you don't need the `x-github-event`/`ref` payload.
- Always log the HTTP status **and body** (as above). Dokploy's failures are
  only distinguishable by the body, so a bare `curl -f` that hides it will cost
  you the next debugging round.
- Keep any `Connect to Tailscale` step that precedes this — it's what gives the
  runner network access to a private Dokploy.

## Debugging gotchas (these are the time-sinks)

1. **`{"code":"NOT_FOUND"}` is ambiguous.** Dokploy returns the *same* 404
   envelope for a missing **route** and a missing **resource** (bad composeId).
   You cannot tell them apart from the response alone — confirm the route from
   Swagger and the resource id from the API/UI separately.

2. **`/api/*` is auth-gated before routing.** An unauthenticated `POST` to *any*
   `/api/...` path returns `401` — even `/api/zzz.totally.fake`. So you cannot
   fingerprint which routes exist by probing unauthenticated; a 401 means "needs
   auth," not "route exists." (A path *outside* `/api`, like `/deploy`, returning
   404 unauthenticated does prove it's absent.)

3. **Base-URL formatting.** If the deploy URL is built as `${DOKPLOY_URL}/api/...`,
   then `DOKPLOY_URL` must be the **base origin only** — no `/api`, no trailing
   slash. Otherwise you get `…/api/api/...` → 404 that looks like everything else.
   The webhook approach (full URL in one secret) sidesteps this entirely.

4. **Reachability ≠ correctness.** If CI gets *any* JSON back from Dokploy, the
   host/network is fine — connectivity is rarely the bug. A LAN IP (e.g.
   `http://192.168.x.x:3000`) is a valid secret value when the runner reaches it
   via Tailscale subnet routing (the Tailscale node can be the router, not
   Dokploy itself).

5. **Read the real API from Swagger, authenticated.** `GET /swagger` redirects to
   the login SPA when unauthenticated. In a logged-in browser session, fetch the
   OpenAPI spec (`window.ui.specSelectors.specJson()` or the doc endpoint) to get
   the exact paths and the OpenAPI `server` base. The Dokploy version (e.g.
   `v0.29.8`) determines the surface.

## Finding the refresh token and resource ids

In the Dokploy UI, open the compose/app → there's a **webhook / Auto-Deploy URL**
containing the `refreshToken` — that's the whole webhook URL to store as a secret.

To resolve ids/branch programmatically from a logged-in browser session
(cookie auth, no API key): `project.all` → `project.one?projectId=…` →
`environment.one?environmentId=…` exposes `compose[]`/`applications[]` with
`composeId`/`applicationId`, `branch`, `sourceType`. `compose.one?composeId=…`
confirms a single resource (read-only — does not deploy).

## Setting CI secrets

Setting GitHub Actions secrets is typically gated from the agent (it's a
persistent CI config change). Hand the value + command to the user:
`gh secret set DOKPLOY_DEPLOY_WEBHOOK --body "<full-webhook-url>"`.

## Per-app variations

Dokploy setups differ per app/account — **the same idea is wired differently in
different places.** Don't assume one app's recipe transfers. Confirm each app's
mechanism before changing its workflow.

### ToolboxFM (github.com/danielmichaels/ToolboxFM)
- **Mechanism:** per-compose **webhook** (compose needs the `x-github-event: push`
  + `{"ref":"refs/heads/main"}` payload).
- Dokploy `v0.29.8`, private host reached from GitHub Actions via Tailscale
  subnet routing (pfsense), so a LAN IP works in the secret.
- Resource: project `tbfm`, compose `server` (`tbfm-server-csk946`, GitHub
  source, branch `main`, `pull_policy: always` → `ghcr.io/…/toolboxfm:latest`).
- Secret: `DOKPLOY_DEPLOY_WEBHOOK` = full webhook URL. Legacy
  `DOKPLOY_URL`/`DOKPLOY_API_KEY`/`DOKPLOY_COMPOSE_ID` are unused.

### property-check
- **Mechanism:** API-key **`compose.deploy`** (the fragile variant — *not* the
  webhook): `POST ${DOKPLOY_URL}/api/compose.deploy` + `x-api-key` +
  `{"composeId":"$DOKPLOY_COMPOSE_ID"}`. Same Tailscale-to-private-Dokploy setup.
- Nicer build than ToolboxFM (multi-arch amd64+arm64, build-by-digest + manifest
  merge), but the deploy step is bare `curl -fsS` with **no status/body logging**
  — so a failure surfaces only as `curl: (22) ... 404`, undiagnosable.
- Deploy job has no branch guard (`needs: merge` + `if: success()`), so it also
  fires on **tag** pushes / `workflow_dispatch`.
- Carries all three API-key landmines (composeId drift, `DOKPLOY_URL` format, the
  key). Left as-is for now; the migration when ready is: switch to the compose
  webhook (one secret) or at minimum add the status/body logging.
- Secrets: `DOKPLOY_URL`, `DOKPLOY_API_KEY`, `DOKPLOY_COMPOSE_ID`.

### knome
- **Mechanism:** _(differs from ToolboxFM — TODO: capture the specifics.)_ Likely
  candidates to record: is it an **application** (bare-POST webhook) vs a
  **compose** (branch-payload webhook)? Public host (GitHub-App autoDeploy) vs
  private (CI-triggered)? Different secret name/shape? Fill this in the next time
  you touch knome's deploy so future runs don't re-derive it.

> When you encounter a new Dokploy app, add a subsection here: mechanism,
> compose-vs-app, host reachability, the secret(s), and the resource ids.
