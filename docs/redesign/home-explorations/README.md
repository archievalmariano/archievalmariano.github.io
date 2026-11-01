# Homepage explorations — four directions

Status: A–C reviewed and not approved (metaphors read too literally); D added in response. Nothing here is approved for production.

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

## D · Quiet Personal Site

*Restraint over concept: a careful evolution of the current homepage.*

Review of A–C found that each took its metaphor too literally. Broadsheet made
the site read like a publication about its owner. Ledger over-classified it.
Atlas used maps and transit diagrams where they didn't explain anything. D drops
the metaphor and starts again from the production homepage.

**What stays from production:** the paper and ink palette, Inter for headings,
Newsreader for reading text, hairline rules, the coral dot beside the name, the
same cover copy in the same order, the warm photography, and the dark blue
closing band.

**What changes:**

- **The name is modest.** It is a small wordmark in a plain header, the same
  size as today. The “Digital strategy · Audience systems” descriptor and the
  uppercase, letter-spaced nav are gone; nav links are sentence case.
- **The cover is conversational.** The headline drops from about 6.5rem to about
  4rem. The portrait shrinks to about 20rem and loses the yellow offset block and
  ink caption bar. The two calls to action become text links.
- **Projects come straight after the introduction.** The Desk section uses the
  Desk page’s own introduction. DOGEAR leads with its device photograph, ON POINT
  and GOTO follow as smaller entries, and Tools is a single line. The two Pinned
  prototypes sit beneath, with the Work page’s own caveat that they are not
  launched products.
- **Writing is a reading list.** The homepage’s heading and aside sit beside the
  three featured pieces, set in the serif with their published descriptions.
- **Personal interests have a place on the homepage.** “Away from the
  dashboards” brings About’s own copy (“Pretends to be a photographer and a good
  writer”, the Instagram and travel paragraphs) next to the three photographs it
  describes, with the published captions.
- **Professional work is complete but plainer.** The throughline is the
  section’s heading and text. The three selected case studies follow as plain
  entries with year, category, title, description and organisation.
- **Each content type gets its own composition:** device photos with text for
  projects, a typographic list for writing, a small gallery for photographs, and
  a two-column essay-and-list for work. There are no chapter numbers, evidence
  stat panels, coloured case-study blocks, maps or decorative labels.

**Deliberately left out of D** (all still on production and elsewhere on the
site; listed so nothing disappears silently):

- the “00 Introduction”-style chapter labels;
- the eyebrow “Digital Strategy & Audience Growth · Philippines”;
- the case-study evidence panels (05 / ≈40 / 01 and their marks);
- the full-width Singapore panorama;
- the per-entry “Read the story” links, since titles are the links.

Any of these can come back if you want them.

**Small changes outside the existing copy:** the Desk heading uses the page name
“Desk”. Link labels such as “Everything on the desk →” and “More about me →” are
functional only. Section order puts Desk, Writing and personal interests before
Work; the cover copy still opens with the professional statement, so the work
stays visible from the top.

**Open questions for review:** whether Work should move above Writing; whether
Services belongs in the main nav of a personal site; and whether the Desk band
(the existing `--paper-raised` tone) is enough emphasis.

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
- `scripts/home-preview-gate-test.sh` checks the default, non-affirmative and
  CI-present states (each must be byte-identical to the default production build,
  with no preview HTML, URL or markup), plus the enabled state (five pages render,
  noindex, no analytics, not in the sitemap, homepage markup unchanged).
