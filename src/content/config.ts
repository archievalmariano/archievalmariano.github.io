import { defineCollection, z } from 'astro:content';

/**
 * Work — case studies / engagements.
 * Context, Approach, and Outcome are structured frontmatter fields so every
 * entry renders in a consistent shape. Leave any field blank to have the
 * template show an explicit "To be provided" marker.
 */
const work = defineCollection({
  type: 'content',
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      year: z.string().optional(), // single year or range, e.g. "2024" or "2024–26"
      category: z.string().optional(), // e.g. "Audience Strategy & Analytics"
      companyOrClient: z.string().optional(), // employer or client (omit/anonymize if withheld)
      anonymized: z.boolean().default(false), // when true, the company name is withheld
      shortDescription: z.string(), // listing-card summary
      overview: z.string().optional(), // one-paragraph case-study lead
      role: z.string().optional(),
      // Each accepts prose (string) or a bulleted list (string[]).
      context: z.union([z.string(), z.array(z.string())]).optional(),
      approach: z.union([z.string(), z.array(z.string())]).optional(),
      outcome: z.union([z.string(), z.array(z.string())]).optional(),
      limitations: z.union([z.string(), z.array(z.string())]).optional(),
      metrics: z.array(z.string()).optional(),
      tools: z.array(z.string()).default([]),
      tags: z.array(z.string()).default([]),
      heroImage: image().optional(),
      images: z.array(image()).optional(), // optional gallery
      confidentialityNote: z.string().optional(),
      privateCaseStudy: z.boolean().default(false), // list the work without publishing its case study
      featured: z.boolean().default(false),
      order: z.number().optional(), // configurable ordering (lower = earlier)
      draft: z.boolean().default(false), // hide incomplete case studies from production
    }),
});

/**
 * Writing — published pieces and personal essays. Commissioned entries often
 * point outward via `externalURL` rather than hosting the full text here.
 */
const writing = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    displayTitle: z.string().optional(), // shorter editorial title for curated listings
    classification: z.enum(['commissioned', 'personal']),
    publisher: z.string().optional(),
    clientOrCampaign: z.string().optional(),
    format: z.string().optional(), // e.g. "Essay", "Feature", "Newsletter"
    contribution: z.string().optional(), // e.g. "Writing", "Editing", "Strategy"
    pubDate: z.coerce.date().optional(), // optional: many commissioned pieces have no reliably confirmable date
    externalURL: z.string().url().optional(),
    byline: z.enum(['bylined', 'ghostwritten', 'uncredited']).default('uncredited'),
    credit: z.string().optional(), // exact visible on-page credit, e.g. "Text by Arch Mariano"
    description: z.string(), // short description
    featured: z.boolean().default(false),
    draft: z.boolean().default(false),
  }),
});

/**
 * Projects — a metadata-only registry (no page is generated from it). It is the
 * single source for project listings on the DESK homepage and the PROJECTS
 * index; the individual project landing pages keep their bespoke `.astro`
 * implementations at /desk/{slug}/ and are not derived from these entries.
 */
const projects = defineCollection({
  type: 'data',
  schema: ({ image }) =>
    z.object({
      name: z.string(),
      subtitle: z.string().optional(),
      slug: z.string(), // landing page lives at /desk/{slug}/
      purpose: z.string(),
      facts: z.array(z.string()).default([]),
      heroImage: image().optional(),
      heroAlt: z.string().optional(),
      status: z.enum(['active', 'experiment', 'utility']).default('active'),
      order: z.number().default(100), // lower sorts earlier
      homepage: z.boolean().default(true), // eligible for the DESK homepage selection
      featured: z.boolean().default(false), // the single pinned homepage entry (optional)
      draft: z.boolean().default(false),
    }),
});

// A dated, substantive addition to the ownership narrative (repair, failure,
// sale, gift, change of opinion) — distinct from a routine editorial fix.
const ownershipUpdate = z.object({
  date: z.coerce.date(),
  status: z.string().optional(), // optional free-text label, e.g. "Repaired", "Sold"
  summary: z.string(),
  note: z.string().optional(),
});

// A routine factual/copy correction — NOT a change in the author's experience.
const correction = z.object({
  date: z.coerce.date(),
  note: z.string(),
});

/**
 * Artifacts — "As Things Stand". Long-term ownership essays. The schema is
 * deliberately restrained: only title, description and pubDate are required.
 * The ownership record (object, acquisition, updates) is optional and
 * supplements the essay rather than competing with it. `draft` defaults to true
 * so an essay is private until explicitly published.
 */
const artifacts = defineCollection({
  type: 'content',
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      subtitle: z.string().optional(),
      description: z.string(),
      pubDate: z.coerce.date(),
      updatedDate: z.coerce.date().optional(), // → dateModified
      draft: z.boolean().default(true),
      heroImage: image().optional(),
      heroAlt: z.string().optional(),
      heroOrientation: z.enum(['portrait', 'landscape', 'panorama']).optional(),
      ogImage: image().optional(), // optional per-article social image (1200×630 preferred)
      object: z
        .object({ name: z.string().optional(), category: z.string().optional() })
        .optional(),
      acquired: z.string().optional(), // free text; no exact date/price required
      acquiredContext: z.string().optional(),
      originalContext: z.string().optional(), // preserved publication context
      ownershipUpdates: z.array(ownershipUpdate).optional(),
      corrections: z.array(correction).optional(),
      tags: z.array(z.string()).default([]),
      featured: z.boolean().default(false),
    }),
});

/**
 * Field Notes — "From the Margins". Literary nonfiction, travelogues,
 * reflections, poetry, photography-led writing. Minimal required fields; no
 * rigid template. `draft` defaults to true.
 */
const fieldNotes = defineCollection({
  type: 'content',
  schema: ({ image }) =>
    z.object({
      title: z.string(),
      subtitle: z.string().optional(),
      description: z.string(),
      pubDate: z.coerce.date(),
      updatedDate: z.coerce.date().optional(),
      draft: z.boolean().default(true),
      heroImage: image().optional(),
      heroAlt: z.string().optional(),
      heroOrientation: z.enum(['portrait', 'landscape', 'panorama']).optional(),
      ogImage: image().optional(),
      format: z.string().optional(), // e.g. "Essay", "Travelogue", "Poem", "Photo essay"
      tags: z.array(z.string()).default([]),
      featured: z.boolean().default(false),
    }),
});

export const collections = { work, writing, projects, artifacts, fieldNotes };
