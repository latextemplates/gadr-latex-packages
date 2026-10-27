# How to avoid widows and orphans

## Context and Problem Statement

A single line of a paragraph at the bottom (orphan) or top (widow) of a page looks bad.
How to avoid widows and orphans?

## Considered Options

- set `\clubpenalty` and `\widowpenalty` by hand
- [nowidow](https://ctan.org/pkg/nowidow)
- [lua-widow-control](https://ctan.org/pkg/lua-widow-control) (LuaLaTeX only)

## Pros and Cons of the Options

### Set `\clubpenalty` and `\widowpenalty` by hand

- Good, because it needs no package.
- Bad, because the page then ends one line earlier, leaving an empty line at the bottom of the page.

### nowidow

- Good, because it sets the penalties with one readable option (`all`, `defaultlines`).
- Bad, because it works the same way as setting the penalties by hand, so pages still end short.

### lua-widow-control

- Good, because it lengthens or shortens a paragraph on the page by one line, so the page stays full.
- Good, because it also avoids a hyphenated word broken across pages.
- Bad, because it needs LuaLaTeX.
