# Posts list

The posts archive groups every published blog post by year at `/posts/`, newest first within each year.

## Sub-features

- `posts-year-headings` renders year headings (e.g. `2023`, `2026`).
- `posts-cards` lists post titles as clickable cards under each year.
- `posts-nav-active` highlights the Posts menu link on this page.
- `posts-responsive` keeps year headings and cards readable on mobile without horizontal scroll.

## How to get to it (user POV)

- Click **Posts** in the main navigation.
- Direct URL: `/posts/`.

## Driving it with cursor-ide-browser

Preconditions:

- `verify-hugo doctor` passes.
- `mkdir -p "$(verify-hugo artifacts)/posts-list"`.

- **Navigate.** Open `http://127.0.0.1:1314/posts/`.
- **Desktop (1280×800).** Snapshot expects page heading `Posts`, at least one `h2` year heading, and post links including `Debugging Catastrophic Backtracking for Regular Expressions in Python`. Screenshot → `posts-list/desktop.png`, snapshot → `posts-list/desktop.aria.txt`.
- **Mobile (375×667).** Same content visible; nav shows hamburger. Cards stack in a single column. Screenshot → `posts-list/mobile.png`. Assert no horizontal overflow via CDP.

## Gotchas

- External-link posts (front matter `external:`) still appear as cards but may redirect off-site when clicked — proof here is list rendering, not follow-through.
- Future-dated posts need `--buildFuture`; verification does not pass that flag by default.
- Year grouping uses `.Pages.GroupByDate "2006"` in the theme's `list.html` layout.
