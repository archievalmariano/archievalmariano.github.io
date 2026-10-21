# Artifacts — manuscript privacy

This directory holds the **Artifacts** content collection ("As Things Stand").
Files whose names start with `_` (like this one) are ignored by Astro's content
collections, so this note never becomes a page.

**Unpublished manuscripts must NOT be committed to this repository.**

This portfolio repository may be publicly accessible. Astro's `draft` flag and
the collection publish gate exclude unpublished work from the *generated site*,
but they do **not** make committed *source files* private — anyone reading the
repository can see them. Therefore:

- Keep real, in-progress essays (e.g. the X100VI and Fold7 pieces) **outside
  the public repository** until their publication is approved.
- Add a finished essay here only when it is ready to publish, together with its
  photography, and then launch the collection via `src/data/desk.ts`.
- Synthetic fixtures used to exercise the publication gate live in
  `test/fixtures/desk/` and are staged in/out by `scripts/desk-gate-test.sh`;
  they are never committed into this directory.
