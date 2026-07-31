#!/usr/bin/env bash
# verify-hugo-proof — run desktop + mobile screenshots for every mapped page.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${ROOT}"

if [[ -z "${VERIFY_RUN_ID:-}" ]]; then
  export VERIFY_RUN_ID="proof-$(date +%s)"
fi

"${BIN}/verify-hugo" launch
"${BIN}/verify-hugo" doctor

BASE="$("${BIN}/verify-hugo" url)"
ART="$("${BIN}/verify-hugo" artifacts)"
SHOT="${BIN}/verify-hugo-screenshot"

capture() {
  local feature="$1" path="$2"
  mkdir -p "${ART}/${feature}"
  "${SHOT}" --url "${BASE}${path}" --viewport desktop \
    --out "${ART}/${feature}/desktop.png" --aria "${ART}/${feature}/desktop.aria.txt"
  "${SHOT}" --url "${BASE}${path}" --viewport mobile \
    --out "${ART}/${feature}/mobile.png" --aria "${ART}/${feature}/mobile.aria.txt"
}

capture home /
capture posts-list /posts/
capture blog-post /posts/regex-catastrophic-backtracking/
capture about /pages/about/

# Mobile nav: home at mobile with hamburger menu opened
mkdir -p "${ART}/mobile-nav"
VERIFY_SCREENSHOT_PREP=open-mobile-menu \
  VERIFY_SCREENSHOT_URL="${BASE}/" \
  VERIFY_SCREENSHOT_WIDTH=375 VERIFY_SCREENSHOT_HEIGHT=667 \
  VERIFY_SCREENSHOT_MOBILE=true \
  VERIFY_SCREENSHOT_OUT="${ART}/mobile-nav/menu-open.png" \
  VERIFY_SCREENSHOT_ARIA="${ART}/mobile-nav/menu-open.aria.txt" \
  node "${BIN}/screenshot.mjs"

echo "proof complete: ${ART}"
"${BIN}/verify-hugo" stop
