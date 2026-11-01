// Homepage redesign explorations — the directions shown under
// /preview/home/. The gate itself lives in src/preview/gate.mjs.
export { homePreviewEnabled } from '../preview/gate.mjs';

export interface HomeVariant {
  slug: string;
  number: string;
  name: string;
  summary: string;
}

export const homeVariants: HomeVariant[] = [
  {
    slug: 'broadsheet',
    number: 'A',
    name: 'Broadsheet',
    summary:
      'An editorial front page. One lead story, a deliberate hierarchy of secondary stories, and a dense back page of everything else.',
  },
  {
    slug: 'ledger',
    number: 'B',
    name: 'Index / Ledger',
    summary:
      'The homepage as a register. Every item in the archive gets an accession number, a year (or an honest n.d.), and a line in the ledger.',
  },
  {
    slug: 'atlas',
    number: 'C',
    name: 'Field Notebook / Atlas',
    summary:
      'An exploratory plate. Places from the archive plotted on a graticule, the work drawn as transit lines, photographs pinned into a notebook.',
  },
  {
    slug: 'quiet',
    number: 'D',
    name: 'Quiet Personal Site',
    summary:
      'Approved direction. A restrained evolution of the current homepage, with approved copy, the full portrait, Desk rows that expand as sections publish, personal photography, and a single-column Work introduction.',
  },
];
