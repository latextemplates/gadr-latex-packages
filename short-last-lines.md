# How to avoid a short last line of a paragraph

## Context and Problem Statement

A last line that holds only a short word or a hyphenated fragment (a "runt") looks bad, and the next paragraph's indentation then starts almost below empty space.
French typography asks for a last line at least twice as long as the indentation.
How to avoid a short last line of a paragraph?

This is a line-breaking matter inside the paragraph; a single line of a paragraph at a page break is covered in [How to avoid widows and orphans](widows-and-orphans.md).

## Considered Options

- fix by hand (`\looseness`, ties)
- limit the stretch of `\parfillskip`
- [impnattypo](https://ctan.org/pkg/impnattypo) with option `lastparline` (LuaLaTeX only)

## Pros and Cons of the Options

### Fix by hand

`\looseness=-1` as the first thing in the paragraph asks TeX to set it one line shorter (`=1`: one line longer); TeX resets `\looseness` after each paragraph.
A tie (`~`) between the last two words pulls a second word onto the last line.

- Good, because the author decides each case.
- Bad, because it has to be redone after every text change, so it is a polishing step for the final text.

### Limit the stretch of `\parfillskip`

`\setlength{\parfillskip}{0pt plus 0.7\textwidth}` (instead of `0pt plus 1fil`) makes a very short last line cost badness, so TeX prefers other line breaks.

- Good, because it works with every engine and needs no package.
- Bad, because the glue is also stretched in ordinary paragraphs, which widens the interword spacing everywhere (the reason this was reverted in lncs-enhanced once, see [lncs-enhanced#16](https://github.com/latextemplates/lncs-enhanced/issues/16)).
- Bad, because the fixed value does not follow `\linewidth` in lists and narrow columns.

### impnattypo with option `lastparline`

- Good, because with LuaLaTeX it inspects each paragraph after line breaking and vetoes only the offending break, so other paragraphs are untouched.
- Good, because it also offers related French typography features (`parindent`, `nosingleletter`).
- Bad, because its pdfLaTeX fallback is the global `\parfillskip` stretch above, with its wide interword spacing.
