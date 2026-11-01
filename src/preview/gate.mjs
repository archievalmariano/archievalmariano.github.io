// Homepage redesign explorations — preview gate (plain JS so that both
// astro.config.mjs and the route can import it).
//
// FAIL-CLOSED, mirroring the DESK rule in src/data/desk.ts without sharing or
// altering it:
//   • the mere PRESENCE of a CI indicator (CI or GITHUB_ACTIONS with ANY
//     non-empty value — "true", "false", "0", whitespace…) disables previews, so
//     the GitHub Pages workflow can never emit them;
//   • otherwise previews require an explicit affirmative HOME_PREVIEW value
//     (true / 1 / yes / on), for `astro dev` and `astro build` alike.
//
// When the gate is closed the preview route is never injected (see
// astro.config.mjs), so it is not part of the build graph at all: no HTML, no
// CSS, no fonts, no sitemap entry. The production homepage is untouched.

function env(name) {
  return typeof process !== 'undefined' && process.env ? process.env[name] : undefined;
}

function isTruthy(value) {
  if (!value) return false;
  return ['true', '1', 'yes', 'on'].includes(value.trim().toLowerCase());
}

// Present = defined and not the empty string. The value is never parsed.
function ciFlagPresent(value) {
  return value !== undefined && value !== '';
}

/** @returns {boolean} */
export function homePreviewEnabled() {
  if (ciFlagPresent(env('CI')) || ciFlagPresent(env('GITHUB_ACTIONS'))) return false;
  return isTruthy(env('HOME_PREVIEW'));
}
