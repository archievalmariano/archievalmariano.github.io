import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';

export async function GET(context) {
  // Only dated writing (internal essays) appears in the feed; outward-linked
  // commissioned pieces without a confirmed date are excluded.
  const writing = (await getCollection('writing', ({ data }) => !data.draft && data.pubDate)).sort(
    (a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf()
  );

  return rss({
    title: 'Archieval Mariano — Writing',
    description:
      'Essays and notes on publishing, audience strategy, and building readerships.',
    site: context.site,
    items: writing.map((entry) => ({
      title: entry.data.title,
      description: entry.data.description,
      pubDate: entry.data.pubDate,
      link: entry.data.externalURL ?? `/writing/${entry.slug}/`,
    })),
  });
}
