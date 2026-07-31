# Hugo site verification map

Maintained source for verifying [Krishnan Chandra's personal site](https://krishnanchandra.com) built with [Hugo](https://gohugo.io/) and the [hugo-blog-awesome](https://github.com/krishnan-chandra/hugo-blog-awesome) theme fork.

Read this index before driving the app, then open the matching feature file for the recipe.

## Baseline preconditions

- Hugo Extended installed (`hugo version` must report `extended`). CI uses 0.164.0; see [Hugo installation](https://gohugo.io/installation/).
- Theme submodule present: `themes/hugo-blog-awesome/` (clone with `--recurse-submodules`).
- Launch a **verification-only** dev server — never reuse the user's personal `hugo server` on port 1313:

```bash
export VERIFY_RUN_ID="manual-$(date +%s)"
scripts/verify-hugo/bin/verify-hugo launch
scripts/verify-hugo/bin/verify-hugo doctor
```

- Base URL defaults to `http://127.0.0.1:1314/` (`VERIFY_HUGO_PORT` overrides).
- Artifacts go to `.verify/artifacts/$VERIFY_RUN_ID/` for the current run. Older runs under `.verify/artifacts/` are deleted automatically on the next `verify-hugo launch`.

## Responsive conventions

The theme defines mobile styles at **max-width 768px** (`$on-mobile` in `themes/hugo-blog-awesome/assets/sass/main.scss`). Every page recipe drives **two viewports**:

| Profile | Viewport | Expected layout |
|---------|----------|-----------------|
| `desktop` | 1280×800 | Inline nav links (`Home`, `Posts`, `About`); no hamburger |
| `mobile` | 375×667 | Fixed top bar; `#menu-trigger` checkbox opens full-screen nav |

Set viewport with browser CDP before each screenshot:

```json
{"method":"Emulation.setDeviceMetricsOverride","params":{"width":1280,"height":800,"deviceScaleFactor":1,"mobile":false}}
```

```json
{"method":"Emulation.setDeviceMetricsOverride","params":{"width":375,"height":667,"deviceScaleFactor":2,"mobile":true}}
```

After each viewport, assert no horizontal overflow:

```json
{"method":"Runtime.evaluate","params":{"expression":"JSON.stringify({overflow: document.documentElement.scrollWidth > document.documentElement.clientWidth, scrollWidth: document.documentElement.scrollWidth, clientWidth: document.documentElement.clientWidth})","returnByValue":true}}
```

Expect `overflow: false`. The `<meta name="viewport" content="width=device-width, initial-scale=1.0">` tag comes from the theme's `meta/standard.html` partial.

## Driving conventions

- Harness: **cursor-ide-browser** MCP (`browser_navigate`, `browser_snapshot`, `browser_take_screenshot`, `browser_cdp`, `browser_click`).
- Prefer ARIA roles and link names from the feature file over CSS selectors.
- Capture **both** an ARIA snapshot and a **full-page** screenshot per viewport.
- File naming: `artifacts/<feature>/<viewport>.{png,aria.txt}` (e.g. `home/desktop.png`).
- Never kill processes by name; only `verify-hugo stop` (by pid file).

## Modified pages must be verified

After any edit, identify every **user-facing URL** the change affects and verify each one at desktop and mobile before finishing the task. Content edits verify that page's URL; theme or layout edits verify every mapped page (run `verify-hugo-proof.sh` for a full regression).

Add a feature file first if you introduce a new standalone page or route.

Full regression (all mapped pages, both viewports):

```bash
scripts/verify-hugo/bin/verify-hugo-proof.sh
```

## Proof and skip reporting

- Exercise the real user path through Hugo's embedded server ([hugo server docs](https://gohugo.io/commands/hugo_server/)), not raw `public/` files unless comparing production build output.
- Proof = action + resulting state: navigation click **and** URL/title change; mobile menu open **and** links visible in snapshot.
- Report unreachable paths with the attempted URL and unmet precondition.
- Do not mark a feature verified if only one viewport was captured.

## Feature entry contract

Each feature file uses exactly four H2 sections: `Sub-features`, `How to get to it (user POV)`, `Driving it with cursor-ide-browser`, `Gotchas`.

## Features

- [Home page](./home.md) — author bio, recent posts, desktop/mobile layout.
- [Posts list](./posts-list.md) — year-grouped archive at `/posts/`.
- [Blog post](./blog-post.md) — single post with code blocks and readable mobile typography.
- [About page](./about.md) — standalone page at `/pages/about/`.
- [Mobile navigation](./mobile-navigation.md) — hamburger menu and link reachability on small screens.
