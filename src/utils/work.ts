import { getCollection, type CollectionEntry } from 'astro:content';

/**
 * A work entry is a full, clickable case study once it has narrative content.
 * Entries with only listing-level fields (title, year, category, description,
 * company, tags) are shown in listings but do not link to a detail page.
 */
export function hasCaseStudy(entry: CollectionEntry<'work'>): boolean {
  const d = entry.data;
  return Boolean(d.overview || d.context || d.role || d.approach || d.outcome || d.limitations);
}

export async function getPublicCaseStudies() {
  return (await getCollection('work', ({ data }) => !data.draft && !data.privateCaseStudy))
    .filter(hasCaseStudy)
    .sort((a, b) => (a.data.order ?? 99) - (b.data.order ?? 99));
}

export function getCaseStudySections(data: CollectionEntry<'work'>['data']) {
  return [
    { id: 'situation', heading: 'The situation', value: data.context },
    { id: 'responsibility', heading: 'What I was responsible for', value: data.role },
    { id: 'work', heading: 'What I did', value: data.approach },
    { id: 'outcome', heading: 'What became possible', value: data.outcome },
    { id: 'limitations', heading: 'What remains limited', value: data.limitations },
  ].filter((section) => section.value !== undefined);
}
