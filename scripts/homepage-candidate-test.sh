#!/usr/bin/env bash
#
# Production-candidate checks for the "Quiet Personal Site" homepage and the
# shared navigation/footer. Complements scripts/desk-gate-test.sh, which tests
# the closed Artifacts gate separately. Inspects the generated dist/ directly.
# Uses only astro + shell + node — no new dependency.
#
# States:
#   P     production default → Projects, Artifacts and Field Notes expanded
#   CI    CI + every preview flag + draft fixtures → same public content as P
#   FINAL production default, fixtures removed → no fixture leak
#
# Synthetic fixtures are the existing test/fixtures/desk files; they are
# staged only for the states that need them and always removed on exit.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0
LOG="${TMPDIR:-/tmp}/homepage_candidate_build.log"
AF="src/content/artifacts"; FN="src/content/fieldNotes"; FIX="test/fixtures/desk"
H=dist/index.html
FN_ROUTE="/desk/field-notes/make-no-mistakes-adds-the-monkey/"
ARTIFACT_ROUTE="/desk/artifacts/my-otp-camera/"

ok()  { PASS=$((PASS+1)); printf '   \033[32mPASS\033[0m %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '   \033[31mFAIL\033[0m %s\n' "$1"; }
assert_exist()  { if [ -e "$1" ]; then ok "exists: $1"; else bad "MISSING: $1"; fi; }
assert_absent() { if [ -e "$1" ]; then bad "SHOULD BE ABSENT: $1"; else ok "absent: $1"; fi; }
assert_grep()   { if grep -rqF -- "$2" "$1" 2>/dev/null; then ok "contains '$2': $1"; else bad "MISSING '$2' in $1"; fi; }
assert_nogrep() { if grep -rqF -- "$2" "$1" 2>/dev/null; then bad "SHOULD NOT contain '$2': $1"; else ok "absent '$2' in $1"; fi; }
assert_count()  { local n; n=$(grep -oF -- "$2" "$1" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" = "$3" ]; then ok "count('$2') = $3: $1"; else bad "count('$2') = $n, expected $3: $1"; fi; }

unstage() { rm -f "$AF/gate-draft.mdx" "$FN/gate-draft.mdx"; }
stage() {
  cp "$FIX/artifacts-draft.mdx" "$AF/gate-draft.mdx"
  cp "$FIX/field-note-draft.mdx" "$FN/gate-draft.mdx"
}
trap unstage EXIT

build() { # $1 = label, rest = env assignments
  local label="$1"; shift
  echo ""; echo "── building state: $label (env: ${*:-none}) ──"
  rm -rf dist
  if env -u CI -u GITHUB_ACTIONS -u DESK_PREVIEW -u DESK_PREVIEW_BUILD "$@" npm run build >"$LOG" 2>&1; then
    echo "   build ok"
  else
    bad "BUILD FAILED ($label) — see $LOG"; tail -20 "$LOG"
  fi
}

assert_field_notes() {
  assert_exist "dist${FN_ROUTE}index.html"
  assert_exist dist/desk/field-notes/index.html
  assert_exist dist/desk/rss.xml
  assert_grep "$H" "href=\"$FN_ROUTE\""
  assert_nogrep dist/desk/field-notes "Draft Field Note Fixture"
  assert_absent dist/desk/field-notes/gate-draft
}

assert_production() {
  assert_field_notes
  assert_exist "dist${ARTIFACT_ROUTE}index.html"
  assert_exist dist/desk/artifacts/index.html
  assert_grep "$H" "href=\"$ARTIFACT_ROUTE\""
  assert_grep "$H" "IMG_0716."
  if grep -Eq '<a href="/desk/artifacts/"[^>]*>All Artifacts' "$H"; then
    ok 'Homepage All Artifacts links to the collection index'
  else
    bad 'Homepage All Artifacts link missing or incorrect'
  fi
  assert_grep dist/desk/index.html "IMG_0716."
  assert_grep dist/desk/artifacts/index.html "IMG_0716."
  assert_grep dist/desk/artifacts/index.html 'datetime="2026-11-22"'
  assert_grep dist/desk/artifacts/index.html '>November 2026</time>'
  assert_grep dist/desk/artifacts/index.html "Notes on objects I’ve lived with as they turn from purchases into artifacts (and sometimes back)."
  assert_grep dist/about/index.html 'href="/desk/artifacts/"'
  assert_count "$H" 'qs-row--featured' 3
  assert_count "$H" 'qs-row--compact' 0
  assert_absent dist/desk/artifacts/gate-draft
  assert_nogrep dist "gate-draft"
  assert_nogrep dist "SYNTHETIC"
}

# ── P: production default ───────────────────────────────────────────────────
build "P production-default"
assert_exist "$H"
assert_production

# Approved copy, reproduced exactly (apostrophes are ’, U+2019).
for line in \
  "Have you heard of AI? Not that one." \
  "I work with AI. Audience intelligence, that is. Turning insight into better digital work." \
  "Things from my digital desk that I’ve decided to share. Some can be useful, definitely specific, and occasionally unnecessary." \
  "Independent applications, utilities, and experiments." \
  "Notes on objects I’ve lived with as they turn from purchases into artifacts (and sometimes back)." \
  "Thoughts that have managed to escape from my numerous draft folders." \
  "The bored storyteller pretending to be a photographer and a good writer." \
  "I’ve been told I’m an amazing conversationalist. I choose to interpret that as being an acquired taste." \
  "The heart of it has always been writing." \
  "Of course, the result still has to survive contact with actual work. It has to make sense to the people using it, respect the limits they work within, and remain useful long after the presentation ends." \
  "These are not launched products or claims of measured outcomes."; do
  assert_grep "$H" "$line"
done
assert_nogrep "$H" "Across strategy, content, analytics"   # superseded hero paragraph

# Projects: DOGEAR comes first and both entries use the same feature class.
for p in goto tools; do assert_nogrep "$H" "href=\"/desk/$p/\""; done
if node -e '
  const html = require("fs").readFileSync(process.argv[1], "utf8");
  const projects = html.match(/<section[^>]+aria-label="Projects"[^>]*>([\s\S]*?)<\/section>/)?.[1] ?? "";
  const features = [...projects.matchAll(/<article class="([^"]*)"[^>]*>([\s\S]*?)<\/article>/g)];
  process.exit(features.length === 2 &&
    features[0][1] === "qs-feature" &&
    features[0][2].includes(`href="/desk/dogear/"`) &&
    features[1][1] === features[0][1] &&
    features[1][2].includes(`href="/desk/on-point/"`) &&
    features[1][2].includes("onpoint-06-countdown") ? 0 : 1);
' "$H"; then ok "Projects shows DOGEAR then ON POINT with matching feature markup"; else bad "Projects feature order, image, or hierarchy incorrect"; fi

# Work: two case studies, link after them; prototypes in Work, same tab.
assert_grep   "$H" 'href="/work/digital-intelligence-dashboard/"'
assert_grep   "$H" 'href="/work/audience-intelligence-system/"'
assert_nogrep "$H" 'href="/work/social-acquisition-retention"'
assert_grep   "$H" 'href="/pinned-shop/"'
assert_grep   "$H" 'href="/pinned-travel/"'
assert_nogrep "$H" 'href="/pinned-shop/" target='
assert_nogrep "$H" 'href="/pinned-travel/" target='
if node -e '
  const h = require("fs").readFileSync(process.argv[1], "utf8");
  const a = h.indexOf("/work/digital-intelligence-dashboard"), b = h.indexOf("/work/audience-intelligence-system");
  const more = h.indexOf("All case studies"), work = h.indexOf("id=\"qs-work\""), shop = h.indexOf("href=\"/pinned-shop/\"");
  process.exit(a > 0 && b > 0 && more > Math.max(a, b) && shop > work ? 0 : 1);
' "$H"; then ok "case-study link follows both entries; prototypes sit inside Work"; else bad "Work ordering incorrect"; fi

# Hero portrait: the whole 2000×1333 source (native 3:2).
assert_grep "$H" 'width="2000" height="1333"'

# Shared chrome on every page that uses BaseLayout (not the /goto/ redirects).
for f in $(find dist -name '*.html' ! -path 'dist/goto/*' | sort); do
  if node -e '
    const h = require("fs").readFileSync(process.argv[1], "utf8");
    const nav = (h.match(/<nav aria-label="Primary"[^>]*>([\s\S]*?)<\/nav>/) || [])[1] || "";
    const hrefs = [...nav.matchAll(/href="([^"]+)"/g)].map(m => m[1]).join(",");
    const foot = (h.match(/<footer class="site-foot"[\s\S]*?<\/footer>/) || [""])[0];
    const need = ["/desk/projects/", "/work/", "/writing/", "/services/", "/about/", "/contact/", "mailto:"];
    process.exit(hrefs === "/desk/,/work/,/about/,/contact/" && need.every(n => foot.includes(n)) ? 0 : 1);
  ' "$f"; then ok "nav = Desk·Work·About·Contact; footer directory complete: $f"; else bad "nav/footer incorrect: $f"; fi
done
# The /goto/ redirect pages are untouched by the shared chrome.
for f in dist/goto/index.html dist/goto/install/index.html dist/goto/install/x4-pro/index.html; do assert_exist "$f"; done

# ── CI: every preview flag + fixtures still yields the production baseline ───
stage
build "CI [all flags + fixtures]" CI=true GITHUB_ACTIONS=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_production
unstage

# ── FINAL: production default, fixtures removed ─────────────────────────────
build "FINAL production"
assert_production

echo ""
echo "════════════════════════════════════════════"
echo "  homepage candidate:  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════════════════════════"
unstage
[ "$FAIL" -eq 0 ]
