#!/usr/bin/env bash
#
# DESK publication-gate test matrix.
#
# Stages SYNTHETIC fixtures into the editorial collections, builds the site in
# several flag states, and asserts exactly what is (and is not) emitted to dist/.
# Fixtures are always removed afterwards (trap), so none can leak into a
# committed/deployed build. Uses only astro + shell — no new dependency.
#
# Publication baseline (src/data/desk.ts): FIELD NOTES published, ARTIFACTS gated.
#
# States:
#   P   production default (no preview)            → FIELD NOTES published, ARTIFACTS gated
#   FC  fail-closed (DESK_PREVIEW set, no opt-in)  → same as P (preview override ignored)
#   CI  CI hard-block (CI / GITHUB_ACTIONS PRESENT → same as P (ARTIFACTS override blocked)
#       with ANY value, + opt-in + DESK_PREVIEW)
#   A   artifacts preview build (no CI indicator)   → artifacts present, drafts excluded
#   B   both preview build (no CI indicator)        → both present, drafts excluded
#   X   JSON-LD script-breakout probe               → malicious title cannot inject markup
#
# Proves: the PUBLISHED collection (FIELD NOTES) ships only its non-draft entries
# — a draft:true field note stays out of routes, homepage, feed and sitemap, and
# "published" never means "unrestricted". ARTIFACTS stays GATED: it cannot be
# exposed by any preview override or by any CI value (fail closed), the mere
# PRESENCE of a CI indicator (truthy, falsy, unexpected, or whitespace) blocks
# every override, ordinary local preview still works, JSON-LD is script-safe, and
# no gated-artifacts or draft fixture leaks into HTML / RSS / sitemap.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

AF="src/content/artifacts"
FN="src/content/fieldNotes"
FIX="test/fixtures/desk"

# The approved, published Field Note (not a fixture — a committed article).
FN_SLUG="make-no-mistakes-adds-the-monkey"

PASS=0
FAIL=0

cleanup() {
  # Remove every synthetic fixture this script may have staged. $FN/gate-published
  # is removed defensively even though it is no longer staged (FIELD NOTES is a
  # published collection), so any stray never survives into a real build.
  rm -f "$AF/gate-published.mdx" "$AF/gate-draft.mdx" "$AF/gate-xss.mdx" \
        "$FN/gate-published.mdx" "$FN/gate-draft.mdx"
}
trap cleanup EXIT

stage() {
  # ARTIFACTS (gated): published + draft synthetic fixtures. Neither may appear in
  # a production build; the published one may appear ONLY in an ARTIFACTS preview
  # build, and the draft never.
  cp "$FIX/artifacts-published.mdx" "$AF/gate-published.mdx"
  cp "$FIX/artifacts-draft.mdx" "$AF/gate-draft.mdx"
  # FIELD NOTES (published): stage ONLY a synthetic DRAFT. A synthetic *published*
  # field note is deliberately NOT staged — the collection is now public, so it
  # would build straight into the real production output. Published behaviour is
  # asserted against the approved article instead; this draft proves draft is
  # excluded and, being excluded, never leaks "SYNTHETIC FIXTURE" into dist.
  cp "$FIX/field-note-draft.mdx" "$FN/gate-draft.mdx"
}

ok()   { PASS=$((PASS+1)); printf '   \033[32mPASS\033[0m %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '   \033[31mFAIL\033[0m %s\n' "$1"; }

assert_exist()  { if [ -e "$1" ]; then ok "exists: $1"; else bad "MISSING: $1"; fi; }
assert_absent() { if [ -e "$1" ]; then bad "SHOULD BE ABSENT: $1"; else ok "absent: $1"; fi; }
assert_grep()   { if grep -rqF "$2" "$1" 2>/dev/null; then ok "contains '$2': $1"; else bad "MISSING '$2' in $1"; fi; }
assert_nogrep() { if grep -rqF "$2" "$1" 2>/dev/null; then bad "SHOULD NOT contain '$2': $1"; else ok "absent '$2' in $1"; fi; }

# The authorized production baseline: FIELD NOTES published, ARTIFACTS gated. This
# EXACT output must hold in the real production build AND in every state where a
# preview override is present but must be ignored (fail-closed and CI), so the
# same assertions run for P, FC and every CI state.
assert_production_baseline() {
  # FIELD NOTES — published: index + the approved article, surfaced in the DESK
  # homepage listing, the feed and the sitemap.
  assert_exist  dist/desk/field-notes/index.html
  assert_exist  "dist/desk/field-notes/$FN_SLUG/index.html"
  assert_grep   dist/desk/index.html "/desk/field-notes/$FN_SLUG/"
  assert_exist  dist/desk/rss.xml
  assert_grep   dist/desk/rss.xml "$FN_SLUG"
  assert_grep   dist/sitemap-0.xml "/desk/field-notes/$FN_SLUG/"
  # FIELD NOTES — published is NOT unrestricted: a draft:true entry stays out of
  # routes, the homepage, the feed and the sitemap.
  assert_absent dist/desk/field-notes/gate-draft
  assert_nogrep dist/desk/index.html "Draft Field Note Fixture"
  assert_nogrep dist/desk/rss.xml "Draft Field Note Fixture"
  assert_nogrep dist/sitemap-0.xml "gate-draft"
  # ARTIFACTS — still gated: no routes, no homepage entry, nothing in the feed.
  assert_absent dist/desk/artifacts
  assert_nogrep dist/desk/index.html "/desk/artifacts/"
  assert_nogrep dist/desk/rss.xml "Artifact Fixture"
  # No synthetic fixture leaks anywhere (gated artifacts + excluded field-note draft).
  assert_nogrep dist "SYNTHETIC FIXTURE"
  for sm in dist/sitemap-0.xml dist/sitemap-index.xml; do
    [ -f "$sm" ] || continue
    assert_nogrep "$sm" "/desk/artifacts"
  done
}

build() { # $1 = label, rest = env assignments
  local label="$1"; shift
  echo ""; echo "── building state: $label (env: ${*:-none}) ──"
  rm -rf dist
  # Neutralize any ambient CI / GITHUB_ACTIONS so each state's CI signal is
  # exactly what this call passes (env applies -u before the assignments).
  if env -u CI -u GITHUB_ACTIONS "$@" npm run build >/tmp/desk_build.log 2>&1; then
    echo "   build ok"
  else
    bad "BUILD FAILED ($label) — see /tmp/desk_build.log"; tail -20 /tmp/desk_build.log
  fi
}

stage

# ── State P: production default ───────────────────────────────────────────────
build "P production-default"
assert_exist  dist/desk/projects/index.html
assert_exist  dist/desk/goto/index.html
assert_exist  dist/desk/on-point/index.html
assert_exist  dist/desk/tools/index.html
assert_production_baseline

# ── State FC: fail-closed (production build; DESK_PREVIEW set, no opt-in) ──────
#    Normal `astro build` with the preview list set but no local authorization.
#    FIELD NOTES is published by the committed flag; the ARTIFACTS preview
#    override must be ignored, so the output equals the production baseline.
build "FC fail-closed" DESK_PREVIEW=artifacts,field-notes
assert_production_baseline

# ── State CI: CI hard-block — PRESENCE of any CI indicator disables preview, ──
#    whatever its value, even with the opt-in + DESK_PREVIEW set. GitHub Actions
#    can never expose the GATED collection. Covers truthy, falsy, unexpected, and
#    whitespace-only values of CI and GITHUB_ACTIONS. Output equals the baseline
#    (FIELD NOTES published, ARTIFACTS gated).
for spec in \
  "CI=true" \
  "CI=1" \
  "CI=yes" \
  "CI=unexpected" \
  "CI=false" \
  "CI=0" \
  "GITHUB_ACTIONS=true" \
  "GITHUB_ACTIONS=1" \
  "GITHUB_ACTIONS=unexpected" \
  "GITHUB_ACTIONS=false" \
  "GITHUB_ACTIONS=0"; do
  build "CI-detect [$spec]" $spec DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
  assert_production_baseline
done

# whitespace-only CI indicators (non-empty → conservatively treated as CI)
build "CI-detect [CI='   ']" "CI=   " DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_production_baseline
build "CI-detect [GITHUB_ACTIONS='  ']" "GITHUB_ACTIONS=  " DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_production_baseline

# ── State A: artifacts preview build (FIELD NOTES stays published via its flag) ─
build "A artifacts-preview" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts
assert_exist  dist/desk/artifacts/index.html
assert_exist  dist/desk/artifacts/gate-published/index.html
assert_absent dist/desk/artifacts/gate-draft        # draft excluded even when flag ON
assert_exist  dist/desk/field-notes/index.html
assert_exist  "dist/desk/field-notes/$FN_SLUG/index.html"
assert_absent dist/desk/field-notes/gate-draft      # published collection, draft still excluded
assert_exist  dist/desk/rss.xml
assert_grep   dist/desk/rss.xml "Published Artifact Fixture"
assert_nogrep dist/desk/rss.xml "Draft Artifact Fixture"
assert_grep   dist/desk/rss.xml "$FN_SLUG"
assert_nogrep dist/desk/rss.xml "Draft Field Note Fixture"

# ── State B: both preview build ───────────────────────────────────────────────
#    ARTIFACTS via preview override, FIELD NOTES via its published flag. The
#    approved article (not a fixture) is the published field note here.
build "B both" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_exist  dist/desk/artifacts/index.html
assert_exist  dist/desk/artifacts/gate-published/index.html
assert_absent dist/desk/artifacts/gate-draft
assert_exist  dist/desk/field-notes/index.html
assert_exist  "dist/desk/field-notes/$FN_SLUG/index.html"
assert_absent dist/desk/field-notes/gate-draft
assert_exist  dist/desk/rss.xml
assert_grep   dist/desk/rss.xml "Published Artifact Fixture"
assert_nogrep dist/desk/rss.xml "Draft Artifact Fixture"
assert_grep   dist/desk/rss.xml "$FN_SLUG"
assert_nogrep dist/desk/rss.xml "Draft Field Note Fixture"

# ── State X: JSON-LD script-breakout probe ────────────────────────────────────
#    A synthetic article whose title/description contain `</script><script>…`
#    must not terminate the JSON-LD block or inject an executable script. The
#    malicious fixture is generated inline (no committed fixture file) and
#    removed immediately after.
cat > "$AF/gate-xss.mdx" <<'EOF'
---
title: "SYNTHETIC XSS </script><script>alert(1)</script> Fixture"
description: "JSON-LD escape probe. </script><script>alert(2)</script>"
pubDate: 2026-01-06
draft: false
---

SYNTHETIC FIXTURE — JSON-LD breakout probe. Not for publication.
EOF
build "X json-ld-breakout" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts
XF=dist/desk/artifacts/gate-xss/index.html
assert_exist  "$XF"
assert_grep   "$XF" "u003c"                   # JSON-LD angle brackets are \uXXXX-escaped
# Decisive probe: isolate the ld+json <script> block and confirm it parses as
# JSON AND preserves the full angle-bracket-laden title. A real breakout would
# terminate the script at the raw </script>, truncating the block so JSON.parse
# fails. (Inert occurrences inside quoted og:title attributes are ignored.)
if node -e '
  const fs = require("fs");
  const html = fs.readFileSync(process.argv[1], "utf8");
  const m = html.match(/<script type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/);
  if (!m) process.exit(2);
  const obj = JSON.parse(m[1]);
  if (!String(obj.headline).includes("</script><script>alert(1)</script>")) process.exit(3);
  process.exit(0);
' "$XF" 2>/dev/null; then
  ok "JSON-LD parses safely; malicious title cannot inject a script element"
else
  bad "JSON-LD breakout: ld+json block is not safe/parseable"
fi
rm -f "$AF/gate-xss.mdx"

# ── Final: true production build, synthetic fixtures removed ───────────────────
#    What actually deploys: the approved Field Note is public, ARTIFACTS gated,
#    and no synthetic fixture is present at all.
cleanup
build "FINAL production (fixtures removed)"
assert_absent dist/desk/artifacts
assert_exist  dist/desk/field-notes/index.html
assert_exist  "dist/desk/field-notes/$FN_SLUG/index.html"
assert_exist  dist/desk/rss.xml
assert_grep   dist/desk/rss.xml "$FN_SLUG"
assert_nogrep dist/desk/index.html "/desk/artifacts/"
assert_nogrep dist "SYNTHETIC FIXTURE"

echo ""
echo "════════════════════════════════════════════"
echo "  publication-gate matrix:  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════════════════════════"
[ "$FAIL" -eq 0 ]
