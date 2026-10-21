#!/usr/bin/env bash
#
# DESK publication-gate test matrix.
#
# Stages SYNTHETIC fixtures into the editorial collections, builds the site in
# four flag states, and asserts exactly what is (and is not) emitted to dist/.
# Fixtures are always removed afterwards (trap), so none can leak into a
# committed/deployed build. Uses only astro + shell — no new dependency.
#
# States:
#   P  production default (no preview)          → collections absent
#   FC fail-closed (DESK_PREVIEW set, no opt-in) → collections absent
#   A  artifacts preview build                   → artifacts present, drafts excluded
#   B  both preview build                        → both present, drafts excluded
#
# Proves: non-draft excluded when flag OFF; draft excluded when flag ON;
# accidental env override never exposes in a production build; no fixture leak.

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

AF="src/content/artifacts"
FN="src/content/fieldNotes"
FIX="test/fixtures/desk"

PASS=0
FAIL=0

cleanup() {
  rm -f "$AF/gate-published.mdx" "$AF/gate-draft.mdx" \
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

build() { # $1 = label, rest = env assignments
  local label="$1"; shift
  echo ""; echo "── building state: $label (env: ${*:-none}) ──"
  rm -rf dist
  if env "$@" npm run build >/tmp/desk_build.log 2>&1; then
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

# ── State FC: fail-closed (override set, but NOT a preview build) ──────────────
build "FC fail-closed" DESK_PREVIEW=artifacts,field-notes
assert_absent dist/desk/artifacts            # accidental env override ignored in prod build
assert_absent dist/desk/field-notes
assert_absent dist/desk/rss.xml
assert_nogrep dist "SYNTHETIC FIXTURE"

# ── State CI: CI hard-block (even the opt-in vars must not expose in CI) ───────
build "CI hard-block" CI=true GITHUB_ACTIONS=true DESK_PREVIEW_BUILD=true DESK_PREVIEW=artifacts,field-notes
assert_absent dist/desk/artifacts            # GitHub Pages workflow is immune to every override
assert_absent dist/desk/field-notes
assert_absent dist/desk/rss.xml
assert_nogrep dist "SYNTHETIC FIXTURE"

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
