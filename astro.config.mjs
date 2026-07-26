// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import mdx from '@astrojs/mdx';

// User site (archievalmariano.github.io) is served from the domain root,
// so `site` is set and `base` is intentionally omitted.
export default defineConfig({
  site: 'https://archievalmariano.github.io',
  integrations: [mdx(), sitemap()],
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      wrap: true,
    },
  },
});
