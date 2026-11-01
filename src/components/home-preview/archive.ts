// Shared, read-only view of the EXISTING site content used by the homepage
// explorations. Nothing here is new editorial material: every title, sentence,
// caption and fact is drawn from the published collections or copied verbatim
// from the current homepage, About page and Work page. Unpublished DESK
// collections (Artifacts, Field Notes) are deliberately never read here.
import type { ImageMetadata } from 'astro';
import { getCollection, type CollectionEntry } from 'astro:content';
import { hero, siteLinks } from '../../data/site';
import { hasCaseStudy } from '../../utils/work';

import portrait from '../../assets/photos/archieval-portrait.jpg';
import singapore from '../../assets/photos/archieval-singapore.jpg';
import taipei from '../../assets/photos/about-taipei-street.jpg';
import baywalkCat from '../../assets/photos/about-baywalk-cat.jpg';
import esplanade from '../../assets/photos/about-esplanade-bridge.jpg';

export { hero, siteLinks };

// ── Copy carried over verbatim from src/pages/index.astro ──────────────────
export const cover = {
  headline: 'Have you heard of AI? Not that one.',
  statement:
    'I work with AI. Audience intelligence, that is. I turn insight into better digital work.',
  intro:
    'Across strategy, content, analytics, e-commerce, and digital operations, I help teams understand their audiences, build useful systems, and turn ideas into scalable programs.',
};

export const throughline = {
  title: 'The useful work often happens between the disciplines.',
  paragraphs: [
    'I started in digital publishing as a writer and editor. The questions eventually became larger: who are we trying to reach, why does something perform, and what kind of system would make the work repeatable?',
    'That path now runs through audience intelligence, content strategy, analytics, e-commerce and digital operations. The medium changes. The interest in making complicated work clearer does not.',
  ],
};

export const workIntro = {
  title: 'Selected stories about turning information into something people can use.',
  aside:
    'Data alone isn’t enough. It needs to be actionable, too. These selected projects span audience intelligence, content strategy, and digital growth.',
};

export const writingIntro = {
  title: 'Some of my writing from before I was consumed by dashboards and moving lines and graphs.',
  aside:
    'Commissioned editorial and branded work for publications and clients, including pieces that ran without a byline.',
};

export const closing = {
  title: 'What happened IRL could not possibly fit in a two-page CV.',
  body:
    'The longer version includes editorial work, branded campaigns, audience systems, product experiments, and the operational details that make ideas survive contact with actual work.',
};

// Evidence figures already shown on the current homepage, keyed by work slug.
export const workEvidence: Record<string, { stat: string; label: string; marks: string[] }> = {
  'digital-intelligence-dashboard': {
    stat: '05',
    label: 'source-labeled intelligence platforms',
    marks: ['GA4', 'Similarweb', 'Semrush', 'Chartbeat', 'Google Trends'],
  },
  'audience-intelligence-system': {
    stat: '≈40',
    label: 'targetable audience segments',
    marks: ['Automotive', 'Online shoppers', 'Gamers', 'Beauty', 'Entrepreneurs'],
  },
  'social-acquisition-retention': {
    stat: '01',
    label: 'connected growth loop',
    marks: ['Social', 'Marketplace', 'Owned channel'],
  },
};

// ── Copy carried over verbatim from src/pages/about.astro ──────────────────
export const about = {
  lede:
    'I used to call myself the bored storyteller. The name still fits. I remain restless, curious, and interested in the stories people, places, and seemingly ordinary things have to tell.',
  heart: 'The heart of it has always been writing.',
  ending: 'I usually see the ending first.',
  photographer: 'Pretends to be a photographer and a good writer.',
  travel:
    'I move more slowly now, chase fewer attractions, and leave more room to notice what is actually there.',
  experience: ['GMA New Media Inc.', 'SM Investments Corporation', 'Summit Media', 'Independent consulting'],
  experienceNote: 'More than a decade across digital work.',
};

// ── Product experiments, as listed on src/pages/work/index.astro ───────────
export const experiments = [
  {
    title: 'Pinned Shop',
    label: 'Commerce prototype',
    description:
      'A concept storefront for enamel pins and small collectibles, exploring how voice, collections, saving, cart, and checkout can make a fictional brand feel complete.',
    href: 'https://archievalmariano.com/pinned-shop/',
  },
  {
    title: 'Pinned Travel',
    label: 'Travel check-in prototype',
    description:
      'A private trip check-in concept built around routes, check-in windows, and sharing the latest plan with people you trust.',
    href: 'https://archievalmariano.com/pinned-travel/',
  },
];

// ── Photographs from the personal archive (captions/alt as published) ──────
export interface Photo {
  key: string;
  src: ImageMetadata;
  alt: string;
  caption: string;
  place: string;
  // Approximate public coordinates of the place named in the caption. Used
  // only by the Atlas exploration to position a marker.
  lat: number;
  lon: number;
}

export const photos: Photo[] = [
  {
    key: 'singapore',
    src: singapore,
    alt: 'Archieval Mariano seen from behind, looking toward the Singapore skyline',
    caption: 'Personal archive · Singapore',
    place: 'Singapore',
    lat: 1.283,
    lon: 103.86,
  },
  {
    key: 'esplanade',
    src: esplanade,
    alt: 'A brightly lit convenience store framed by the dark underside of Esplanade Bridge in Singapore',
    caption: 'Beneath Esplanade Bridge in Singapore',
    place: 'Esplanade Bridge, Singapore',
    lat: 1.29,
    lon: 103.853,
  },
  {
    key: 'taipei',
    src: taipei,
    alt: "A vertical view along Chang'an West Road in Taipei, framed by buildings and road markings",
    caption: 'A very vertical panorama somewhere in Taipei',
    place: 'Taipei',
    lat: 25.05,
    lon: 121.517,
  },
  {
    key: 'baywalk',
    src: baywalkCat,
    alt: 'A black-and-white cat walking beside Manila Bay on a bright Sunday morning',
    caption: 'Sunday morning along the Pasay Baywalk',
    place: 'Pasay Baywalk, Manila Bay',
    lat: 14.54,
    lon: 120.982,
  },
];

export const portraitPhoto = {
  src: portrait,
  alt: 'Archieval Mariano seated at a table, resting his face on one hand',
};

// ── Collections ────────────────────────────────────────────────────────────
export async function loadArchive() {
  const work = (await getCollection('work', ({ data }) => !data.draft)).sort(
    (a, b) => (a.data.order ?? 99) - (b.data.order ?? 99)
  );
  const featuredWork = work.filter((e) => e.data.featured);
  const otherWork = work.filter((e) => !e.data.featured);

  // Same ordering as /writing (filename prefix).
  const writing = (await getCollection('writing', ({ data }) => !data.draft)).sort((a, b) =>
    a.slug < b.slug ? -1 : 1
  );
  const featuredWriting = writing.filter((e) => e.data.featured);

  const projects = (await getCollection('projects', ({ data }) => !data.draft)).sort(
    (a, b) => a.data.order - b.data.order
  );

  return { work, featuredWork, otherWork, writing, featuredWriting, projects };
}

// Helpers shared by the variants.
export const workHref = (slug: string) => `/work/${slug}`;
export const writingHref = (e: { slug: string; data: { externalURL?: string } }) =>
  e.data.externalURL ?? `/writing/${e.slug}`;
export const isExternal = (e: { data: { externalURL?: string } }) => Boolean(e.data.externalURL);
export const writingTitle = (e: { data: { displayTitle?: string; title: string } }) =>
  e.data.displayTitle ?? e.data.title;

// A work entry links to its case study only when one is published (the same
// rule WorkCard uses: listing-only and private case studies are not linked).
export const workIsLinked = (e: CollectionEntry<'work'>) =>
  hasCaseStudy(e) && !e.data.privateCaseStudy;

// "2024–26" → [2024, 2026]; "2026" → [2026, 2026].
export function yearSpan(year?: string): [number, number] | null {
  if (!year) return null;
  const m = year.match(/(\d{4})(?:\s*[–-]\s*(\d{2,4}))?/);
  if (!m) return null;
  const start = Number(m[1]);
  let end = start;
  if (m[2]) end = m[2].length === 2 ? Number(String(start).slice(0, 2) + m[2]) : Number(m[2]);
  return [start, end];
}
