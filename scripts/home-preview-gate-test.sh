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
#   ON   HOME_PREVIEW=true, no CI indicator              → all four pages render,
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

# ── ON: deliberate local preview renders ────────────────────────────────────
build "ON local preview" HOME_PREVIEW=true
for p in "" broadsheet/ ledger/ atlas/; do
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
for sm in dist/sitemap-0.xml dist/sitemap-index.xml; do
  [ -f "$sm" ] && assert_nogrep "$sm" "/preview/"
done
# Unpublished DESK collections stay out of the previews.
assert_nogrep dist/preview "/desk/artifacts"
assert_nogrep dist/preview "/desk/field-notes"
# The homepage markup is unchanged by the preview build. (Only stylesheet chunk
# names may differ: Vite re-splits shared CSS when the extra route exists. A
# preview build is never deployed; production builds are compared byte-for-byte
# above.)
strip_css() { sed 's/></>\n</g' "$1" | grep -v 'rel="stylesheet"'; }
if diff -q <(strip_css dist/index.html) <(strip_css "${TMPDIR:-/tmp}/home_index_default.html") >/dev/null; then
  ok "homepage markup identical with and without HOME_PREVIEW (stylesheet links excluded)"
else
  bad "homepage markup differs when HOME_PREVIEW=true"
fi

# ── FINAL: production build ─────────────────────────────────────────────────
build "FINAL production"
assert_no_preview

echo ""
echo "════════════════════════════════════════════"
echo "  home-preview gate:  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════════════════════════"
rm -rf "$REF"
[ "$FAIL" -eq 0 ]
