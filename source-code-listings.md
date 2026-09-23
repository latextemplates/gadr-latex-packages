# How to typeset source code

## Context and Problem Statement

Documents need to show source code and terminal transcripts with syntax
highlighting, line numbers, and correct handling of special characters.
Which package should typeset code listings?

## Considered Options

- [listings](https://ctan.org/pkg/listings)
- [minted](https://ctan.org/pkg/minted)
- [fancyvrb](https://ctan.org/pkg/fancyvrb) (verbatim only, no highlighting)

## Pros and Cons of the Options

### listings

- Good, because it is pure LaTeX — no external tools, no `--shell-escape`, works on any TeX Live and on Overleaf out of the box.
- Good, because it is fast and self-contained.
- Bad, because its highlighting is keyword-based and less accurate than a real lexer, with dated defaults.
- Bad, because UTF-8 and some languages need extra configuration.

### minted

- Good, because it uses [Pygments](https://pygments.org/) for accurate, up-to-date highlighting across hundreds of languages.
- Good, because output looks modern with little configuration.
- Bad, because it requires `--shell-escape` plus a Python + Pygments install, which many CI and Overleaf setups restrict for security reasons.
- Bad, because it slows compilation (an external process per listing).

### fancyvrb

- Good, because it is the lightweight choice when no highlighting is needed — faithful verbatim with framing and line numbers.
- Bad, because it does no syntax highlighting at all.
