---
name: verify-hugo-site
description: Drive Krishnan Chandra's Hugo personal site locally — launch the dev server, screenshot pages at desktop and mobile viewports, and verify responsive layout. Use after layout, theme, content, or Hugo config changes.
---

# Verify Hugo personal site

Project-local verification for this repository. Scripts and the feature map live under [`scripts/verify-hugo/`](../../scripts/verify-hugo/); this file is the Cursor skill entry point.

**Read first:** [`scripts/verify-hugo/features/README.md`](../../scripts/verify-hugo/features/README.md)  
**Full instructions:** [`scripts/verify-hugo/SKILL.md`](../../scripts/verify-hugo/SKILL.md)

## Quick start

```bash
export VERIFY_RUN_ID="verify-$(date +%s)"
scripts/verify-hugo/bin/verify-hugo launch
scripts/verify-hugo/bin/verify-hugo-proof.sh   # full regression
scripts/verify-hugo/bin/verify-hugo stop
```

**Rule:** any page you modify must be verified at desktop and mobile before finishing the task. Theme or layout changes → run the full proof script.

**Prerequisites:** Hugo Extended, `npm install`, `npx playwright install chromium`.
