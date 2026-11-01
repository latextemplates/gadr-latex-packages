# How to set footnotes in tables

## Context and Problem Statement

A `\footnote` inside a `tabular` that sits in a floating `table` produces the footnote mark, but the footnote text never appears: the float is set apart from the page's footnote list.
How to set footnotes in tables?

## Considered Options

- [`tablefootnote`](https://ctan.org/pkg/tablefootnote)
- [`threeparttable`](https://ctan.org/pkg/threeparttable)
- [`tabularray`](https://ctan.org/pkg/tabularray) with `talltblr`
- `\footnotemark` and `\footnotetext` by hand

## Pros and Cons of the Options

### `tablefootnote`

- Good, because `\tablefootnote` replaces `\footnote` one to one; the note is set at the bottom of the page like all other footnotes.
- Good, because it works in floats, `minipage`, and `sidewaystable`.
- Bad, because the note moves with the float, so it can end up on a different page than the sentence referring to the table.

### `threeparttable`

- Good, because the notes (`\tnote`) are set directly under the table in a `tablenotes` block, as journals often require.
- Good, because the notes are numbered separately from the text footnotes.
- Bad, because the table needs the extra `threeparttable` environment and `\tnote` instead of `\footnote`.
- Bad, because it is rarely seen in theses, so the result looks unusual to many readers.

### `tabularray` with `talltblr`

- Good, because `talltblr` sets table footnotes under the table with one package that also replaces `tabular`.
- Bad, because it means switching the table syntax of the whole document to `tabularray`.

### `\footnotemark` and `\footnotetext` by hand

- Good, because it needs no package.
- Bad, because the author keeps the counter and the placement in sync by hand, which breaks as soon as the float moves.
