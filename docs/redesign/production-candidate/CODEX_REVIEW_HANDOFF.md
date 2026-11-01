# Codex review handoff — homepage production candidate

**Status: CANDIDATE ONLY. Not approved, not merged, not deployed.**
Production release requires (1) an independent Codex review that issues
**CLEAR**, then (2) explicit owner approval. Claude's own tests and audits below
do **not** replace that review.

## 1. Identifiers

| Item | Value |
| --- | --- |
| Repository | `archievalmariano/archievalmariano.github.io` |
| Base (verified `origin/main`) | `202dab8` “Add DOGEAR to DESK projects” |
| Approved design reference | `redesign/home-explorations` @ `37b8416`, `src/components/home-preview/Quiet.astro` (exploration D · Quiet Personal Site, owner-approved and frozen) |
| Candidate branch | `release/home-quiet-candidate` |
| Candidate implementation commit | `c77c320` “Integrate approved homepage design (production candidate)” |
| Handoff / evidence commit | the commit that adds this file, the direct child of `c77c320` (documentation and screenshots only) |
| Compare | `https://github.com/archievalmariano/archievalmariano.github.io/compare/main...release/home-quiet-candidate` |

No pull request was opened, nothing was pushed to `main`, the deployment
workflow was not touched or triggered, and no repository settings or secrets
were changed. `.github/workflows/deploy.yml` deploys only on a push to `main` or
a manual dispatch.

## 2. Files added, modified, or removed (`202dab8..c77c320`)

| File | Change | Purpose |
| --- | --- | --- |
| `src/pages/index.astro` | **modified** (rewritten body and styles) | Approved homepage sections, copy, and styles. `<BaseLayout>` title and description are unchanged. |
| `src/components/Nav.astro` | **modified** | Shared header → approved Desk · Work · About · Contact navigation. |
| `src/components/Footer.astro` | **modified** | Shared footer → approved directory footer (gate-aware Desk links). |
| `src/assets/prototypes/pinned-shop-mobile.jpg` | **added** | Pinned Shop screenshot (byte-identical to the reviewed preview asset; SHA-256 `c6e96400…6e51`). |
| `src/assets/prototypes/pinned-travel-mobile.jpg` | **added** | Pinned Travel screenshot (byte-identical to the reviewed preview asset; SHA-256 `67262f2e…003f`). |
| `scripts/homepage-candidate-test.sh` | **added** | Candidate test suite (section 6). |

Removed: nothing. **Unchanged:** `package.json`, `package-lock.json`,
`.github/`, `astro.config.mjs`, `src/data/**` (including the DESK gate
`src/data/desk.ts`), `src/content/**`, `src/layouts/**`, `BaseHead.astro`,
every other page, `scripts/desk-gate-test.sh`, `test/`.

The preview infrastructure (explorations A–D, `/preview/home/**`, the
`HOME_PREVIEW` gate, `PreviewLayout`) is **not** part of this candidate. It
remains on `redesign/home-explorations` for reference.

## 3. Exact changes made during integration

The full line diff from the approved component to the integrated homepage is in
[`preview-to-production.diff`](preview-to-production.diff). Its substantive
content:

1. **Header and footer moved into the shared components.** The preview drew its
   own header and footer inside the component. They now live in `Nav.astro` and
   `Footer.astro` (via `BaseLayout`), so every page that uses `BaseLayout` gets
   them. The preview's wordmark link to `/preview/home/quiet/` becomes `/`, and
   the production `aria-label="Archieval Mariano — home"` is kept.
2. **Data sources.** The preview imported shared preview data (`archive.ts`). The
   homepage now defines the same values locally, copied verbatim from the
   approved component and existing pages: closing copy, the case-study and
   writing descriptions, photo captions and alt text (from `/about/`), the
   portrait alt text, and the prototype titles, labels, and descriptions (from
   `/work/`). The approved `copy` object, the Desk-row logic, the DOGEAR framing
   hints, and the photo-grid maths are carried over unchanged.
3. **Container width (deliberate visual deviation).** `.qs-wrap` changes from
   `min(100%, 76rem)` to the site grid (`max-width: var(--wrap)` = 78rem, the
   same as `.wrap`), so the homepage aligns with the shared header and footer,
   which every page already used. Effect: at viewports ≥ 1248px the content is
   16px wider per side. There is no change below that width.
4. **Case-study link guard (defensive correctness).** A featured case-study
   title links to `/work/{slug}` only if `hasCaseStudy(e) && !privateCaseStudy`,
   the same rule `/work/` and `WorkCard` use, so a future listing-only featured
   entry cannot produce a 404. Both current entries have case studies, so the
   output is unchanged.
5. **Analytics hook preserved.** The homepage LinkedIn link gains
   `data-ga-event="linkedin_click"`, which used to be on the header LinkedIn link
   that the approved navigation drops. The footer email keeps
   `data-ga-event="email_click"`. `BaseHead` (GA4) is unchanged.
6. **Navigation details.** `Nav.astro` keeps `aria-current="page"` (the same
   prefix rule as before) and shows the current section with an accent underline
   on inner pages. The homepage has no current item, as in the approved preview.
   The old client-side horizontal-scroll script was removed, because four items
   fit at 320px.
7. **Footer directory.** Desk shows Projects plus
   `publishedCollections().map(...)`, so Artifacts and Field Notes appear only
   once the existing gate publishes them. Work shows Case studies (`/work/`),
   Commissioned writing (`/writing/`), and Services (`/services/`).

## 4. Design-fidelity requirements (frozen at `37b8416`)

Each item: requirement → candidate status.

- Original **uncropped 3:2 portrait** (2000×1333, no `object-fit`) → met
  (`width="2000" height="1333"`; rendered ratio matches natural ratio).
- **Approved hero copy** and links (“Explore my work”, “A little about me”); no
  “Across strategy…” paragraph → met (asserted).
- **Desk · Work · About · Contact** navigation → met on all 21 pages that use
  `BaseLayout` (asserted). The 3 `/goto/` redirect pages are byte-identical to
  `main`.
- **Adaptive Desk:** Projects expanded with DOGEAR (registry `featured`);
  Artifacts and Field Notes compact, unlinked, with approved subtitles and
  descriptions → met (asserted in all three publication states).
- **Photography** arrangement and captions (desktop tall + stack aligned; mobile
  centred Taipei row) → met (screenshots).
- **Work introduction** (30/70, one continuous column) → met.
- **Two case studies**, then “All case studies →” after them → met (asserted).
- **Prototypes** under Work, authentic screenshots, disclosure, same-tab links to
  `/pinned-shop/` and `/pinned-travel/` → met (asserted).
- **Commissioned writing** and **Services** as description plus link → met.
- **Dark closing panel** and **directory footer** → met.
- **Approved copy verbatim** (Oxford comma, typographic ’) → met: 19 of 19 lines
  verified in `dist/index.html`.

**Known visual differences from the approved preview** (see section 9 for
decisions needed):

- (a) The content grid is 78rem instead of 76rem (item 3 in section 3).
- (b) **Font file:** the preview loaded Newsreader's optical-size variable font
  (`opsz.css`). Production `BaseHead` loads the standard variable file, which was
  left unchanged as the minimum change. Serif text sets slightly wider, so some
  lines wrap differently. Most visible on mobile: the hero supporting line wraps
  to 3 lines instead of 2. See
  [`compare-mobile-approved-vs-candidate.jpg`](compare-mobile-approved-vs-candidate.jpg).
- (c) The preview-only switcher bar is absent (expected).

## 5. Publication-gate and deployment-safety requirements

| Requirement | Evidence |
| --- | --- |
| DESK gate code unchanged | `src/data/desk.ts` unchanged vs `main` |
| Artifacts / Field Notes unpublished and unlinked in production | No `/desk/artifacts`, `/desk/field-notes`, or `desk/rss` anywhere in `dist/`; `dist/desk/` holds only `dogear goto index.html on-point projects tools` |
| Unpublished collections not queried by the homepage | `isPublished()` is checked before any `getCollection` for those keys |
| No synthetic fixture leak | `SYNTHETIC` absent from `dist/` in the default, CI, and final builds; fixtures staged only inside test scripts and removed by `trap` (`src/content/{artifacts,fieldNotes}` contain only `_README.md` afterwards) |
| CI cannot expose gated content | A CI build with `CI=true GITHUB_ACTIONS=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes` **and fixtures staged** produces no gated output (asserted) |
| Gated content expands only when legitimately published | With a local DESK preview build (no CI), rows expand: one, two, or three as collections publish; drafts never appear (asserted) |
| URLs unchanged | Identical set of 24 HTML pages plus XML, TXT, SVG, and PNG vs `main` |
| RSS and sitemap unchanged | `rss.xml`, `sitemap-index.xml`, `sitemap-0.xml`, `robots.txt` byte-identical to `main` |
| Redirects functional | `/goto/`, `/goto/install/`, `/goto/install/x4-pro/` byte-identical to `main` |
| SEO metadata unchanged | `<head>` (title, description, canonical, OG, Twitter, JSON-LD, GA) identical to `main` on all 24 pages, comparing everything except stylesheet links and module scripts |
| Deployment untouched | `.github/` unchanged; nothing pushed to `main`; no PR opened |
| No new dependencies | `package.json` and `package-lock.json` unchanged |

## 6. Test commands and results (run on `c77c320`)

```bash
npm ci
npm run build                            # 24 pages; Complete
bash scripts/desk-gate-test.sh           # PASS=171 FAIL=0
bash scripts/homepage-candidate-test.sh  # PASS=81  FAIL=0
```

`homepage-candidate-test.sh` covers these states:

- **P (production default):**
  - approved copy;
  - Desk 1 expanded / 2 compact;
  - only the DOGEAR project linked;
  - Work ordering and links;
  - same-tab prototype links;
  - the full portrait;
  - nav = Desk·Work·About·Contact and a complete footer directory on every
    `BaseLayout` page.
- **CI:** all flags plus fixtures → nothing gated.
- **S2:** Artifacts only → 2 expanded / 1 compact, published fixture linked,
  draft absent, footer adds Artifacts.
- **S3:** both collections → 3 expanded.
- **FINAL:** no leak.

One earlier run of the new script reported 6 failures. The cause was a test bug:
case-study pages have an article-level `<footer>` before the site footer, and the
check matched the first `<footer>`. It now targets `footer.site-foot`. The pages
were correct throughout.

**Browser checks on the generated production build** (Chromium via Playwright,
served from `dist/` under the real paths):

- **Overflow sweep:** 14 pages × 9 widths (1440, 1280, 1024, 820, 768, 600, 390,
  360, 320). The only overflow is 1.6px on `/about/` at 320px. This is
  **pre-existing**: identical on `main`, caused by the About page's own cover
  elements. On `main` that page overflows by 149px at 320px because of the old
  navigation; the candidate removes that.
- **Headings:** exactly one H1 per page; no skipped levels on any of the 14
  pages.
- **Images and links:** no image without `alt`; no empty links.
- **Keyboard:** Tab order on the homepage is skip link → wordmark → Desk → Work →
  About → Contact → “Explore my work” → “A little about me” → Desk heading link.
  The skip link becomes visible on focus (`top: 12px` after its 0.2s
  transition). The focus outline is 2px solid.
- **Navigation state:** `aria-current` marks Desk on `/desk/**`, Work on
  `/work/**`, About, and Contact. No item is marked on `/`, `/writing/`,
  `/services/`, or 404.
- **Runtime:** no page errors.

## 7. Screenshots and generated-output evidence (this directory)

- **Homepage:** `candidate-home-desktop-full.jpg` (1440px) and
  `candidate-home-mobile-full.jpg` (390px), plus `-fold` variants.
- **Approved preview vs candidate:** `compare-desktop-approved-vs-candidate.jpg`
  and `compare-mobile-approved-vs-candidate.jpg` (left: approved `37b8416`;
  right: candidate).
- **Inner pages with the shared header:** `candidate-{work,desk,writing,services,about,contact}-{desktop,mobile}-fold.jpg`.
- **Shared footer:** `candidate-footer-desktop.jpg`.
- **Porting diff:** `preview-to-production.diff`.
- **Prototype screenshot provenance:** recorded on the design branch in
  `docs/redesign/home-explorations/README.md` (iteration 6). In short:
  - **Sources:** local builds of the public `pinned-shop` @ `cb9a8a3` and
    `pinned-travel` @ `1a6059a`, cloned read-only (nothing pushed to either).
  - **Capture:** 390×844 at 2×, cropped to the top 740 CSS px.
  - **Fidelity:** the crop sits above Pinned Travel's map, whose OpenStreetMap
    tiles were unreachable in the build environment. Nothing was drawn or edited.

## 8. Review checklist by category

**Correctness**
- Desk-row logic, featured-project selection, and editorial-entry selection
  match `37b8416` (diff section). `getCollection` is not called for unpublished
  keys.
- The `hasCaseStudy` guard (section 3, item 4).
- Footer `publishedCollections()` behaviour in published and unpublished states.
- `aria-current` prefix logic (for example, does `/workshop` exist? It does not
  today).

**Accessibility**
- Heading outline, link names (for example “Open prototype: Pinned Shop”), the
  skip link, focus visibility, and alt text.
- Compact Desk rows are plain text with no status notice (owner decision). Assess
  whether screen-reader users need more context.

**Security**
- No new scripts, `set:html`, or external hosts. Of the target-blank links, only
  LinkedIn remains, with `rel="noopener"`. No dependency changes.

**Publication safety**
- Verify the section 5 table independently, especially the CI-plus-fixtures
  case and the absence of gated paths in HTML, RSS, and sitemap.
- Confirm `homepage-candidate-test.sh` cannot leave fixtures behind
  (`trap unstage EXIT`, plus an explicit `unstage` at the end).

**Visual fidelity**
- Compare the candidate screenshots with the approved `37b8416` captures.
- Assess differences (a)–(c) in section 4.

## 9. Known limitations, unresolved concerns, and deviations

1. **Font variant (needs owner decision).** Production uses standard Newsreader;
   the approved preview used the optical-size variant. To match the preview
   exactly, change `BaseHead.astro`'s two Newsreader imports to
   `@fontsource-variable/newsreader/opsz.css` and `.../opsz-italic.css`. That is
   a sitewide typographic change, so it was not made without approval.
2. **Container width 76 → 78rem (needs owner confirmation).** This keeps the
   homepage aligned with the shared header and footer. Reverting is a one-line
   change, but would offset the homepage content by 16px from the header at wide
   viewports.
3. **LinkedIn no longer in the header sitewide.** This follows the approved
   four-item navigation. LinkedIn remains on the homepage closing panel, `/about/`,
   and `/contact/`.
4. **No nav highlight on `/writing/` and `/services/`.** These belong to Work
   conceptually, but the existing exact-prefix rule was kept rather than adding
   section mapping.
5. **Inner pages keep their previous design language** (chapter labels, larger
   headings). Only the shared header and footer changed there, by design.
6. **Pre-existing 1.6px overflow on `/about/` at 320px** (identical on `main`;
   not addressed, out of scope).
7. **Prototype screenshots come from local builds**, not the live site. The
   owner may replace them with live captures at 780×1480.
8. **Serial-comma inconsistencies in existing pages** (listed on the design
   branch README) are unedited by design.
9. **The test suite stages fixtures inside `src/content/`** (the same pattern as
   `desk-gate-test.sh`). Never commit while either script is running.

## 10. Reproduce

```bash
git fetch origin release/home-quiet-candidate
git switch release/home-quiet-candidate
npm ci
npm run build
bash scripts/desk-gate-test.sh
bash scripts/homepage-candidate-test.sh
npx astro preview   # then open http://localhost:4321/
```
