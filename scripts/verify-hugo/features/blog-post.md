# Blog post

A single blog post renders its title, date, optional table of contents, Markdown body (including syntax-highlighted code blocks), and footer.

## Sub-features

- `post-header` shows title and formatted publish date.
- `post-body` renders Markdown content with working heading hierarchy.
- `post-code-blocks` displays fenced code with horizontal scroll or wrap on narrow viewports (not page-wide overflow).
- `post-responsive` keeps prose readable at 375px width.

## How to get to it (user POV)

- From home or `/posts/`, click a post title.
- Direct URL: `/posts/regex-catastrophic-backtracking/` (stable published post with code blocks).

## Driving it with cursor-ide-browser

Preconditions:

- `verify-hugo doctor` passes.
- `mkdir -p "$(scripts/verify-hugo/bin/verify-hugo artifacts)/blog-post"`.

- **Navigate.** Open `http://127.0.0.1:1314/posts/regex-catastrophic-backtracking/`.
- **Desktop (1280×800).** Snapshot expects `h1` containing `Debugging Catastrophic Backtracking`, a `time` element, and a `code` or pre block with `py-spy`. Full-page screenshot → `blog-post/desktop.png`.
- **Mobile (375×667).** Title and body text reflow; page-level horizontal overflow must be false even if individual code blocks scroll internally. Screenshot → `blog-post/mobile.png`.
- **Overflow check.** CDP evaluate on `document.documentElement`; `scrollWidth` must not exceed `clientWidth`.

## Gotchas

- Site config sets `toc = false` globally; do not expect a table of contents unless a post overrides it.
- Posts with bundle resources (e.g. `code/multiplier.py`) do not render that file unless linked from Markdown.
- Syntax highlighting requires Hugo Extended and the theme SCSS pipeline.
