import { defineCollection, z } from 'astro:content';

const work = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    summary: z.string(),
    role: z.string(),
    organization: z.string().optional(),
    period: z.string(),
    tags: z.array(z.string()).default([]),
    featured: z.boolean().default(false),
    order: z.number().optional(),
    draft: z.boolean().default(false),
  }),
});

const writing = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    updatedDate: z.coerce.date().optional(),
    tags: z.array(z.string()).default([]),
    canonicalURL: z.string().url().optional(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { work, writing };
