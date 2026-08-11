import type { CollectionEntry } from 'astro:content';

/**
 * A work entry is a full, clickable case study once it has narrative content.
 * Entries with only listing-level fields (title, year, category, description,
 * company, tags) are shown in listings but do not link to a detail page.
 */
export function hasCaseStudy(entry: CollectionEntry<'work'>): boolean {
  const d = entry.data;
  return Boolean(d.overview || d.context || d.role || d.approach || d.outcome);
}
