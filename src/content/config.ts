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

export const collections = { work, writing };
