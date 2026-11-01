#!/usr/bin/env bash
#
# Homepage-exploration preview gate test.
#
# Builds the site in several environment states and asserts that the gated
# /preview/home/** explorations are emitted ONLY for a deliberate local opt-in
# (HOME_PREVIEW=true with no CI indicator), and that the production homepage is
# identical either way. Uses only astro + shell — no new dependency.
#
# States:
#   P    production default (no flag)                    → previews absent
#   OFF  HOME_PREVIEW set to a non-affirmative value     → previews absent
#   CI   CI / GITHUB_ACTIONS PRESENT with ANY value,     → previews absent
#        even with HOME_PREVIEW=true
#   ON   HOME_PREVIEW=true, no CI indicator              → all five pages render,
#                                                          noindex, no analytics,
#                                                          not in the sitemap
#   FINAL production build                               → previews absent

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0
LOG="${TMPDIR:-/tmp}/home_preview_build.log"
REF="${TMPDIR:-/tmp}/home_preview_ref_dist"

ok()  { PASS=$((PASS+1)); printf '   \033[32mPASS\033[0m %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '   \033[31mFAIL\033[0m %s\n' "$1"; }

assert_exist()  { if [ -e "$1" ]; then ok "exists: $1"; else bad "MISSING: $1"; fi; }
assert_absent() { if [ -e "$1" ]; then bad "SHOULD BE ABSENT: $1"; else ok "absent: $1"; fi; }
assert_grep()   { if grep -rqF -- "$2" "$1" 2>/dev/null; then ok "contains '$2': $1"; else bad "MISSING '$2' in $1"; fi; }
# Count non-overlapping occurrences of a fixed string in one file.
assert_count() { # file, string, expected
  local n; n=$(grep -oF -- "$2" "$1" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" = "$3" ]; then ok "count('$2') = $3: $1"; else bad "count('$2') = $n, expected $3: $1"; fi
}
assert_nogrep() { if grep -rqF -- "$2" "$1" 2>/dev/null; then bad "SHOULD NOT contain '$2': $1"; else ok "absent '$2' in $1"; fi; }

# No preview output, URL, or preview-only markup anywhere in dist/ — and the
# whole build is byte-identical to the production-default reference (so no
# preview CSS, font or chunk can leak in without a page).
assert_no_preview() {
  assert_absent dist/preview
  if [ -d "$REF" ]; then
    if diff -rq "$REF" dist >/dev/null 2>&1; then ok "dist/ byte-identical to production default"; else bad "dist/ differs from production default"; diff -rq "$REF" dist | head -5; fi
  fi
  assert_nogrep dist "/preview/home"
  assert_nogrep dist "Homepage preview"
  assert_nogrep dist "bs-mast"      # Broadsheet-only class
  assert_nogrep dist "lg-holdings"  # Ledger-only class
  assert_nogrep dist "at-plate"     # Atlas-only class
  assert_nogrep dist "qs-intro"     # Quiet-only class
  assert_nogrep dist "prototype-mobile"   # preview-only Pinned screenshots
}

build() { # $1 = label, rest = env assignments
  local label="$1"; shift
  echo ""; echo "── building state: $label (env: ${*:-none}) ──"
  rm -rf dist
  # Start from a clean slate: no ambient CI / GITHUB_ACTIONS / HOME_PREVIEW.
  if env -u CI -u GITHUB_ACTIONS -u HOME_PREVIEW "$@" npm run build >"$LOG" 2>&1; then
    echo "   build ok"
  else
    bad "BUILD FAILED ($label) — see $LOG"; tail -20 "$LOG"
  fi
}

# Synthetic DESK fixtures (the same files desk-gate-test.sh uses), staged only
# for the states that need them and always removed on exit.
AF="src/content/artifacts"; FN="src/content/fieldNotes"; FIX="test/fixtures/desk"
unstage() {
  rm -f "$AF/gate-published.mdx" "$AF/gate-draft.mdx" "$FN/gate-published.mdx" "$FN/gate-draft.mdx"
}
stage() {
  cp "$FIX/artifacts-published.mdx" "$AF/gate-published.mdx"
  cp "$FIX/artifacts-draft.mdx" "$AF/gate-draft.mdx"
  cp "$FIX/field-note-published.mdx" "$FN/gate-published.mdx"
  cp "$FIX/field-note-draft.mdx" "$FN/gate-draft.mdx"
}
trap unstage EXIT

# ── P: production default ───────────────────────────────────────────────────
rm -rf "$REF"
build "P production-default"
assert_exist dist/index.html
assert_no_preview
cp -R dist "$REF"
cp dist/index.html "${TMPDIR:-/tmp}/home_index_default.html"

# ── OFF: non-affirmative values never enable previews ───────────────────────
for spec in "HOME_PREVIEW=false" "HOME_PREVIEW=0" "HOME_PREVIEW=" "HOME_PREVIEW=maybe"; do
  build "OFF [$spec]" "$spec"
  assert_no_preview
done

# ── CI: presence of any CI indicator blocks the opt-in ──────────────────────
for spec in "CI=true" "CI=1" "CI=false" "CI=0" "CI=unexpected" \
            "GITHUB_ACTIONS=true" "GITHUB_ACTIONS=false" "GITHUB_ACTIONS=0"; do
  build "CI [$spec]" $spec HOME_PREVIEW=true
  assert_no_preview
done
build "CI [CI='  ']" "CI=  " HOME_PREVIEW=true
assert_no_preview
# The exact GitHub Pages runner shape: both indicators set.
build "CI [CI=true GITHUB_ACTIONS=true]" CI=true GITHUB_ACTIONS=true HOME_PREVIEW=true
assert_no_preview

# Everything requested at once under CI, with fixtures present: still nothing.
stage
build "CI [all flags + DESK fixtures]" CI=true GITHUB_ACTIONS=true HOME_PREVIEW=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_no_preview
assert_absent dist/desk/artifacts
assert_absent dist/desk/field-notes
assert_nogrep dist "SYNTHETIC FIXTURE"
unstage

# ── ON: deliberate local preview renders ────────────────────────────────────
build "ON local preview" HOME_PREVIEW=true
for p in "" broadsheet/ ledger/ atlas/ quiet/; do
  f="dist/preview/home/${p}index.html"
  assert_exist "$f"
  assert_grep  "$f" 'name="robots" content="noindex, nofollow, noarchive"'
  assert_nogrep "$f" "googletagmanager"
  assert_nogrep "$f" 'rel="canonical"'
done
assert_grep dist/preview/home/broadsheet/index.html "bs-mast"
assert_grep dist/preview/home/broadsheet/index.html "Have you heard of AI?"
assert_grep dist/preview/home/ledger/index.html "lg-holdings"
assert_grep dist/preview/home/ledger/index.html "WK·01"
assert_grep dist/preview/home/atlas/index.html "at-plate"
assert_grep dist/preview/home/atlas/index.html "Balagtas ↔ TriNoma"
assert_grep dist/preview/home/quiet/index.html "qs-intro"
assert_grep dist/preview/home/quiet/index.html "Away from the dashboards"
assert_grep dist/preview/home/quiet/index.html "The bored storyteller pretending to be a photographer and a good writer."
# D's Desk directory reserves Artifacts / Field Notes as text only.
Q=dist/preview/home/quiet/index.html
# Approved copy (iteration 5), reproduced exactly. Apostrophes are ’ (U+2019).
for line in \
  "Have you heard of AI? Not that one." \
  "I work with AI. Audience intelligence, that is. Turning insight into better digital work." \
  "Things from my digital desk that I’ve decided to share. Some can be useful, definitely specific, and occasionally unnecessary." \
  "Works in Progress" \
  "Independent applications, utilities, and experiments." \
  "As Things Stand" \
  "Notes on objects I’ve lived with as they turn from purchases into artifacts (and sometimes back)." \
  "From the Margins" \
  "Thoughts that have managed to escape from my numerous draft folders." \
  "Away from the dashboards" \
  "The bored storyteller pretending to be a photographer and a good writer." \
  "That is how I describe myself on Instagram, where I put photographs and the occasional poem or piece of prose. It captures my discomfort with calling myself a photographer, or even a good writer, despite spending years taking photographs and writing." \
  "I’ve been told I’m an amazing conversationalist. I choose to interpret that as being an acquired taste." \
  "The heart of it has always been writing." \
  "When I write, I often know the ending before I’ve written the opening. Sometimes it’s the final line, sometimes a kicker, sometimes a quote. The interesting part is figuring out how to get there." \
  "I approach other work much the same way. I start with an outcome in mind and work backward through the decisions needed to reach it." \
  "Of course, the result still has to survive contact with actual work. It has to make sense to the people using it, respect the limits they work within, and remain useful long after the presentation ends."; do
  assert_grep "$Q" "$line"
done
# Superseded copy is gone from D.
assert_nogrep "$Q" "Across strategy, content, analytics"
assert_nogrep "$Q" "Some are useful, definitely specific, and occasionally unnecessary."
assert_nogrep "$Q" "In my twenties"
# State 1 — only Projects published: one featured row, two compact rows, no
# status notices, and no links or entries for the gated collections.
assert_count  "$Q" 'qs-row--featured' 1
assert_count  "$Q" 'qs-row--compact' 2
assert_nogrep "$Q" "Nothing published yet."
assert_nogrep "$Q" "SYNTHETIC"                  # no fixture content outside tests
# Desk features ONE project (the registry's `featured` entry); the others stay
# on their own pages and are not listed on the homepage.
assert_grep   "$Q" 'href="/desk/dogear/"'
assert_nogrep "$Q" 'href="/desk/on-point/"'
assert_nogrep "$Q" 'href="/desk/goto/"'
assert_nogrep "$Q" 'href="/desk/tools/"'
# Prototypes live under Work (not Desk), link to the existing paths, and are
# framed as proofs of concept.
assert_grep   "$Q" 'id="qs-protos-title"'
assert_grep   "$Q" 'href="/pinned-shop/"'
assert_grep   "$Q" 'href="/pinned-travel/"'
assert_grep   "$Q" "These are not launched products or claims of measured outcomes."
if node -e '
  const h = require("fs").readFileSync(process.argv[1], "utf8");
  const work = h.indexOf("id=\"qs-work\""), shop = h.indexOf("href=\"/pinned-shop/\"");
  process.exit(work > 0 && shop > work ? 0 : 1);
' "$Q"; then ok "Pinned prototypes appear inside the Work section"; else bad "Pinned prototypes are not inside Work"; fi
# Prototype links open in the current tab (same domain).
assert_nogrep "$Q" 'href="/pinned-shop/" target='
assert_nogrep "$Q" 'href="/pinned-travel/" target='
# "All case studies" follows both featured case studies.
if node -e '
  const h = require("fs").readFileSync(process.argv[1], "utf8");
  const a = h.indexOf("/work/digital-intelligence-dashboard"), b = h.indexOf("/work/audience-intelligence-system");
  const more = h.indexOf("All case studies");
  process.exit(a > 0 && b > 0 && more > Math.max(a, b) ? 0 : 1);
' "$Q"; then ok "All case studies link follows both case studies"; else bad "All case studies link precedes a case study"; fi
# Work: two case studies; Commissioned writing and Services as description +
# link only (no individual article featured).
assert_grep   "$Q" 'href="/work/digital-intelligence-dashboard"'
assert_grep   "$Q" 'href="/work/audience-intelligence-system"'
assert_nogrep "$Q" 'href="/work/social-acquisition-retention"'
assert_nogrep "$Q" "esquiremag.ph"
assert_nogrep "$Q" 'href="/writing/0'
# D's primary navigation is Desk · Work · About · Contact; Writing and
# Services stay reachable at their existing URLs.
assert_grep "$Q" 'href="/writing/"'
assert_grep "$Q" 'href="/services/"'
for sm in dist/sitemap-0.xml dist/sitemap-index.xml; do
  [ -f "$sm" ] && assert_nogrep "$sm" "/preview/"
done
# Unpublished DESK collections stay out of the previews.
assert_nogrep dist/preview "/desk/artifacts"
assert_nogrep dist/preview "/desk/field-notes"
# The homepage markup is unchanged by the preview build. (Only CSS delivery may
# differ: Vite re-splits shared stylesheets, and components reused by a preview
# — e.g. Footer — can have their CSS inlined. A preview build is never deployed;
# production builds are compared byte-for-byte above.)
strip_css() {
  sed 's/></>\n</g' "$1" | grep -v 'rel="stylesheet"' |
    awk '/^<style>/{skip=1} !skip{print} /<\/style>$/{skip=0}'
}
if diff -q <(strip_css dist/index.html) <(strip_css "${TMPDIR:-/tmp}/home_index_default.html") >/dev/null; then
  ok "homepage markup identical with and without HOME_PREVIEW (CSS delivery excluded)"
else
  bad "homepage markup differs when HOME_PREVIEW=true"
fi

# ── State 2 — Projects + Artifacts: Artifacts expands, Field Notes stays ─────
#    compact and unlinked.
stage
build "ON + DESK artifacts only" HOME_PREVIEW=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts
Q=dist/preview/home/quiet/index.html
assert_count  "$Q" 'qs-row--featured' 2
assert_count  "$Q" 'qs-row--compact' 1
assert_grep   "$Q" 'href="/desk/artifacts/"'
assert_grep   "$Q" 'href="/desk/artifacts/gate-published/"'
assert_nogrep "$Q" '/desk/field-notes'
assert_nogrep "$Q" "gate-draft"
unstage

# ── State 3 — all three populated: every row expands, no redesign needed ────
stage
build "ON + DESK all collections" HOME_PREVIEW=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
Q=dist/preview/home/quiet/index.html
assert_count  "$Q" 'qs-row--featured' 3
assert_count  "$Q" 'qs-row--compact' 0
assert_grep   "$Q" 'href="/desk/artifacts/"'
assert_grep   "$Q" 'href="/desk/field-notes/"'
assert_grep   "$Q" 'href="/desk/artifacts/gate-published/"'
assert_grep   "$Q" 'href="/desk/field-notes/gate-published/"'
assert_nogrep "$Q" "gate-draft"                 # drafts never surface
assert_nogrep "$Q" "Nothing published yet."
unstage

# ── FINAL: production build ─────────────────────────────────────────────────
build "FINAL production"
assert_no_preview
assert_nogrep dist "SYNTHETIC FIXTURE"

echo ""
echo "════════════════════════════════════════════"
echo "  home-preview gate:  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════════════════════════"
rm -rf "$REF"
unstage
[ "$FAIL" -eq 0 ]
