# Mobile navigation

On viewports ≤768px the theme switches to a fixed top bar with a hamburger control that opens a full-screen overlay menu ([`_navbar.scss`](../../../../themes/hugo-blog-awesome/assets/sass/_navbar.scss) `@include media-query($on-mobile)`).

## Sub-features

- `mobile-hamburger` shows the menu icon and hidden `#menu-trigger` checkbox.
- `mobile-menu-open` checking the trigger reveals Home, Posts, About links full-screen.
- `mobile-menu-navigate` tapping a link closes the overlay and loads the target page.
- `mobile-theme-toggle` exposes the light/dark `#mode` control in the mobile header.

## How to get to it (user POV)

- Shrink the browser below 768px width (verification uses 375×667).
- Tap the hamburger icon (label associated with `#menu-trigger`).
- Choose a menu link.

## Driving it with cursor-ide-browser

Preconditions:

- `verify-hugo doctor` passes.
- CDP viewport 375×667, mobile true.
- `mkdir -p "$(scripts/verify-hugo/bin/verify-hugo artifacts)/mobile-nav"`.

- **Navigate.** Open `http://127.0.0.1:1314/`.
- **Closed state.** Snapshot: nav links in `.trigger` should not be interactable/visible until menu opens (theme uses checkbox `:not(:checked) ~ .trigger { visibility: hidden }`).
- **Open menu.** Toggle `#menu-trigger` (the hamburger uses a CSS checkbox; the label may not be Playwright-visible). Run `browser_click` on the menu icon label, or set the checkbox via CDP/Playwright: `document.getElementById('menu-trigger').checked = true`. Snapshot must list links `Home`, `Posts`, `About`. Screenshot → `mobile-nav/menu-open.png`.
- **Navigate via menu.** Click `Posts`. URL becomes `/posts/`; Posts link active. Screenshot → `mobile-nav/posts-via-menu.png`.
- **Desktop regression.** Reset CDP to 1280×800; inline links visible without opening hamburger. Screenshot → `mobile-nav/desktop-inline-nav.png`.

## Gotchas

- The menu uses a CSS checkbox hack — click the `<label for="menu-trigger">`, not the hidden checkbox input directly.
- Overlay is `position: fixed` with `height: 100vh`; ensure screenshots use `fullPage: true` only when testing page content, not the overlay state.
- Do not confuse this with Hugo's dev-server [404 redirect behavior](https://gohugo.io/configuration/server/) — unrelated to nav.
