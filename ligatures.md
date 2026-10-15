# How to avoid wrong ligatures

## Context and Problem Statement

A [ligature](https://en.wikipedia.org/wiki/Typographic_ligature) joins letters
such as "fl" or "fi". Typographic rules forbid ligatures across morpheme
boundaries: the "fl" in "offline" (English) or "Auflage" (German) must not be
joined. TeX sets ligatures everywhere. How should wrong ligatures be avoided?

## Considered Options

- [selnolig](https://ctan.org/pkg/selnolig) (LuaLaTeX)
- [autotype](https://ctan.org/pkg/autotype) (LuaLaTeX)
- [ligtype](https://ctan.org/pkg/ligtype) (LuaLaTeX)
- a post-processor ([rmligs](https://ctan.org/pkg/rmligs), [delig](https://ctan.org/pkg/delig), [ligatex](https://ctan.org/pkg/ligatex))
- suppress all ligatures
- ignore the issue

## Pros and Cons of the Options

### selnolig

- Good, because it suppresses ligatures exactly at the wrong places and keeps all others.
- Good, because it supports English and German.
- Bad, because it requires LuaLaTeX.
- Bad, because it is no longer maintained (last release 0.302 of 2015).

### autotype

- Good, because it covers German ligatures and offers further features (e.g., hyphenation of long words).
- Good, because it is maintained (release 0.6 of 2026).
- Bad, because it requires LuaLaTeX.
- Bad, because it does not support English.

### ligtype

- Good, because it handles German ligatures based on word lists.
- Bad, because it requires LuaLaTeX.
- Bad, because it does not support English.

### post-processor

- Good, because pdfLaTeX can be used.
- Bad, because it changes the `.tex` files.
- Bad, because it relies on babel's `"|` shortcut, which produces correct results only for "fl" with the Latin Modern font (see <https://tex.stackexchange.com/a/389439/9075>).

### suppress all ligatures

- Good, because it is easy and works with pdfLaTeX.
- Bad, because correct ligatures look better.

### ignore the issue

- Good, because it needs no effort and works with pdfLaTeX.
- Bad, because wrong ligatures are a typographic error.
