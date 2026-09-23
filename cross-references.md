# How to write cross-references

## Context and Problem Statement

A reference should name what it points at — "Figure 3", "Section 2", "Equations
1 to 3" — and stay correct when floats move or change type. How should
cross-references be written?

## Considered Options

- manual `Figure~\ref{...}`
- [hyperref](https://ctan.org/pkg/hyperref)'s `\autoref`
- [cleveref](https://ctan.org/pkg/cleveref)
- [zref-clever](https://ctan.org/pkg/zref-clever)
- [varioref](https://ctan.org/pkg/varioref) (complementary, page-aware)

## Decision Outcome

Chosen option: "zref-clever", because it offers the cleveref feature set and works with tagged PDFs.

## Pros and Cons of the Options

### manual `Figure~\ref{}`

- Good, because it needs no package and gives full control of the wording.
- Bad, because the type name is repeated by hand — easy to forget, easy to make inconsistent, and wrong if a figure later becomes a table.
- Bad, because it cannot merge or sort a list of references.

### hyperref `\autoref`

- Good, because it ships with hyperref (usually already loaded for links) and prepends the type name automatically.
- Bad, because customizing the names is awkward and language handling is weak.
- Bad, because it cannot merge ranges (`\autoref` takes a single label).

### cleveref

- Good, because `\cref`/`\Cref` insert the right type name automatically and `\cref{a,b,c}` merges and sorts into "Figures 1 to 3".
- Good, because names are fully customizable and multilingual.
- Bad, because it must be loaded **last** (after hyperref and amsmath) and can clash with packages that redefine referencing.
- Bad, because it is only [partially compatible](https://latex3.github.io/tagging-project/tagging-status/#cleveref) with tagged (accessible) PDFs.
- Bad, because its last release dates from 2018; zref-clever is its successor.

### zref-clever

- Good, because `\zcref`/`\zcref[S]` insert the right type name automatically and `\zcref{a,b,c}` merges and sorts into "Figures 1 to 3" — the cleveref feature set.
- Good, because it is [compatible](https://latex3.github.io/tagging-project/tagging-status/#zref-clever) with tagged (accessible) PDFs.
- Good, because it builds on zref, so there is no load-order constraint and standard `\label` works unchanged.
- Good, because type names follow the babel language (English, German, … ship with the package) and are customizable.
- Bad, because the commands differ from cleveref (`\zcref` instead of `\cref`/`\Cref`), so existing documents need a search-and-replace.

### varioref

- Good, because it adds page-aware phrasing ("on the following page"), useful in print.
- Bad, because it solves a different sub-problem — it complements rather than replaces cleveref or zref-clever ([zref-vario](https://ctan.org/pkg/zref-vario) couples it to zref-clever as `\zvref`).
