# Homepage explorations — four directions

Status: **D · Quiet Personal Site is the selected foundation** and is now in its second iteration (information architecture, homepage composition, project imagery). A–C are kept for reference only and are no longer developed. Nothing here is approved for production.

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

## D · Quiet Personal Site — iteration 2 (selected foundation)

*Restraint over concept: a careful evolution of the current homepage.* Iteration 1
dropped the A–C metaphors and returned to the production homepage's palette, type,
rules, portrait and photography. Iteration 2 refines the information architecture,
the homepage order and the Desk imagery. Screenshots:
[desktop](quiet-desktop-full.jpg) · [mobile](quiet-mobile-full.jpg) ·
[Desk after Artifacts/Field Notes launch (synthetic fixtures)](quiet-desk-after-launch-SYNTHETIC.jpg).

### Navigation and information architecture

Primary navigation (preview header only): **Desk · Work · About · Contact.**
Writing and Services are no longer in the primary nav. Their pages and URLs are
untouched, and both are linked from the Work section and the footer directory.

| Destination | Contains | Existing URL (unchanged) |
| --- | --- | --- |
| **Desk** | Projects: software, utilities, experiments | `/desk/`, `/desk/projects/`, `/desk/{dogear,on-point,goto,tools}/` |
| | Artifacts: personal writing about objects | gated; no link until launched |
| | Field Notes: essays, reflections, observations | gated; no link until launched |
| **Work** | Case studies | `/work/`, `/work/{slug}/` |
| | Commissioned writing | `/writing/`, `/writing/{slug}/` (not moved to `/work/writing/`) |
| | Services | `/services/` |
| **About** | | `/about/` |
| **Contact** | | `/contact/` |

The hierarchy comes from section headings, contextual links and a preview-only
footer directory, not from moving routes. There are no redirects, duplicate
canonicals or route changes. RSS and sitemap output is byte-identical to `main`.
The shared production `Nav` and `Footer` components are not modified; D uses its
own header and footer.

### Homepage order

1. **Introduction:** unchanged copy (“Have you heard of AI? Not that one.”) and the
   existing portrait.
2. **Desk:** the Desk page's introduction, then a three-part directory (Projects,
   Artifacts, Field Notes), then the projects themselves (DOGEAR as lead, ON POINT,
   GOTO, and Tools as text only), then the product experiments with their published
   caveat.
3. **Away from the dashboards:** About's copy unchanged. The three photographs are
   shown uncropped at their own proportions in one quiet row, with published
   captions, so they read as photographs rather than decorative tiles. Right-click
   and drag are disabled, as on About.
4. **Work:** the homepage throughline as the lede, then three sub-sections:
   **Case studies** (three selected entries), **Commissioned writing** (the three
   featured pieces, linking out as on `/writing/`), and **Services** (the Services
   page's own introduction and its three service names).
5. **Closing:** the existing closing copy, with links to About, Contact and LinkedIn.

Commissioned writing no longer appears as a standalone top-level identity. It
sits inside Work. Field Notes is never populated with commissioned pieces, and
the collections stay separate.

### How unpublished Artifacts and Field Notes are accommodated

- The Desk directory reads the **same gate the DESK pages use**
  (`isPublished()` from `src/data/desk.ts`, imported read-only; `desk.ts` is
  unchanged).
- **While a collection is unpublished** (today): it shows only its name, a short
  plain-text description, and “Nothing published yet.” There is no link, no URL,
  no entry and no subtitle, and its collection is **not queried**. In the rendered
  preview, the only `/desk/…` links are `/desk/`, `/desk/projects/` and the four
  project pages. The gate test asserts this.
- **Once a collection launches** (the existing one-line change in `desk.ts`, with
  published entries): its name becomes a link, its subtitle appears (“As Things
  Stand” / “From the Margins”), an “Open …” link replaces the status line, and up
  to three entries (featured first, then latest by `pubDate`, the DESK homepage
  rule; drafts never) appear beneath the projects. The layout does not change.
  The footer directory adds the link as well.
- This was verified with the existing **synthetic** gate fixtures in a local
  preview build ([screenshot](quiet-desk-after-launch-SYNTHETIC.jpg)). The fixtures
  are staged only for that build and removed afterwards; none are committed. Under
  CI, the same request emits nothing.
- **Draft copy for your approval:** the two descriptions (“Personal writing about
  gadgets, objects and products.” / “Essays, reflections and observations.”) are
  paraphrased from the redesign brief, not existing site copy.

### Desk project imagery

Only existing, unmodified photographs are used. Variety comes from **framing**:
ON POINT and GOTO are cropped with CSS to the device screen, so each shows what it
does. The image files are not edited.

| Project | Asset | Presentation |
| --- | --- | --- |
| DOGEAR | `dogear-01-issue-x4-x4pro.jpg` (homepage hero) | Full physical-device photo: the issue on two readers |
| ON POINT | `onpoint-01-board.jpg` | Screen only: route, countdown, scheduled / next / last departures |
| GOTO | `goto-edition-01-story.jpg` | Screen only: edition date and top-story headline (landscape crop) |
| Tools | — | Text only |

Alt text uses the published wording where it exists (DOGEAR hero alt; ON POINT
alt from `/desk/on-point/`). The GOTO alt describes what the crop shows.

**Still missing (not fabricated):**

- No flat screenshots of any app exist in the repository; every asset is a photo
  of an e-reader. Native-resolution screen captures of the ON POINT board and route
  list, and of a GOTO edition, would read more crisply than crops.
- GOTO's most distinctive "briefing" view is the web edition
  (`goto-edition-04-phone.jpg`), but it is an angled phone photo. A straight
  capture of `goto.archievalmariano.com` would make a stronger GOTO image.
- `dogear-06-web-edition.jpg` is a browser capture, but it shows the DOGEAR web
  edition, not one of the e-ink apps.
- Artifacts and Field Notes have no imagery yet. The design does not need any
  until real entries exist.

### Accessibility checks and remaining concerns

- **Heading outline:** H1, then H2 per section, then H3 per project or
  sub-section, then H4 per case study. The Desk directory is a list, not headings,
  so projects never nest under “Field Notes”.
- **Images:** all images have alt text. Framed crops keep meaningful alt; there
  are no image-only links (titles are the links) and no empty links.
- **Contrast:** `--ink-faint` on the darker Desk band measures **4.15:1**, below
  AA for small text, so D uses `--ink-soft` there (7.1:1). The same token on cream
  is about 4.7:1. Production uses `--ink-faint` on similar backgrounds; worth
  auditing site-wide before launch.
- **Remaining concerns:**
  - The Taipei panorama's natural proportions make it narrow on desktop, so its
    caption wraps to four lines.
  - Several links share labels such as “Open …” and “All …”; they are
    distinguishable by context but not unique.
  - External writing links open in new tabs, as they do on `/writing/`.
  - The Work section is text-heavy; whether case studies need images is open.
  - “Nothing published yet.” is honest but visible to visitors before launch;
    you may prefer to hide the two reserved entries entirely until then (a
    one-line change).

### Deliberately left out of the current homepage

The “00 Introduction”-style chapter labels; the eyebrow “Digital Strategy &
Audience Growth · Philippines”; the 05 / ≈40 / 01 evidence panels; the full-width
Singapore panorama; the per-entry “Read the story” links. All of these remain on
production and can return.

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
