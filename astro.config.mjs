// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import mdx from '@astrojs/mdx';

// Served from the domain root (custom domain archievalmariano.com),
// so `site` is set and `base` is intentionally omitted.
export default defineConfig({
  site: 'https://archievalmariano.com',
  integrations: [mdx(), sitemap()],
  // GOTO moved under DESK. GitHub Pages cannot send HTTP redirects, so these
  // build to pages that refresh immediately and point canonical to the target.
  redirects: {
    '/goto': '/desk/goto/',
    '/goto/install': '/desk/goto/install/',
    '/goto/install/x4-pro': '/desk/goto/install/x4-pro/',
  },
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      wrap: true,
    },
  },
});
