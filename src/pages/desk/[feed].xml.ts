// Combined DESK feed → /desk/rss.xml. A DYNAMIC endpoint: getStaticPaths emits
// the `rss` path only when at least one editorial collection is published, so
// the feed file does not exist in the build until a collection launches. It is
// separate from the Writing feed (/rss.xml).
import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';
import { isPublished, anyPublished } from '../../data/desk';

export async function getStaticPaths() {
  if (!anyPublished()) return [];
  return [{ params: { feed: 'rss' } }];
}

export async function GET(context: any) {
  const items: any[] = [];

  if (isPublished('artifacts')) {
    const entries = await getCollection(
      'artifacts',
      ({ data }: any) => !data.draft && data.pubDate
    );
    for (const e of entries) {
      items.push({
        title: e.data.title,
        description: e.data.description,
        pubDate: e.data.updatedDate ?? e.data.pubDate,
        link: `/desk/artifacts/${e.slug}/`,
      });
    }
  }

  if (isPublished('fieldNotes')) {
    const entries = await getCollection(
      'fieldNotes',
      ({ data }: any) => !data.draft && data.pubDate
    );
    for (const e of entries) {
      items.push({
        title: e.data.title,
        description: e.data.description,
        pubDate: e.data.updatedDate ?? e.data.pubDate,
        link: `/desk/field-notes/${e.slug}/`,
      });
    }
  }

  items.sort((a, b) => b.pubDate.valueOf() - a.pubDate.valueOf());

  return rss({
    title: 'Archieval Mariano — Desk',
    description: 'Editorial writing from Desk: Artifacts and Field Notes.',
    site: context.site,
    items,
  });
}
