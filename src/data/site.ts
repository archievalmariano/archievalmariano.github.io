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
  path: '/og-services-photo.png',
  width: 1200,
  height: 630,
  alt: 'Archieval Mariano overlooking the Singapore skyline, with audience intelligence, digital strategy and growth, and content and digital operations.',
};

export const hero = {
  eyebrow: 'Digital Strategy & Audience Growth · Philippines',
  headline: 'I turn audience insight into better digital work.',
  intro:
    'Working across strategy, content, analytics, e-commerce, and digital operations to help teams understand their audiences, build better systems, and turn ideas into scalable programs.',
};

export interface ServiceGroup {
  title: string;
  need: string;
  approach: string;
  outcome: string;
}

// Editable content for the Services page.
export const services: ServiceGroup[] = [
  {
    title: 'Audience intelligence',
    need:
      'You have plenty of audience and performance data, but it lives across different platforms, reports, and teams. It is difficult to tell which information matters or what should happen next.',
    approach:
      'I identify the useful signals, define the right audiences and metrics, and turn them into reporting systems, dashboards, or audience frameworks people can actually understand.',
    outcome:
      'A clearer view of your audience and a practical way to use data in editorial, commercial, campaign, or product decisions.',
  },
  {
    title: 'Digital strategy and growth',
    need:
      'Traffic, engagement, or campaigns are moving, but the business result is unclear. Or your team sees an opportunity and does not yet know which channel, program, or experiment is worth pursuing.',
    approach:
      'I examine the audience, customer journey, channels, and existing performance to find where the real problem or opportunity sits. From there, I shape a strategy, roadmap, or pilot around it.',
    outcome:
      'Clearer priorities, practical recommendations, and a plan that can be tested instead of another presentation that disappears after the meeting.',
  },
  {
    title: 'Content and digital operations',
    need:
      'A content, commerce, or campaign idea is promising, but the process behind it is manual, inconsistent, or too dependent on individual people keeping everything together.',
    approach:
      'I help define the workflow, roles, cadence, tools, and decisions needed to turn the idea into something repeatable. This may include editorial systems, content pipelines, reporting automation, or cross-functional processes.',
    outcome:
      'A working system that is easier to run, easier to improve, and less likely to fall apart as the workload grows.',
  },
];
