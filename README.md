# archievalmariano.github.io

Personal portfolio for Archieval Mariano — publishing & audience strategy.
Built with [Astro](https://astro.build), deployed to GitHub Pages.

## Develop

```bash
npm install
npm run dev        # local dev server at http://localhost:4321
npm run build      # production build to ./dist
npm run preview    # preview the production build
```

## Content

Content lives in `src/content/` as Markdown, typed by the schemas in
`src/content/config.ts`.

- **Work** — `src/content/work/*.md`. Set `featured: true` (and an `order`) to
  surface an entry on the home page.
- **Writing** — `src/content/writing/*.md`. Newest `pubDate` first.

Set `draft: true` on any entry to hide it from the build and the RSS feed.

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which builds the site
and publishes it to GitHub Pages. In the repository settings, set
**Settings → Pages → Build and deployment → Source** to **GitHub Actions**.

The repo is named `archievalmariano.github.io`, so the site is served from the
domain root and `astro.config.mjs` sets `site` without a `base`.
