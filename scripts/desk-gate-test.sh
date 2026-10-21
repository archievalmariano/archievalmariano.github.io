#!/usr/bin/env bash
#
# DESK publication-gate test matrix.
#
# Stages SYNTHETIC fixtures into the editorial collections, builds the site in
# several flag states, and asserts exactly what is (and is not) emitted to dist/.
# Fixtures are always removed afterwards (trap), so none can leak into a
# committed/deployed build. Uses only astro + shell — no new dependency.
#
# States:
#   P   production default (no preview)            → collections absent
#   FC  fail-closed (DESK_PREVIEW set, no opt-in)  → collections absent
#   CI  CI hard-block (CI / GITHUB_ACTIONS PRESENT → collections absent even with
#       with ANY value, + opt-in + DESK_PREVIEW)      the local opt-in set
#   A   artifacts preview build (no CI indicator)   → artifacts present, drafts excluded
#   B   both preview build (no CI indicator)        → both present, drafts excluded
#   X   JSON-LD script-breakout probe               → malicious title cannot inject markup
#
# Proves: non-draft excluded when flag OFF; draft excluded when flag ON; the mere
# PRESENCE of a CI indicator (truthy, falsy, unexpected, or whitespace) blocks
# every override in production; ordinary local preview (no CI indicator) still
# works; JSON-LD is script-safe; no fixture / HTML / RSS / sitemap leak.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

AF="src/content/artifacts"
FN="src/content/fieldNotes"
FIX="test/fixtures/desk"

PASS=0
FAIL=0

cleanup() {
  rm -f "$AF/gate-published.mdx" "$AF/gate-draft.mdx" "$AF/gate-xss.mdx" \
        "$FN/gate-published.mdx" "$FN/gate-draft.mdx"
}
trap cleanup EXIT

stage() {
  cp "$FIX/artifacts-published.mdx" "$AF/gate-published.mdx"
  cp "$FIX/artifacts-draft.mdx" "$AF/gate-draft.mdx"
  cp "$FIX/field-note-published.mdx" "$FN/gate-published.mdx"
  cp "$FIX/field-note-draft.mdx" "$FN/gate-draft.mdx"
}

ok()   { PASS=$((PASS+1)); printf '   \033[32mPASS\033[0m %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '   \033[31mFAIL\033[0m %s\n' "$1"; }

assert_exist()  { if [ -e "$1" ]; then ok "exists: $1"; else bad "MISSING: $1"; fi; }
assert_absent() { if [ -e "$1" ]; then bad "SHOULD BE ABSENT: $1"; else ok "absent: $1"; fi; }
assert_grep()   { if grep -rqF "$2" "$1" 2>/dev/null; then ok "contains '$2': $1"; else bad "MISSING '$2' in $1"; fi; }
assert_nogrep() { if grep -rqF "$2" "$1" 2>/dev/null; then bad "SHOULD NOT contain '$2': $1"; else ok "absent '$2' in $1"; fi; }

# No unpublished editorial output anywhere: no collection HTML, no feed, no
# sitemap entry, no fixture leak.
assert_no_gated_output() {
  assert_absent dist/desk/artifacts
  assert_absent dist/desk/field-notes
  assert_absent dist/desk/rss.xml
  assert_nogrep dist "SYNTHETIC FIXTURE"
  for sm in dist/sitemap-0.xml dist/sitemap-index.xml; do
    [ -f "$sm" ] || continue
    assert_nogrep "$sm" "/desk/artifacts"
    assert_nogrep "$sm" "/desk/field-notes"
    assert_nogrep "$sm" "desk/rss"
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
assert_absent dist/desk/artifacts
assert_absent dist/desk/field-notes
assert_absent dist/desk/rss.xml
assert_nogrep dist "SYNTHETIC FIXTURE"      # no fixture leak anywhere

# ── State FC: fail-closed (production build; DESK_PREVIEW set, no opt-in) ──────
#    Normal `astro build` with the preview list set but no local authorization.
build "FC fail-closed" DESK_PREVIEW=artifacts,field-notes
assert_no_gated_output                        # accidental env override ignored

# ── State CI: CI hard-block — PRESENCE of any CI indicator disables preview, ──
#    whatever its value, even with the opt-in + DESK_PREVIEW set. GitHub Actions
#    can never expose a collection. Covers truthy, falsy, unexpected, and
#    whitespace-only values of CI and GITHUB_ACTIONS.
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
  assert_no_gated_output
done

# whitespace-only CI indicators (non-empty → conservatively treated as CI)
build "CI-detect [CI='   ']" "CI=   " DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_no_gated_output
build "CI-detect [GITHUB_ACTIONS='  ']" "GITHUB_ACTIONS=  " DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_no_gated_output

# ── State A: artifacts preview build ──────────────────────────────────────────
build "A artifacts-only" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts
assert_exist  dist/desk/artifacts/index.html
assert_exist  dist/desk/artifacts/gate-published/index.html
assert_absent dist/desk/artifacts/gate-draft        # draft excluded even when flag ON
assert_absent dist/desk/field-notes
assert_exist  dist/desk/rss.xml
assert_grep   dist/desk/rss.xml "Published Artifact Fixture"
assert_nogrep dist/desk/rss.xml "Draft Artifact Fixture"

# ── State B: both preview build ───────────────────────────────────────────────
build "B both" DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_exist  dist/desk/artifacts/index.html
assert_exist  dist/desk/artifacts/gate-published/index.html
assert_absent dist/desk/artifacts/gate-draft
assert_exist  dist/desk/field-notes/index.html
assert_exist  dist/desk/field-notes/gate-published/index.html
assert_absent dist/desk/field-notes/gate-draft
assert_exist  dist/desk/rss.xml
assert_grep   dist/desk/rss.xml "Published Field Note Fixture"
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

# ── Final: production build, fixtures removed ─────────────────────────────────
cleanup
build "FINAL production (fixtures removed)"
assert_absent dist/desk/artifacts
assert_absent dist/desk/field-notes
assert_absent dist/desk/rss.xml
assert_nogrep dist "SYNTHETIC FIXTURE"

echo ""
echo "════════════════════════════════════════════"
echo "  publication-gate matrix:  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════════════════════════"
[ "$FAIL" -eq 0 ]
