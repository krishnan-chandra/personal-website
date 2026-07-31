---
name: verify-hugo-site
description: Drive Krishnan Chandra's Hugo personal site locally — launch the dev server, screenshot pages at desktop and mobile viewports, and verify responsive layout. Use after layout, theme, content, or Hugo config changes.
---

# Verify Hugo personal site

Static blog at [krishnanchandra.com](https://krishnanchandra.com), built with [Hugo Extended](https://gohugo.io/installation/) and the `hugo-blog-awesome` theme fork. Primary surface: **web UI** served by Hugo's embedded dev server.

Official Hugo references used by this skill:

- [hugo server command](https://gohugo.io/commands/hugo_server/) — flags, default port 1313, `--disableLiveReload`, `--bind`, `--port`
- [Basic usage / develop locally](https://gohugo.io/getting-started/usage/) — `hugo server`, LiveReload, draft content with `-D`
- [Configure server](https://gohugo.io/configuration/server/) — dev-only redirects and 404 behavior

## Launch

Start an isolated verification server (never attach to the user's existing session on 1313):

```bash
export VERIFY_RUN_ID="verify-$(date +%s)"
.cursor/skills/verify-hugo-site/bin/verify-hugo launch
```

Ready when stdout prints `ready http://127.0.0.1:1314/` and the log at `/tmp/verify-hugo-$VERIFY_RUN_ID/hugo.log` contains `Web Server is available`.

Launch command (inside helper): `hugo server -D --port $VERIFY_HUGO_PORT --bind 127.0.0.1 --disableLiveReload` from repo root. Requires **Hugo Extended** (SCSS). `-D` includes drafts per project README.

**Teardown:**

```bash
.cursor/skills/verify-hugo-site/bin/verify-hugo stop
```

Only stops the pid recorded in `/tmp/verify-hugo-$VERIFY_RUN_ID/hugo.pid`. Never `pkill hugo`.

## Doctor

Run before driving whenever anything looks wrong:

```bash
.cursor/skills/verify-hugo-site/bin/verify-hugo doctor
```

Pass criteria: exit 0, `home_http: 200`, non-empty `home_title`, pid owns `VERIFY_HUGO_PORT` (default 1314).

## When to verify

**Any page you modify must be verified before the task is done.** Match the change to a feature map entry (or add one under `features/` first):

| Change touches | Verify |
|----------------|--------|
| `content/_index.md`, home layout, bio partial | [Home](./features/home.md) |
| `content/posts/_index.md`, list layout | [Posts list](./features/posts-list.md) |
| A specific post under `content/posts/` | [Blog post](./features/blog-post.md) — use that post's URL |
| `content/pages/about.md` or other standalone pages | [About](./features/about.md) or a new feature file |
| Nav, header, theme SCSS breakpoints | [Mobile navigation](./features/mobile-navigation.md) **and** every page you changed |

Capture desktop **and** mobile screenshots for each affected page. A layout or theme change can break responsiveness on pages you didn't edit — run the full proof script when shared assets change.

**Prerequisites:** `npm install` and `npx playwright install chromium` (once per machine).

## Drive

Read `.cursor/skills/verify-hugo-site/features/README.md`, then the feature file for the behavior under test.

**Harness:** cursor-ide-browser MCP for interactive flows (mobile menu). Use the Playwright helper for viewport screenshots and overflow checks:

```bash
BASE="$(verify-hugo url)"
ART="$(verify-hugo artifacts)"
verify-hugo-screenshot --url "$BASE/" --viewport desktop --out "$ART/home/desktop.png" --aria "$ART/home/desktop.aria.txt"
verify-hugo-screenshot --url "$BASE/" --viewport mobile --out "$ART/home/mobile.png" --aria "$ART/home/mobile.aria.txt"
```

Interactive steps (menu open, link clicks) via browser MCP:

1. `browser_navigate` to the feature URL (`verify-hugo url` + path).
2. Set viewport via `browser_cdp`:
   - Desktop: `Emulation.setDeviceMetricsOverride` → 1280×800, `mobile: false`
   - Mobile: 375×667, `deviceScaleFactor: 2`, `mobile: true` (below theme breakpoint `$on-mobile: 768px`)
3. `browser_snapshot` → save ARIA text under artifacts.
4. `browser_take_screenshot` with `fullPage: true` → save PNG under artifacts.
5. Assert responsive layout: CDP `Runtime.evaluate` (or rely on `verify-hugo-screenshot` exit code):

```javascript
JSON.stringify({
  overflow: document.documentElement.scrollWidth > document.documentElement.clientWidth,
  scrollWidth: document.documentElement.scrollWidth,
  clientWidth: document.documentElement.clientWidth,
  viewportMeta: document.querySelector('meta[name="viewport"]')?.content
})
```

Expect `overflow: false` and viewport meta `width=device-width, initial-scale=1.0`.

**Stable handles:**

| Element | Handle |
|---------|--------|
| Main nav | `aria-label="Main Navigation"` |
| Menu links | link name `Home`, `Posts`, `About` |
| Mobile menu | click label for `#menu-trigger` |
| Recent posts | heading `Recent Posts` |
| Author | text `Krishnan Chandra` |

## Evidence

Artifacts root (persists after stop):

```bash
ARTIFACTS="$(.cursor/skills/verify-hugo-site/bin/verify-hugo artifacts)"
# default: .verify/artifacts/$VERIFY_RUN_ID/
```

Per feature, per viewport:

- `$ARTIFACTS/<feature>/desktop.png` + `desktop.aria.txt`
- `$ARTIFACTS/<feature>/mobile.png` + `mobile.aria.txt`

**Proof standards:**

- Drive through Hugo's live server, not stale `public/` output.
- Capture **both** desktop and mobile for every page feature.
- Include action **and** state (e.g. menu opened → links visible in snapshot).
- Check page-level horizontal overflow, not just "looks fine" in screenshot.
- Code blocks may scroll internally; the document must not.

## Cleanup

```bash
.cursor/skills/verify-hugo-site/bin/verify-hugo stop
```

Removes the verification server and pid file only. **Do not delete** `.verify/artifacts/$VERIFY_RUN_ID/`.

Optional: remove state dir `rm -rf /tmp/verify-hugo-$VERIFY_RUN_ID` (logs only, not proof).

## Helpers

All invocations from repo root:

| Command | Purpose |
|---------|---------|
| `verify-hugo launch` | Start background Hugo server on port 1314 |
| `verify-hugo doctor` | Health check |
| `verify-hugo url` | Print base URL |
| `verify-hugo artifacts` | Print artifacts directory |
| `verify-hugo stop` | Stop verification server |
| `verify-hugo-screenshot` | Playwright full-page screenshot + overflow check at desktop/mobile viewport |

| `verify-hugo-proof.sh` | Screenshot all mapped pages at desktop + mobile (full regression) |

Scripts live in `.cursor/skills/verify-hugo-site/bin/` (must be executable). Requires project `devDependencies.playwright` and browsers from `npx playwright install chromium`.

Environment overrides: `VERIFY_RUN_ID`, `VERIFY_HUGO_PORT`, `VERIFY_HUGO_BIND`, `VERIFY_STATE_DIR`, `VERIFY_ARTIFACTS_DIR`.

## Feature map

See [features/README.md](features/README.md):

- [Home](./features/home.md)
- [Posts list](./features/posts-list.md)
- [Blog post](./features/blog-post.md)
- [About](./features/about.md)
- [Mobile navigation](./features/mobile-navigation.md)

Maintain with `/maintain-verification-skill` when routes, menu, or theme breakpoints change.
