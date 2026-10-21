// Central DESK configuration.
//
// `PUBLISHED` is the PRODUCTION source of truth: it is the only thing that can
// turn an editorial collection on in the GitHub Pages build. Both are false
// until a collection is explicitly launched (a reviewed one-line change).
//
// A local PREVIEW override (DESK_PREVIEW) can enable collections for private
// development only, and it is FAIL-CLOSED: the override is honoured only in the
// dev server (`astro dev`), or in a build that explicitly opts in with
// DESK_PREVIEW_BUILD=true. A production `astro build` (the GitHub Pages
// workflow) is neither, so no environment value — accidental or otherwise —
// can expose an unpublished collection in production. See docs: the production
// deploy is a pure function of committed source.

export type DeskCollectionKey = 'artifacts' | 'fieldNotes';

export interface DeskCollectionMeta {
  key: DeskCollectionKey;
  label: string; // navigation / breadcrumb label
  subtitle: string; // editorial subtitle (shown on collection landing pages only)
  slug: string; // URL segment beneath /desk/
}

// Order here is the order collections appear in DESK-local navigation.
export const deskCollections: DeskCollectionMeta[] = [
  { key: 'artifacts', label: 'Artifacts', subtitle: 'As Things Stand', slug: 'artifacts' },
  { key: 'fieldNotes', label: 'Field Notes', subtitle: 'From the Margins', slug: 'field-notes' },
];

// PRODUCTION TRUTH. Do not flip to true except to launch a collection.
const PUBLISHED: Record<DeskCollectionKey, boolean> = {
  artifacts: false,
  fieldNotes: false,
};

// DESK_PREVIEW tokens (URL-style) → collection key.
const PREVIEW_TOKENS: Record<string, DeskCollectionKey> = {
  artifacts: 'artifacts',
  'field-notes': 'fieldNotes',
};

// Node's process.env is only present server-side / at build; guard so this
// module is safe if ever imported where it is absent.
function env(name: string): string | undefined {
  return typeof process !== 'undefined' && process.env ? process.env[name] : undefined;
}

// A truthy environment flag: true / 1 / yes / on, case-insensitively. Anything
// else (unset, empty, false, 0, no) is falsy.
function isTruthy(value: string | undefined): boolean {
  if (!value) return false;
  return ['true', '1', 'yes', 'on'].includes(value.trim().toLowerCase());
}

// Running under continuous integration. The production GitHub Pages deploy sets
// both CI and GITHUB_ACTIONS; accepting ANY truthy spelling (true/1/yes/on,
// any case) means the deploy can never be coaxed into a preview build by a
// differently-spelled flag.
function inCI(): boolean {
  return isTruthy(env('CI')) || isTruthy(env('GITHUB_ACTIONS'));
}

// Preview overrides are honoured ONLY in the dev server, or in a local build
// that explicitly opts in — and NEVER in CI / the GitHub Pages workflow. The
// production deploy is therefore a pure function of committed source: no
// environment value (DESK_PREVIEW, DESK_PREVIEW_BUILD, or any other), accidental
// or otherwise, can expose an unpublished collection in production.
function previewAllowed(): boolean {
  // Hard block in CI / the production deploy environment: short-circuits every
  // override below, so GitHub Actions can never enable an unpublished collection.
  if (inCI()) return false;
  if (import.meta.env.DEV) return true; // astro dev
  return isTruthy(env('DESK_PREVIEW_BUILD')); // explicit local build opt-in
}

function previewSet(): Set<DeskCollectionKey> {
  const out = new Set<DeskCollectionKey>();
  if (!previewAllowed()) return out; // fail-closed: production build gets nothing
  const raw = env('DESK_PREVIEW') ?? '';
  for (const token of raw.split(',').map((s) => s.trim()).filter(Boolean)) {
    const key = PREVIEW_TOKENS[token];
    if (key) out.add(key);
  }
  return out;
}

const preview = previewSet();

export function isPublished(key: DeskCollectionKey): boolean {
  return PUBLISHED[key] || preview.has(key);
}

export function anyPublished(): boolean {
  return deskCollections.some((c) => isPublished(c.key));
}

// Launched collections, in display order — drives DESK-local navigation and
// the DESK homepage so an unpublished collection is absent from markup, not
// merely hidden.
export function publishedCollections(): DeskCollectionMeta[] {
  return deskCollections.filter((c) => isPublished(c.key));
}

export function collectionMeta(key: DeskCollectionKey): DeskCollectionMeta {
  const meta = deskCollections.find((c) => c.key === key);
  if (!meta) throw new Error(`Unknown DESK collection: ${key}`);
  return meta;
}
