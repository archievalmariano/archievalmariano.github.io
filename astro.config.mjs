// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import mdx from '@astrojs/mdx';
import { homePreviewEnabled } from './src/preview/gate.mjs';

// Gated homepage explorations. The route is injected ONLY for a deliberate
// local opt-in (HOME_PREVIEW=true, no CI indicator); otherwise it is absent
// from the build graph, so production output is byte-for-byte unaffected.
const homePreview = {
  name: 'home-preview-gate',
  hooks: {
    'astro:config:setup': ({ injectRoute, logger }) => {
      if (!homePreviewEnabled()) return;
      logger.warn('HOME_PREVIEW enabled: emitting /preview/home/** (local preview only)');
      injectRoute({
        pattern: '/preview/home/[...variant]',
        entrypoint: './src/preview/HomePreviewRoute.astro',
      });
    },
  },
};

// Served from the domain root (custom domain archievalmariano.com),
// so `site` is set and `base` is intentionally omitted.
export default defineConfig({
  site: 'https://archievalmariano.com',
  integrations: [
    homePreview,
    mdx(),
    // src/pages/goto/** only forward to /desk/goto/ (see RedirectPage.astro).
    // /preview/** (gated homepage explorations) is never emitted in production;
    // it is also excluded here so a local preview build cannot list it.
    sitemap({
      filter: (page) => {
        const { pathname } = new URL(page);
        return !pathname.startsWith('/goto/') && !pathname.startsWith('/preview/');
      },
    }),
  ],
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      wrap: true,
    },
  },
});
