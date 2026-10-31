# How to set footnotes side by side in one paragraph

## Context and Problem Statement

Each footnote takes at least one line at the bottom of the page, even when it is just a short URL.
In a document with a page limit, setting all footnotes of a page side by side in one paragraph saves space.
How to set footnotes in one paragraph?

## Considered Options

- [`footmisc`](https://ctan.org/pkg/footmisc) with option `para`
- [`manyfoot`](https://ctan.org/pkg/manyfoot) with option `para`
- [`bigfoot`](https://ctan.org/pkg/bigfoot) with `\DeclareNewFootnote[para]{default}`
- [`fnpara`](https://ctan.org/pkg/fnpara)
- [`dblfnote`](https://ctan.org/pkg/dblfnote) (footnotes in two columns)

All packages setting footnotes in one paragraph collect each footnote in a box.
TeX inserts no line break points into math inside a box, and `\url` typesets its argument in math mode, so URLs in such footnotes cannot break and run into the margin.
With [`xurl`](https://ctan.org/pkg/xurl) loaded, its stretchable glue lets the URL be letter-spaced across the line instead.
LuaTeX inserts the break points also inside boxes when `\mathpenaltiesmode=1` is set; pdfTeX has no such switch.

## Pros and Cons of the Options

### `footmisc` with option `para`

```latex
\usepackage[para]{footmisc}
\mathpenaltiesmode=1 % LuaLaTeX only: lets URLs break inside the footnote paragraph
```

- Good, because `\footnote` is used as usual.
- Good, because it is maintained by the LaTeX team and combines with its other options (`bottom`, `multiple`, `perpage`, ...).
- Good, because it works with hyperref.
- Bad, because URLs cannot break with pdfLaTeX (see above).

### `manyfoot` with option `para`

```latex
\usepackage[para]{manyfoot}
\DeclareNewFootnote[para]{A}
```

- Good, because several footnote levels (e.g., for critical editions) are supported.
- Bad, because footnotes have to be set with the new commands (`\footnoteA`), unless `\footnote` is redefined to one of them.
- Bad, because URLs cannot break with pdfLaTeX (see above).

### `bigfoot` with `\DeclareNewFootnote[para]{default}`

- Good, because paragraph footnotes may be split across pages and may be nested.
- Bad, because it does not compile with TeX Live 2026 and hyperref (`Undefined control sequence \FN@colorstack`); the last release is from 2015.
- Bad, because URLs cannot break with pdfLaTeX (see above).

### `fnpara`

- Bad, because it is superseded by footmisc's option `para` (stated on CTAN).
- Bad, because URLs cannot break with pdfLaTeX (see above).

### `dblfnote`

- Good, because URLs break as usual, since the footnotes are set as a paragraph each.
- Bad, because footnotes of different lengths leave the two columns uneven, which looks untidy.
- Bad, because the last release is from 1999.
