# Homepage redesign — project closure record

**Status: COMPLETE.** Released, deployed, and verified by the owner. This is a
factual closure record, not a proposal for further homepage development.

## Release record

| Item | Value |
| --- | --- |
| Repository | `archievalmariano/archievalmariano.github.io` |
| Released commit (`main`) | `e720dab21030c02200afe5492fa045ba6f29cb4a` |
| Previous production commit | `202dab8` (“Add DOGEAR to DESK projects”) |
| Approved visual reference | `37b8416` on `redesign/home-explorations` |
| Release branch | `release/home-quiet-candidate` (identical to `main` at release) |
| Independent review | Codex: **CLEAR**, no blocking findings |
| Release method | Guarded fast-forward `202dab8..e720dab`; no merge commit, no force |
| Deployment | GitHub Pages run #40 (`41426927197`): build and deploy succeeded, 2026-11-02 10:13 UTC |
| Live smoke test | **Passed**, manually verified by the owner |
| DESK publication gates | Preserved (`src/data/desk.ts` unchanged) |
| Canonical URLs, RSS, and sitemap | Preserved (unchanged from `202dab8`) |

Pre-release verification: both remote references matched the expected
commits, and the working tree was clean. Tests ran from a clean checkout of
`e720dab` after `npm ci`. `npm run build` built 24 pages, and the CI-shaped
build was byte-identical. `scripts/desk-gate-test.sh` passed 171/171, and
`scripts/homepage-candidate-test.sh` passed 81/81. The deployed file list
matched the local build of `e720dab` by name, including all content-hashed
stylesheets. Claude's environment could not reach the live domain, so the live
smoke test is the owner's manual verification.

## 1. Design direction and why D was selected

Four directions were built as gated, preview-only routes from the site's
existing content:

- **A · Broadsheet:** an editorial front page.
- **B · Index / Ledger:** an accession-numbered register.
- **C · Field Notebook / Atlas:** places on a graticule and work as transit
  lines.
- **D · Quiet Personal Site:** a restrained evolution of the existing homepage.

A, B, and C were not approved because each took its metaphor too literally:

- A gave the owner's name masthead prominence and read like a publication about
  him.
- B imposed institutional classification and numbering.
- C used maps and transit diagrams where they did not explain the information.

**D was selected** because it is restrained and comfortable. It keeps the
existing palette, Inter and Newsreader, and editorial warmth, and it presents
the site as a personal home on the internet, not a CV, a magazine about its
owner, or an archive. D was then refined over seven iterations and frozen at
`37b8416`. A–D and their review history remain on `redesign/home-explorations`.

## 2. Information architecture

Primary navigation: **Desk · Work · About · Contact.**

| Destination | Contains | URL |
| --- | --- | --- |
| Desk | Projects; Artifacts and Field Notes (gated) | `/desk/`, `/desk/projects/`, project pages |
| Work | Case studies, Prototypes, Commissioned writing, and Services | `/work/`, `/writing/`, `/services/` |
| About | — | `/about/` |
| Contact | — | `/contact/` |

Writing and Services left the primary navigation but kept their pages and
URLs. Both are reached from the Work section of the homepage and from the
sitewide footer directory. The reorganization is navigational: no routes,
collections, or redirects changed.

## 3. Desk Projects and Work Prototypes

- **Desk › Projects:** independent, working applications and utilities (DOGEAR,
  ON POINT, GOTO, and Tools). The homepage features one project, DOGEAR, chosen
  through the projects registry's `featured` flag. The others remain on
  `/desk/projects/` and their own pages.
- **Work › Prototypes:** Pinned Shop and Pinned Travel, presented as proofs of
  concept with the existing disclosure: “These are not launched products or
  claims of measured outcomes.” They link in the same tab to `/pinned-shop/` and
  `/pinned-travel/`, with authentic screenshots. Their independent repositories
  were not modified.

## 4. Adaptive Artifacts and Field Notes (unpublished)

Desk is one row per subsection. A row **expands** (identity, description, link,
and one featured entry) only when its subsection has published content, read
through the existing gate (`isPublished`). Otherwise it stays **compact**:

- name, subtitle, and description only;
- no link or URL;
- no status notice or empty media area.

Unpublished collections are never queried. Artifacts (“As Things Stand”) and
Field Notes (“From the Margins”) remain unpublished and unlinked. When a
collection is launched through `src/data/desk.ts`, its row and the footer
directory expand without a layout change. Tests cover one, two, and three
populated subsections, and confirm that CI cannot expose gated content.

## 5. Editorial and visual decisions

- **Hero:** “Have you heard of AI? Not that one.” with the approved supporting
  line, and the original 3:2 portrait, uncropped, at a restrained size.
- **Name:** modest wordmark; no masthead.
- **Desk:** approved introduction, subtitles, and descriptions; DOGEAR shown with
  its authentic device photograph.
- **Away from the dashboards:** approved copy. Three photographs at their native
  proportions with published captions; on mobile, the Taipei panorama has its
  own centred row.
- **Work:** the approved introduction as one continuous reading column (about
  30/70 on desktop), then two case studies, Prototypes, and a final row for
  Commissioned writing and Services. Collection links follow their content.
- **Closing:** the existing dark blue panel and published copy. The footer is a
  site directory.
- **Avoided:** decorative numbering, artificial metrics, maps, and ornamental
  labels.
- **Copy:** all approved copy reproduced verbatim, with the serial comma and
  typographic apostrophes.

## 6. Review, release, and verification

Production integration was prepared on `release/home-quiet-candidate`:

- `c77c320`: homepage, shared Nav and Footer, prototype assets, and the
  candidate test suite.
- `e720dab`: review handoff and evidence.

Codex reviewed `e720dab` independently and issued **CLEAR**. The owner approved
release of that exact commit, which was fast-forwarded to `main`, deployed by
GitHub Pages run #40, and verified live by the owner. The review handoff and
evidence are in `docs/redesign/production-candidate/`.

## 7. Known nonblocking issues and deferred items

All were documented before release and accepted as nonblocking:

1. **Font variant.** Production loads standard Newsreader; the approved preview
   used the optical-size variant. Some serif lines wrap differently, most
   visibly the hero supporting line on mobile.
2. **Container width.** The homepage uses the site grid (78rem) instead of the
   preview's 76rem, to align with the shared header and footer.
3. **LinkedIn** is no longer in the header. It remains on the homepage closing
   panel, About, and Contact.
4. **No nav highlight** on `/writing/` or `/services/`, although both belong to
   Work conceptually.
5. **Pre-existing 1.6px overflow** on `/about/` at 320px, identical before
   release. The release removed a 149px navigation overflow at that width.
6. **Prototype screenshots** come from local builds of the public Pinned
   repositories (`cb9a8a3`, `1a6059a`), not live captures.
7. **Compact Desk rows** give screen-reader users no explicit “not yet
   published” cue. This follows the owner's decision against notices.
8. **Repeated link labels** (“All … →”) are clear in context but not unique.
9. **Serial-comma inconsistencies in existing pages,** left unedited:
   - `/desk/projects/`: “applications, utilities and experiments”
   - `/desk/tools/` and `tools.json`: “a calendar, a calculator and a clock”
   - `/desk/` meta description: “a calendar, calculator and clock”
   - `/desk/dogear/`: “books, literary anniversaries and discoveries”
   - `/work/` heading: “audiences, systems and digital work”
10. **Label mismatch.** `/work/` calls the Pinned section “Product experiments”
    (links open in new tabs). The homepage calls it “Prototypes” (same tab).
11. **Inner pages** keep their previous design language (chapter labels, larger
    headings). Only the shared header and footer changed there.
12. **GitHub Actions** logs a Node.js 20 deprecation warning for
    `actions/checkout@v4`, `actions/setup-node@v4`, and `actions/upload-artifact@v4`.
    The deployment is unaffected; the workflow was intentionally not modified.
13. **Test fixtures.** Both test scripts stage synthetic fixtures in
    `src/content/` during runs and remove them on exit. Do not commit while
    either script is running.

## 8. Potential future work (not started)

For later, separately approved projects only:

- **Desk destination pages:** align `/desk/` and `/desk/projects/` with the
  homepage's quieter language. Plan the launch of Artifacts and Field Notes:
  real entries, imagery, and the one-line gate change.
- **Work destination pages:**
  - align `/work/`, `/writing/`, and `/services/` with the homepage;
  - reconcile “Product experiments” with “Prototypes”;
  - consider section highlighting for Writing and Services.
- **Editorial pass:** the serial-comma items above, with owner approval.
- **Typography decision:** whether to adopt Newsreader's optical-size variant
  sitewide.
- **Assets:** live captures of the Pinned prototypes, and straight screen
  captures of ON POINT and GOTO if either becomes the featured project.
