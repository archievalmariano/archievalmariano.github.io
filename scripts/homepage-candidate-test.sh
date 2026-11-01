#!/usr/bin/env bash
#
# Production-candidate checks for the "Quiet Personal Site" homepage and the
# shared navigation/footer. Complements scripts/desk-gate-test.sh (which is
# unchanged). Builds the site in several states and inspects dist/ directly.
# Uses only astro + shell + node — no new dependency.
#
# States:
#   P     production default     → approved homepage; Projects expanded,
#                                  Artifacts/Field Notes compact and unlinked
#   CI    CI + every preview flag + synthetic DESK fixtures staged
#                                → still nothing gated in dist/
#   S2    local DESK preview of Artifacts only (fixtures)
#                                → Artifacts row expands; Field Notes compact
#   S3    local DESK preview of both (fixtures) → all three rows expand
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

ok()  { PASS=$((PASS+1)); printf '   \033[32mPASS\033[0m %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '   \033[31mFAIL\033[0m %s\n' "$1"; }
assert_exist()  { if [ -e "$1" ]; then ok "exists: $1"; else bad "MISSING: $1"; fi; }
assert_absent() { if [ -e "$1" ]; then bad "SHOULD BE ABSENT: $1"; else ok "absent: $1"; fi; }
assert_grep()   { if grep -rqF -- "$2" "$1" 2>/dev/null; then ok "contains '$2': $1"; else bad "MISSING '$2' in $1"; fi; }
assert_nogrep() { if grep -rqF -- "$2" "$1" 2>/dev/null; then bad "SHOULD NOT contain '$2': $1"; else ok "absent '$2' in $1"; fi; }
assert_count()  { local n; n=$(grep -oF -- "$2" "$1" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$n" = "$3" ]; then ok "count('$2') = $3: $1"; else bad "count('$2') = $n, expected $3: $1"; fi; }

unstage() { rm -f "$AF/gate-published.mdx" "$AF/gate-draft.mdx" "$FN/gate-published.mdx" "$FN/gate-draft.mdx"; }
stage() {
  cp "$FIX/artifacts-published.mdx" "$AF/gate-published.mdx"
  cp "$FIX/artifacts-draft.mdx" "$AF/gate-draft.mdx"
  cp "$FIX/field-note-published.mdx" "$FN/gate-published.mdx"
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

assert_no_gated() {
  assert_absent dist/desk/artifacts
  assert_absent dist/desk/field-notes
  assert_absent dist/desk/rss.xml
  assert_nogrep dist "/desk/artifacts"
  assert_nogrep dist "/desk/field-notes"
  assert_nogrep dist "SYNTHETIC"
}

# ── P: production default ───────────────────────────────────────────────────
build "P production-default"
assert_exist "$H"
assert_no_gated

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

# Desk state 1: Projects expanded (DOGEAR), Artifacts/Field Notes compact.
assert_count  "$H" 'qs-row--featured' 1
assert_count  "$H" 'qs-row--compact' 2
assert_grep   "$H" 'href="/desk/dogear/"'
for p in on-point goto tools; do assert_nogrep "$H" "href=\"/desk/$p/\""; done

# Work: two case studies, link after them; prototypes in Work, same tab.
assert_grep   "$H" 'href="/work/digital-intelligence-dashboard"'
assert_grep   "$H" 'href="/work/audience-intelligence-system"'
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

# ── CI: every flag + fixtures under CI → nothing gated ──────────────────────
stage
build "CI [all flags + fixtures]" CI=true GITHUB_ACTIONS=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_no_gated
assert_count "$H" 'qs-row--compact' 2
unstage

# ── S2: Artifacts launched locally (fixtures) ────────────────────────────────
stage
build "S2 artifacts only" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts
assert_count  "$H" 'qs-row--featured' 2
assert_count  "$H" 'qs-row--compact' 1
assert_grep   "$H" 'href="/desk/artifacts/gate-published/"'
assert_nogrep "$H" "gate-draft"
assert_nogrep "$H" "/desk/field-notes"
assert_grep   dist/about/index.html 'href="/desk/artifacts/"'   # footer directory follows the gate
unstage

# ── S3: both launched locally (fixtures) ─────────────────────────────────────
stage
build "S3 artifacts + field notes" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_count  "$H" 'qs-row--featured' 3
assert_count  "$H" 'qs-row--compact' 0
assert_grep   "$H" 'href="/desk/field-notes/gate-published/"'
assert_nogrep "$H" "gate-draft"
unstage

# ── FINAL: production default, fixtures removed ─────────────────────────────
build "FINAL production"
assert_no_gated

echo ""
echo "════════════════════════════════════════════"
echo "  homepage candidate:  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════════════════════════"
unstage
[ "$FAIL" -eq 0 ]
