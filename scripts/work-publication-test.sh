#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# Keep synthetic content and its build output outside the working tree.
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/portfolio-work-test.XXXXXX")"
trap 'rm -rf -- "$TEST_ROOT"' EXIT
cp -R "$ROOT"/{src,public,node_modules,astro.config.mjs,package.json,tsconfig.json} "$TEST_ROOT/"
cd "$TEST_ROOT"

cat > src/content/work/work-private-narrative-fixture.md <<'EOF'
---
title: Private narrative regression listing
shortDescription: This summary is intentionally public in the test build.
privateCaseStudy: true
draft: false
order: 3.5
overview: WORK_PRIVATE_NARRATIVE_MARKER overview
context: WORK_PRIVATE_NARRATIVE_MARKER context
role: WORK_PRIVATE_NARRATIVE_MARKER responsibility
approach: WORK_PRIVATE_NARRATIVE_MARKER approach
outcome: WORK_PRIVATE_NARRATIVE_MARKER outcome
limitations: WORK_PRIVATE_NARRATIVE_MARKER limitations
metrics:
  - WORK_PRIVATE_NARRATIVE_MARKER evidence
confidentialityNote: WORK_PRIVATE_NARRATIVE_MARKER confidentiality
---

WORK_PRIVATE_NARRATIVE_MARKER body
EOF

env -u DESK_PREVIEW -u DESK_PREVIEW_BUILD npm run build > build.log 2>&1 || {
  cat build.log
  exit 1
}

node --input-type=module <<'JS'
import assert from 'node:assert/strict';
import { existsSync, readdirSync, readFileSync } from 'node:fs';

const publicSlugs = [
  'digital-intelligence-dashboard',
  'audience-intelligence-system',
  'social-acquisition-retention',
  'short-form-commerce-program',
  'branded-content-campaigns',
  'evergreen-seo-pilot',
];
const privateSlugs = ['private-content-operations-engine', 'work-private-narrative-fixture'];
const read = (file) => readFileSync(file, 'utf8');
const workLinks = (html) => [...html.matchAll(/href="\/work\/([^"/]+)\/?"/g)].map((match) => match[1]);

const listing = read('dist/work/index.html');
assert.match(listing, /Private narrative regression listing/);
assert.deepEqual(workLinks(listing), publicSlugs, 'Public Work links and order');

for (const slug of privateSlugs) {
  assert.ok(!existsSync(`dist/work/${slug}`), `Private route generated: ${slug}`);
}
const routeSlugs = readdirSync('dist/work', { withFileTypes: true })
  .filter((entry) => entry.isDirectory())
  .map((entry) => entry.name)
  .sort();
assert.deepEqual(routeSlugs, [...publicSlugs].sort(), 'Exactly six public Work routes');

for (const [index, slug] of publicSlugs.entries()) {
  const page = read(`dist/work/${slug}/index.html`);
  const adjacent = page.match(/<nav\b[^>]*aria-label="More work"[^>]*>([\s\S]*?)<\/nav>/);
  assert.ok(adjacent, `Adjacent navigation for ${slug}`);
  assert.deepEqual(workLinks(adjacent[1]), [publicSlugs[index - 1], publicSlugs[index + 1]].filter(Boolean), slug);
}

for (const file of readdirSync('dist', { recursive: true }).filter((name) => /\.(html|xml)$/.test(name))) {
  const html = read(`dist/${file}`);
  assert.ok(!html.includes('WORK_PRIVATE_NARRATIVE_MARKER'), `Private narrative leaked into ${file}`);
  for (const slug of privateSlugs) {
    assert.ok(!html.includes(`/work/${slug}`), `Private route referenced by ${file}: ${slug}`);
  }
}

console.log('PASS: private narrative stays unpublished, six public cases and adjacent links remain in order.');
JS
