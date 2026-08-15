// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import mdx from '@astrojs/mdx';

// Served from the domain root (custom domain archievalmariano.com),
// so `site` is set and `base` is intentionally omitted.
export default defineConfig({
  site: 'https://archievalmariano.com',
  integrations: [mdx(), sitemap()],
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      wrap: true,
    },
  },
});
