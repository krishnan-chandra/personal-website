import { chromium } from 'playwright';
import { writeFileSync } from 'fs';

const url = process.env.VERIFY_SCREENSHOT_URL;
const width = Number(process.env.VERIFY_SCREENSHOT_WIDTH);
const height = Number(process.env.VERIFY_SCREENSHOT_HEIGHT);
const mobile = process.env.VERIFY_SCREENSHOT_MOBILE === 'true';
const out = process.env.VERIFY_SCREENSHOT_OUT;
const ariaPath = process.env.VERIFY_SCREENSHOT_ARIA || '';

const browser = await chromium.launch();
const context = await browser.newContext({
  viewport: { width, height },
  isMobile: mobile,
  deviceScaleFactor: mobile ? 2 : 1,
});
const page = await context.newPage();
await page.goto(url, { waitUntil: 'networkidle' });

const metrics = await page.evaluate(() => ({
  overflow: document.documentElement.scrollWidth > document.documentElement.clientWidth,
  scrollWidth: document.documentElement.scrollWidth,
  clientWidth: document.documentElement.clientWidth,
  viewportMeta: document.querySelector('meta[name="viewport"]')?.content ?? null,
  title: document.title,
}));

if (ariaPath) {
  const snapshot = await page.locator('body').ariaSnapshot();
  writeFileSync(ariaPath, snapshot, 'utf8');
}

await page.screenshot({ path: out, fullPage: true });
await browser.close();

console.error(JSON.stringify({ url, viewport: { width, height, mobile }, metrics }, null, 2));
if (metrics.overflow) {
  console.error('FAIL: horizontal page overflow detected');
  process.exit(1);
}
