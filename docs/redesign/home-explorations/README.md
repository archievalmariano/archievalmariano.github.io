# Homepage explorations — four directions

Status: **D · Quiet Personal Site is the selected foundation** and is now in its fifth iteration (approved copy, the full uncropped portrait, and a single-column Work introduction). A–C are kept for reference only and are no longer developed. Nothing here is approved for production.

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

## D · Quiet Personal Site — iteration 5 (selected foundation)

*Approved direction.* Iteration 5 applies the author-approved copy, restores the full
portrait, and adjusts the layout around the new text. Screenshots:
[desktop, 1440px](quiet-desktop-full.jpg) · [mobile, 390px](quiet-mobile-full.jpg).

### Iteration 5 changes

- **Approved copy:** all section copy is the author-approved text, kept in a single
  `copy` object at the top of `Quiet.astro` (not in the shared `archive.ts`, so A–C
  are unchanged). It is reproduced exactly; the only character difference is that
  apostrophes are set as typographic ’ to match the rest of the site. The gate test
  asserts every approved line verbatim, and asserts that the superseded copy (hero
  intro paragraph, old Projects description, travel paragraph) is gone.
- **Hero:** the headline, then “I work with AI. Audience intelligence, that is.
  Turning insight into better digital work.”, then the links “Explore my work” and
  “A little about me”, in that order. The earlier “Across strategy…” paragraph is
  not part of the approved hero and was removed from D only (production is
  unchanged).
- **Portrait:** the **entire 2000×1333 photograph** at its native 3:2. No
  `object-fit`, no forced ratio, and no crop; the rendered ratio matches the
  natural ratio at 1440px and 390px. It sits in a column of up to 28rem
  (about 448×299px at desktop), bottom-aligned with the links, so the headline
  stays primary. On mobile it follows the text at full width.
- **Desk:** the approved introduction, subtitles, and descriptions. The subtitles
  “As Things Stand” and “From the Margins” are now shown on the compact rows as
  well. Rows, gating, and the DOGEAR feature are unchanged.
- **Away from the dashboards:** the approved subheading and two paragraphs, with
  the same three photographs, captions, and gallery layout.
- **Work introduction:** see below.

### Work introduction: reading order

The three approved paragraphs are one argument, so they stay together in **one
column** with a reading measure of about 36rem, never split across columns. The
grid uses the same two columns as the Desk introduction: the heading “Work” and
the subheading “The heart of it has always been writing.” on the left, and the
continuous body column on the right. Source order is heading, subheading,
paragraphs 1 to 3, then the categories. That is the reading order for screen
readers and on mobile, where everything stacks in that order. The categories row
(Case studies, Commissioned writing, and Services) follows unchanged.

### Navigation and information architecture (unchanged)

| Destination | Contains | Existing URL (unchanged) |
| --- | --- | --- |
| **Desk** | Projects: software, utilities, and experiments | `/desk/`, `/desk/projects/`, `/desk/{dogear,on-point,goto,tools}/` |
| | Artifacts | gated; no link until launched |
| | Field Notes | gated; no link until launched |
| **Work** | Case studies | `/work/`, `/work/{slug}/` |
| | Commissioned writing | `/writing/`, `/writing/{slug}/` (not moved) |
| | Services | `/services/` |
| **About** / **Contact** | | `/about/`, `/contact/` |

No redirects, duplicate canonicals, or route changes. The shared production `Nav`
and `Footer` are not modified.

### Desk: one row per subsection, adapting to publication state

The directory-plus-feature arrangement is replaced by a stack of rows divided by
hairline rules. Each row aligns on the same three columns: **identity** (name, and
subtitle once published), **about** (description, and a link once published), and
**featured**.

- **Expanded row:** shown when the subsection has published content. It fills all
  three columns. Projects currently shows DOGEAR: its existing device photograph
  (11rem), title, subtitle, purpose line, facts, and “Open DOGEAR →”, beside
  “All projects →”.
- **Compact row:** shown when there is nothing published. It shows the name and
  the one-line description on a single line, with no link, URL, subtitle, status
  notice, or empty media area. The unpublished collection is never queried.

| Published | Rows |
| --- | --- |
| Projects only (today) | Projects expanded; Artifacts and Field Notes compact |
| Projects + one collection | That collection expands with one featured entry (featured first, then latest by `pubDate`; never drafts). The other stays compact. |
| All three | All three rows expanded; no structural change |

Expansion uses the existing gate (`isPublished()` in `src/data/desk.ts`, read
only); the gate is unchanged. An editorial entry shows its own hero image if it
has one, otherwise it is text only, with a serif title. The featured project is
still data-driven: the registry's `featured` flag, with `order` as fallback.
ON POINT, GOTO, Tools, and the Pinned prototypes are reached through
`/desk/projects/` and their own pages.

All three states are checked by `scripts/home-preview-gate-test.sh`, using the
existing synthetic fixtures inside the test only. No fixture content is committed
to these docs.

### Photography and captions

The tall Taipei panorama sits beside the two stacked landscapes, all uncropped.
The tall column's width is now solved from the photos' proportions **and** the
one caption row inside the stack:

`W_tall = ((W − gap) · Σ(h/w)_stack + caption row) / (h/w_tall + Σ(h/w)_stack)`

The panorama therefore ends exactly level with the lower landscape, and the two
bottom captions share a line. A CSS subgrid aligns the rows while each figure
keeps its own image and caption. At 1440px the Taipei caption wraps to two
balanced lines instead of four. On mobile, the panorama sits at 11rem with its
caption beside it, aligned to the bottom, and the two landscapes follow at full
width. The section's top and bottom spacing is unchanged.

### Work categories

- **Categories:** one row of three columns under Work, separated by hairlines:
  - **Case studies** (wider column): two selected entries plus “All case
    studies →”.
  - **Commissioned writing:** the existing `/writing/` description plus “All
    commissioned writing →”. No article is featured.
  - **Services:** the existing one-sentence Services description plus “How I can
    help →”.
- No destination page or URL changed.

### Editorial style

The homepage copy is the approved text and uses the serial comma. Existing
published prose on other pages was not changed. Inconsistencies
noticed for later editorial review (not edited):

- `/desk/projects/` (intro and meta description): “applications, utilities and
  experiments”. D now uses the approved “applications, utilities, and
  experiments.”
- `/desk/tools/` and `src/content/projects/tools.json`: “a calendar, a calculator
  and a clock”.
- `/desk/` meta description: “a calendar, calculator and clock”.
- `/desk/dogear/`: “books, literary anniversaries and discoveries” (twice).
- `/work/` heading: “audiences, systems and digital work”.
- Production homepage throughline: “analytics, e-commerce and digital
  operations”, while the cover intro on the same page uses “e-commerce, and
  digital operations”. (D no longer uses the throughline.)

### Images

| Item | Asset | Presentation |
| --- | --- | --- |
| Hero | `archieval-portrait.jpg` | Entire photograph, native 3:2, uncropped |
| Featured project (DOGEAR) | `dogear-01-issue-x4-x4pro.jpg` | Device photograph, uncropped |
| Photography | `about-taipei-street.jpg`, `about-baywalk-cat.jpg`, `about-esplanade-bridge.jpg` | Uncropped, natural proportions |

Still missing (not fabricated): straight screen captures of ON POINT and GOTO, which
are only needed if either becomes the featured project (CSS screen framing exists
as a fallback), and any imagery for Artifacts or Field Notes, which is not needed
because launched entries render as text.

### Accessibility and responsive notes

- **Heading outline:** H1; then H2 per section; H3 for Projects, Artifacts, Field
  Notes, and the three Work categories; H4 for DOGEAR and case studies.
- **Images:** all have alt text. There are no image-only links and no empty
  links; the featured link names its target (“Open DOGEAR”, or “Read” plus a
  hidden title).
- **Contrast:** muted text on the Desk band uses `--ink-soft` (7.1:1). Case-study
  meta on cream measures 4.66:1.
- **Remaining:**
  - Compact rows are plain text. Sighted users read the absence of a link, but
    nothing tells screen-reader users the category has no content yet. That is
    deliberate, since you asked for no notices. The approved subtitles now give
    these rows a little more presence.
  - The photo alignment assumes the upper caption fits on one line at desktop
    widths. If it wraps, the panorama ends one line short (no cropping or
    overlap).
  - Between 36rem and 64rem the Desk rows use two columns, with featured content
    under the description.
  - Repeated “All … →” labels are clear in context but not unique.

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
