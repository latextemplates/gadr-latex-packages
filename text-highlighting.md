# How to highlight text

## Context and Problem Statement

While writing, a passage is highlighted with a background color, for instance to mark text a reviewer commented on.
How to highlight a passage of text so that it breaks across lines?

## Considered Options

- `\colorbox` from [xcolor](https://ctan.org/pkg/xcolor)
- [soul](https://ctan.org/pkg/soul) with `\hl`
- [lua-ul](https://ctan.org/pkg/lua-ul) with `\highLight` (LuaLaTeX only)
- [tcolorbox](https://ctan.org/pkg/tcolorbox) with a breakable box

## Pros and Cons of the Options

### `\colorbox`

- Good, because it needs no further package and works with every engine.
- Bad, because the box is unbreakable: a passage longer than the rest of the line runs into the margin.

### soul

- Good, because the highlighted passage breaks across lines with every engine.
- Bad, because soul re-scans the passage syllable by syllable, so `\cite`, `\ref` and other commands with arguments fail unless they are braced (`{\cite{x}}`), and some content (verbatim, math) cannot be highlighted at all.

### lua-ul

```latex
\usepackage{luacolor,lua-ul}
\highLight[yellow!60]{text}
```

- Good, because it highlights at the node level after line breaking, so the passage may contain anything and breaks like ordinary text.
- Good, because the color needs no special syntax (`luacolor` is required for the color to show).
- Bad, because it needs LuaLaTeX.
- Bad, because luacolor replaces the color stack by attributes, which can interfere with packages that drive the color stack themselves.

### tcolorbox

- Good, because a breakable box can span pages.
- Bad, because it is a display element: it starts a new line and is meant for blocks, not for a few words inside a paragraph.
