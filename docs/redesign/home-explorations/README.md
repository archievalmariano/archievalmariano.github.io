# Homepage explorations — four directions

Status: **D · Quiet Personal Site is the selected foundation** and is now in its third iteration (a more restrained homepage: one featured project, lighter Work, rebalanced photography). A–C are kept for reference only and are no longer developed. Nothing here is approved for production.

Exploration 01 for repositioning archievalmariano.com from a professional portfolio
into a personal archive: professional work, independent software, experiments,
photography and writing.

The explorations are preview-only. They do not replace `src/pages/index.astro` and
they are never part of a production or CI build (see [Gate](#gate)).

| Direction | Route (preview only) | Screenshots |
| --- | --- | --- |
| A · Broadsheet | `/preview/home/broadsheet/` | [desktop](broadsheet-desktop-full.jpg) · [mobile](broadsheet-mobile-full.jpg) |
| B · Index / Ledger | `/preview/home/ledger/` | [desktop](ledger-desktop-full.jpg) · [mobile](ledger-mobile-full.jpg) |
| C · Field Notebook / Atlas | `/preview/home/atlas/` | [desktop](atlas-desktop-full.jpg) · [mobile](atlas-mobile-full.jpg) |
| **D · Quiet Personal Site** | `/preview/home/quiet/` | [desktop](quiet-desktop-full.jpg) · [mobile](quiet-mobile-full.jpg) |
| *Baseline: current production homepage* | `/` | [desktop](production-desktop-full.jpg) · [mobile](production-mobile-full.jpg) |

`/preview/home/` is a short index of the four. A dark bar at the top of every preview
page switches between directions.

## Running the previews

```bash
HOME_PREVIEW=true npm run dev
```

Then open http://localhost:4321/preview/home/. A static preview build also works:

```bash
HOME_PREVIEW=true npm run build && npm run preview
```

## Content rules followed

- All copy comes from existing published sources. That means the current homepage
  (cover, throughline, closing), About (lede, experience, captions, “I usually see
  the ending first”), the Work page (product experiments), the `work`, `writing` and
  `projects` collections, and the published ON POINT route table. Nothing is
  rewritten. Shared copy lives in `src/components/home-preview/archive.ts`.
- New text is limited to structural labels such as “Inside”, “In brief”, “Register”,
  “Plate II” and chart captions. These describe the page, not the person.
- The unpublished DESK collections (Artifacts, Field Notes) are never read, linked
  or named. Private and listing-only case studies stay unlinked, as on `/work`.
- No dates are invented. Commissioned writing has no confirmable `pubDate`, so the
  Ledger records it as **n.d.** instead of estimating.
- Atlas coordinates are the approximate public positions of the places named in
  existing captions and entries: Taipei, Hong Kong, Pasay Baywalk, Esplanade Bridge
  and Central Luzon.

## A · Broadsheet

*An editorial front page: confident type, asymmetric composition, deliberate
hierarchy.*

- **Nameplate.** “Archieval Mariano” is set across the full measure in Newsreader
  at the display optical size, between ears (discipline, coverage, edition date)
  and a double rule. The site name works as a masthead, not a logo.
- **One lead story.** “Have you heard of AI? *Not that one.*” runs over 8 of 12
  columns, with an italic deck, a byline rule, and the intro plus throughline in two
  justified columns with a drop cap. The portrait sits in the right rail, in black
  and white like a news photograph.
- **“Inside” box.** Counts per holding (7 case studies, 4 desk projects,
  2 prototypes, 15 pieces of writing, 4 photographs). This is the first sign that
  the site is an archive, not only a CV.
- **Graded secondary stories.** The three selected case studies sit on a 6/3/3
  split. The lead carries the existing “05 platforms” evidence figure as a reversed
  stat panel. The other four case studies become an “In brief” column.
- **Photograph across the page** (Singapore), with a pull quote from the throughline.
- **From the desk.** DOGEAR as feature, ON POINT and GOTO as briefs, Tools as a
  one-line “also”, and the prototypes boxed as a sidebar.
- **Back pages.** All 15 commissioned pieces in a dense, classified-style
  three-column list, with a “Pictures” column.
- **Character.** Serif-led throughout, which is the reverse of the current
  sans-heavy homepage. Coral is kept for kickers and the drop cap. Hierarchy comes
  from rules, column widths and type size rather than colour blocks.

**Strengths:** closest to the current editorial identity, but with much more authority
and density. **Risks:** a newspaper metaphor can feel nostalgic. The edition date
implies a publishing cadence the site may not keep.

## B · Index / Ledger

*A personal archive organised through indexes, catalogues, annotations and
accumulation over time.*

- **The page is a register.** Ruled ledger paper, a red double margin rule, and a
  margin column holding accession numbers (`A·000`, `WK·01`, `DK·03`, `WR·12`,
  `PH·04`) and section numerals I–V.
- **Holdings table** in the header, with a double-ruled total of 32 entries. The
  archive’s size is stated up front.
- **Preface** entry: the cover statement at display size, plus intro and
  throughline. A pinned yellow annotation card carries “Cf. experience”.
- **Accumulation chart.** Each case study is a bar across its year span
  (2019–2026), with running totals beneath. A dashed red **n.d.** column tallies
  what carries no date: 4 desk projects, 2 prototypes, 15 commissioned pieces. The
  2022–23 gap is shown honestly.
- **Ledger tables** for Work and Writing, with columns for accession, year/date,
  entry, source and annotation. The annotation column carries existing caveats,
  such as “Private case study — details intentionally withheld.”
- **Catalogue cards** for desk projects and prototypes (the prototypes are hatched
  and marked “not a launched product”), and a **contact sheet** for photographs.
- **Thumb-index tabs.** Fixed coloured tabs on the right edge, like a ledger’s cut
  tabs. On phones they become a bottom tab bar.
- **Character.** A monospace system font for accession codes, Newsreader for entries,
  Inter for metadata. The most systematic of the three, and the one that scales
  best as the archive grows.

**Strengths:** makes accumulation the subject; every new entry visibly enlarges the
site. **Risks:** reads as a record rather than a voice. The personality is in the
annotations, so they need care. Tables need the mobile “index card” treatment
(implemented) to stay usable.

## C · Field Notebook / Atlas

*Expressive and exploratory: cartography, personal documentation, and the
information-design confidence of Pinned Travel.*

- **Plate I, places in the archive.** An equirectangular plate (2° graticule,
  equator, Tropic of Cancer, compass) plots Taipei, Hong Kong, Central Luzon, the
  Pasay Baywalk and Singapore at true latitude and longitude, joined by schematic
  dashed legs. The left rail is a Pinned-style numbered checkpoint list with
  coordinates. No coastlines are drawn, and the caption says so.
- **Plate III, lines through the archive.** The archive drawn as transit lines:
  **W** (case studies in start-year order; bold stations are selected work), **D**
  (desk projects), **P** (prototypes) and **R** (writing, with publishers as
  stations and piece counts). Lines run horizontally on desktop and vertically on
  phones.
- **Plate II, ON POINT.** The seven published routes as a schematic transit
  diagram, coloured by operator (Bulacan P2P, Precious Grace, Genesis, UBE
  Express), with Clark Airport, TriNoma and NAIA T3 as interchanges. This is the
  clearest example of information design built from the site’s own data.
- **Notebook.** A dot-grid page holds the cover statement and the three selected
  case studies as field entries, with evidence figures as rubber stamps and a yellow
  margin note (“I usually see the ending first.”). Photographs are taped in beside
  it as numbered specimens with coordinates.
- **Writing waypoints** as pin cards, and a closing panel on graph paper.
- **Character.** Pinned Travel’s sky, coral, yellow and green palette mixed with the
  site’s paper and ink. Inter for system labels, Newsreader italic for the hand.

**Strengths:** the most individual direction; it ties software, travel and
photography into one visual language. **Risks:** the most art-directed, so the
hardest to keep maintainable. The regional plate only stays meaningful if more
located material is added over time.

## D · Quiet Personal Site — iteration 3 (selected foundation)

*Restraint over concept.* D keeps the production homepage's palette, Inter and
Newsreader, understated rules, hero portrait, introduction, and dark closing panel.
Iteration 2 set the information architecture. Iteration 3 makes the homepage
lighter: one featured project, a lighter Work section, and a better-balanced
photo arrangement. Screenshots: [desktop, 1440px](quiet-desktop-full.jpg) ·
[mobile, 390px](quiet-mobile-full.jpg).

### Navigation and information architecture

Primary navigation (preview header only): **Desk · Work · About · Contact.**
Writing and Services are not in the primary nav. Their pages and URLs are
untouched, and both are linked from the Work section and the footer directory.

| Destination | Contains | Existing URL (unchanged) |
| --- | --- | --- |
| **Desk** | Projects: software, utilities, and experiments | `/desk/`, `/desk/projects/`, `/desk/{dogear,on-point,goto,tools}/` |
| | Artifacts: personal writing about objects | gated; no link until launched |
| | Field Notes: essays, reflections, and observations | gated; no link until launched |
| **Work** | Case studies | `/work/`, `/work/{slug}/` |
| | Commissioned writing | `/writing/`, `/writing/{slug}/` (not moved) |
| | Services | `/services/` |
| **About** | | `/about/` |
| **Contact** | | `/contact/` |

No redirects, duplicate canonicals, or route changes. RSS and sitemap output is
byte-identical to `main`. The shared production `Nav` and `Footer` are not
modified; D uses its own header and footer.

### Homepage hierarchy

1. **Introduction:** unchanged copy and the existing portrait.
2. **Desk:** the Desk page's introduction, then the three-part directory
   (Projects, Artifacts, and Field Notes), then **one featured project**: its
   authentic photograph, name, subtitle, existing purpose line, facts, and an
   “All projects →” link to `/desk/projects/`.
3. **Away from the dashboards:** About's copy unchanged, beside the three
   photographs and their published captions.
4. **Work:** the homepage throughline as lede, then **Case studies** (two
   entries plus “All case studies →”), **Commissioned writing** (one entry plus
   “All commissioned writing →”), and **Services** (one-sentence description plus
   “How I can help →”).
5. **Closing:** the existing copy, with links to About, Contact, and LinkedIn.

Removed from the homepage, all still reachable at their existing pages: ON POINT,
GOTO, Tools, the Pinned prototypes, the third selected case study, the other
featured writing, and the list of service offerings. Nothing was removed or
rewritten on any destination page.

### Featured project: data-driven, not hardcoded

The featured project is the registry entry with `"featured": true` in
`src/content/projects/*.json`, the existing flag for “the single pinned homepage
entry”, currently DOGEAR. It falls back to the first homepage-eligible project by
`order`. Rotating it is a data change only. I verified this in a throwaway copy:
setting `featured` on ON POINT instead of DOGEAR makes ON POINT the featured
project with no code change.

Optional presentation hints are kept for ON POINT and GOTO. If either becomes the
featured project, its photograph is framed with CSS to the device screen (the
departure board, or the top story), as reviewed in iteration 2. The image files
are never modified. DOGEAR uses its existing physical-device photograph.

### Artifacts and Field Notes (still gated)

- The directory reads the same gate the DESK pages use (`isPublished()` from
  `src/data/desk.ts`, imported read-only; unchanged).
- **Unpublished (today):** name, a one-line description, and “Nothing published
  yet.” No link, no URL, no subtitle, and no entry; the collection is not queried.
- **Once launched:** the name links to the collection, its subtitle appears, and
  **one** entry (featured first, then latest by `pubDate`; never drafts) appears in
  its directory column, matching the single featured project. The layout does not
  change.
- This behaviour is exercised only inside `scripts/home-preview-gate-test.sh`,
  using the existing synthetic fixtures. No fixture content appears in committed
  screenshots or docs; the earlier synthetic screenshot has been removed.
- **Draft copy for approval:** “Personal writing about gadgets, objects, and
  products.” and “Essays, reflections, and observations.” are paraphrased from the
  brief. They now use the serial comma.

### Photography

The three photographs are never cropped. The tall Taipei panorama sits beside a
stack of the two landscapes. Each column's flex-grow equals its aspect ratio
(the stack uses the combined ratio of its two images), so the columns share one
height at their natural proportions. This works at 1440px and at 390px.
Captions stay as published. Right-click and drag remain disabled, as on About.

### Editorial style

New or revised copy uses the serial (Oxford) comma: the two draft descriptions,
the Services line (existing Services page description, which already uses it),
and these notes. Existing copy reused verbatim is unchanged, including the Desk
Projects description (“Independent applications, utilities and experiments.”).
No sitewide copy edit was made.

### Images

| Item | Asset | Presentation |
| --- | --- | --- |
| Featured project (DOGEAR) | `dogear-01-issue-x4-x4pro.jpg` | Full physical-device photograph |
| Hero | `archieval-portrait.jpg` | Unchanged |
| Photography | `about-taipei-street.jpg`, `about-baywalk-cat.jpg`, `about-esplanade-bridge.jpg` | Uncropped, natural proportions |

Still missing (not fabricated): straight screen captures of ON POINT and GOTO
(every app asset is a photo of an e-reader), and any imagery for Artifacts or
Field Notes. Neither is needed while DOGEAR is featured.

### Accessibility

- **Heading outline:** H1, then an H2 per section, H3 for the featured project
  and Work categories, and H4 for case studies. The Desk directory is a list.
- **Images:** all have alt text; no image-only links and no empty links.
- **Contrast:** muted text on the Desk band uses `--ink-soft` (7.1:1);
  `--ink-faint` measures only 4.15:1 there.
- **Remaining:**
  - Repeated link patterns (“All … →”) are distinguishable by context but not
    unique.
  - External writing links open in new tabs, as on `/writing/`.
  - “Nothing published yet.” is visible to visitors before launch. Hiding the
    two reserved columns entirely is a one-line change if you prefer.

### Deliberately left out of the current homepage

The “00 Introduction”-style chapter labels; the eyebrow “Digital Strategy &
Audience Growth · Philippines”; the 05 / ≈40 / 01 evidence panels; the full-width
Singapore panorama; and the per-entry “Read the story” links. All of these remain
on production and can return.

## Shared technical notes

- **Fonts.** The previews load Newsreader’s optical-size axis (`opsz`) instead of the
  weight-only file. Display sizes get the high-contrast display cut. This is
  preview-only; production fonts are unchanged. If a direction is chosen, adopting
  `opsz` is worth considering.
- **No analytics, no indexing.** `PreviewLayout` does not use `BaseHead`. It has no
  GA4, no canonical and no Open Graph, and sets `robots: noindex, nofollow, noarchive`.
- **No new dependencies.** Screenshots were taken with the browser already installed
  in the review environment; nothing was added to `package.json`.

## Gate

- `src/preview/gate.mjs` opens only when `HOME_PREVIEW` is affirmative (`true`, `1`,
  `yes`, `on`) **and** no CI indicator is present. Any non-empty `CI` or
  `GITHUB_ACTIONS`, including `false` or `0`, closes it. This mirrors the DESK rule
  without touching `src/data/desk.ts`.
- `astro.config.mjs` injects the route (`src/preview/HomePreviewRoute.astro`, which
  lives outside `src/pages`) only when the gate is open. A closed gate leaves it out
  of the build graph entirely, so no preview CSS, fonts or chunks reach `dist/`.
  `getStaticPaths()` re-checks the gate as a second lock, and the sitemap filter
  excludes `/preview/`.
- `scripts/home-preview-gate-test.sh` covers these states:
  - Default, non-affirmative and CI-present builds must each be byte-identical to
    the default production build, with no preview HTML, URL or markup.
  - A CI build with every flag set *and* the synthetic DESK fixtures staged must
    still emit nothing.
  - The enabled build must render all five pages (noindex, no analytics, not in
    the sitemap, homepage markup unchanged). D's Artifacts and Field Notes must be
    plain text, and `/writing/` and `/services/` must stay linked.
  - The enabled build with DESK preview and fixtures must link the launched
    collections and their published entries, never drafts.
  - The fixtures are always removed on exit.
