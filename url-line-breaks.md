# How to break long URLs

## Context and Problem Statement

URLs in the text and in the bibliography are often longer than the remaining line.
Without a break point, they run into the margin.
How to break long URLs?

## Considered Options

- [`url`](https://ctan.org/pkg/url) with option `hyphens`
- [`url`](https://ctan.org/pkg/url) with additional break points (`\g@addto@macro{\UrlBreaks}{\UrlOrds}`)
- [xurl](https://ctan.org/pkg/xurl)

## Pros and Cons of the Options

### `url` with option `hyphens`

- Good, because it is the standard package, loaded by hyperref and many classes.
- Bad, because it breaks only at a few characters (`/`, `.`, `-`, …); a long segment without them, such as a commit hash, runs into the margin.

### `url` with additional break points

- Good, because it adds more symbols as break points without a further package.
- Bad, because it relies on internals and still does not break between letters and digits.

### xurl

- Good, because it allows breaks after any character, so no URL runs into the margin.
- Good, because it sets biblatex's URL penalties when loaded after biblatex, and leaves them alone when loaded before.
- Bad, because a URL may break inside a word, which is harder to read.
