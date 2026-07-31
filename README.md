# Krishnan Chandra — personal site

Source for [krishnanchandra.com](https://krishnanchandra.com) and [krishnan.blog](https://krishnan.blog). A static blog built with [Hugo](https://gohugo.io/) and a [fork of the hugo-blog-awesome theme](https://github.com/krishnan-chandra/hugo-blog-awesome).

## Local development

Requires [Hugo Extended](https://gohugo.io/installation/) (CI uses 0.164.0).

```bash
git clone --recurse-submodules git@github.com:krishnan-chandra/personal-website.git
cd personal-website
hugo server -D
```

Open http://localhost:1313. Draft posts need `-D`; future-dated posts need `--buildFuture`.

## Project layout

| Path | Purpose |
|------|---------|
| `content/posts/` | Blog posts |
| `content/pages/` | Standalone pages (e.g. About) |
| `assets/` | Images and other assets |
| `hugo.toml` | Site config, menu, author info |
| `themes/hugo-blog-awesome/` | Theme (git submodule) |
| `scripts/verify-hugo/` | Local verification (Hugo server + responsive screenshots) |

## Verification

After layout, theme, or content changes, verify affected pages at desktop and mobile viewports:

```bash
npm install && npx playwright install chromium   # once per machine
scripts/verify-hugo/bin/verify-hugo-proof.sh     # full regression
```

See [`scripts/verify-hugo/SKILL.md`](scripts/verify-hugo/SKILL.md) for details. Cursor loads the skill from [`.cursor/skills/verify-hugo-site/`](.cursor/skills/verify-hugo-site/SKILL.md).

## Deployment

Pushes to `main` trigger [.github/workflows/deploy.yml](.github/workflows/deploy.yml): Hugo builds `public/`, then rsyncs it to a DigitalOcean droplet over SSH.

Manual deploys: GitHub Actions → **Deploy** → **Run workflow**. Optional `ref` input deploys a specific branch, tag, or commit.

Required repository secrets: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`. Optional: `DEPLOY_PATH`, `DEPLOY_PORT`, `DEPLOY_KNOWN_HOSTS`.

## New content

```bash
hugo new posts/my-post.md
```

New posts start with `draft: true` in the front matter (see `archetypes/default.md`). Set `draft: false` or delete the line before publishing, or the post won't appear on the deployed site.

To link out to an external page (video, talk, article) instead of rendering a post body, add an `external` URL to the front matter, as in `content/posts/ramptables-talk.md`.
