# How to manage acronyms and glossaries

## Context and Problem Statement

Acronyms should be spelled out in full on first use, shortened afterwards, and
collected into an auto-generated list. How should acronyms and glossaries be
managed?

## Considered Options

- manual first-use tracking
- [acronym](https://ctan.org/pkg/acronym)
- [glossaries](https://ctan.org/pkg/glossaries) / [glossaries-extra](https://ctan.org/pkg/glossaries-extra)
- [acro](https://ctan.org/pkg/acro)

## Pros and Cons of the Options

### manual

- Good, because it needs no package.
- Bad, because first-use expansion and the acronym list are maintained by hand and drift out of sync.

### acronym

- Good, because `\ac{...}` handles first-use expansion with a small, simple package.
- Bad, because it is limited for larger glossaries, sorting and cross-referencing.

### glossaries / glossaries-extra

- Good, because they handle acronyms, symbols and a sorted glossary, with `\gls{...}` doing the first-use logic; glossaries-extra modernizes the defaults and works with `bib2gls`.
- Bad, because they have a learning curve and need an extra build step (`makeglossaries` or `bib2gls`).
  Without it, the list stays empty.
  `makeglossaries` needs Perl; `makeglossaries-lite` (Lua, part of TeX Live) does not.
  `latexmk` can run the tool automatically (Overleaf reads a project's `latexmkrc`).

### acro

- Good, because it offers a modern, simpler API for acronyms specifically.
- Bad, because it is acronym-focused, not a full glossary system.

## More Information

A discussion on glossaries versus acro: <https://tex.stackexchange.com/questions/309203/glossaries-vs-acro>.
