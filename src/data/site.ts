// Site-wide editable content and links, kept out of components so copy can be
// updated in one place without touching presentation.

export const siteLinks = {
  email: 'hello@archievalmariano.com',
  linkedin: 'https://www.linkedin.com/in/archievalmariano/',
  // CV destination — LinkedIn for now, or swap for a hosted PDF path like '/cv.pdf'.
  // TODO: set this to the actual CV/LinkedIn URL.
  cv: '#',
};

// GA4 Measurement ID, centralized here. Empty string disables analytics.
export const ga4Id = 'G-YQ3HPJ2GJZ';

// Default social preview image (Open Graph / Twitter). `path` is resolved to an
// absolute URL against `site` in BaseHead, so it's not hardcoded per page.
export const ogImage = {
  path: '/og.png',
  width: 1200,
  height: 630,
  alt: 'Archieval Mariano — Digital Strategy & Audience Growth, based in the Philippines.',
};

export const hero = {
  eyebrow: 'Digital Strategy & Audience Growth · Philippines',
  headline: 'I turn audience insight into better digital work.',
  intro:
    'Working across strategy, content, analytics, e-commerce, and digital operations to help teams understand their audiences, build better systems, and turn ideas into scalable programs.',
};

export interface ServiceGroup {
  title: string;
  description: string;
  work: string[];
}

// Shared by the Services page and the home Services preview (single source).
export const services: ServiceGroup[] = [
  {
    title: 'Strategy & Growth',
    description:
      'Audience development, digital growth strategy, channel planning, market and competitor analysis, and new-program development.',
    work: [
      'Growth audits',
      'Strategy roadmaps',
      'Audience plans',
      'New channel or program frameworks',
      'E-commerce acquisition planning',
    ],
  },
  {
    title: 'Audience & Performance',
    description:
      'Making audience and campaign data useful enough to inform actual decisions.',
    work: [
      'GA4 analysis',
      'Audience segmentation',
      'Performance reporting',
      'Dashboard planning',
      'Campaign analysis',
      'Measurement frameworks',
    ],
  },
  {
    title: 'Content & Digital Operations',
    description: 'Designing the systems behind repeatable digital work.',
    work: [
      'Editorial and content workflows',
      'Content pipelines',
      'Short-form program design',
      'Lifecycle communications',
      'Campaign systems',
      'Cross-functional workflow design',
    ],
  },
];
