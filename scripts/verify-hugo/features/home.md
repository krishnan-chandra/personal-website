# Home page

The home page shows Krishnan's author bio (avatar, intro, social links) and the five most recent blog posts with a link to see all posts.

## Sub-features

- `home-bio` renders author name, intro, and social icon links.
- `home-recent-posts` lists up to five recent posts under a "Recent Posts" heading.
- `home-see-all` links to the full posts archive when more than five posts exist.
- `home-nav-active` highlights the Home menu link.
- `home-responsive` lays out bio and posts without horizontal scroll at desktop and mobile widths.

## How to get to it (user POV)

- Open the site root `/` (logo/home icon in the nav also returns here).
- Click **Home** in the main navigation.

## Driving it with cursor-ide-browser

Preconditions:

- `verify-hugo doctor` reports HTTP 200 at `http://127.0.0.1:1314/` and a non-empty `home_title`.
- Artifacts directory exists: `mkdir -p "$(scripts/verify-hugo/bin/verify-hugo artifacts)/home"`.

- **Navigate.** Open `http://127.0.0.1:1314/`. Run `browser_navigate` with that URL.
- **Desktop viewport.** CDP `Emulation.setDeviceMetricsOverride` with width 1280, height 800, mobile false.
- **Desktop proof.** Run `browser_snapshot`; expect `navigation` named `Main Navigation`, link `Home` with active state, heading `Recent Posts`, author name `Krishnan Chandra`. Save snapshot to `home/desktop.aria.txt`. Run `browser_take_screenshot` with `fullPage: true` → `home/desktop.png`.
- **Overflow check.** CDP evaluate scrollWidth vs clientWidth; expect `overflow: false`.
- **Mobile viewport.** CDP set 375×667, mobile true.
- **Mobile proof.** Snapshot shows fixed nav with menu icon (checkbox `#menu-trigger` present in DOM). Bio and post cards stack vertically. Screenshot full page → `home/mobile.png`. Overflow check again.
- **See-all link.** If visible, snapshot should include link text matching `See all posts` (i18n key `home.see_all_posts`).

## Gotchas

- Draft posts appear because verification runs `hugo server -D` (see [basic usage](https://gohugo.io/getting-started/usage/)).
- LiveReload is disabled for stable screenshots; do not expect auto-refresh on file edits during a run.
- The verification port is **1314**, not Hugo's default **1313** — always use the URL from `verify-hugo url`.
- Avatar image comes from `assets/img/profile.png`; a missing asset silently omits the avatar (no build error).
