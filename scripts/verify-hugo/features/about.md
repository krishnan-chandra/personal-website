# About page

The About page is a standalone content page describing Krishnan's background, rendered from `content/pages/about.md`.

## Sub-features

- `about-content` renders the Markdown biography with external links.
- `about-title` shows page title `About`.
- `about-nav` includes About in navigation (URL `/pages/about/` per `hugo.toml` menu).
- `about-responsive` reflows long paragraphs and links on mobile.

## How to get to it (user POV)

- Click **About** in the main navigation.
- Direct URL: `/pages/about/`.

## Driving it with cursor-ide-browser

Preconditions:

- `verify-hugo doctor` passes.
- `mkdir -p "$(scripts/verify-hugo/bin/verify-hugo artifacts)/about"`.

- **Navigate.** Open `http://127.0.0.1:1314/pages/about/`.
- **Desktop (1280×800).** Snapshot expects heading `About`, body text mentioning `Krishnan Chandra`, and links such as `Aaru` or `Ramp`. Screenshot → `about/desktop.png`.
- **Mobile (375×667).** Paragraphs stack; links remain tappable. Screenshot → `about/mobile.png`. No horizontal page overflow.

## Gotchas

- Menu entry uses explicit `url = "/pages/about"` rather than `pageRef`; Hugo resolves it correctly but permalinks include the `pages/` segment.
- Future-dated front matter (`date: 2026-08-10`) publishes only with `-D` or past date — verification uses `-D`.
