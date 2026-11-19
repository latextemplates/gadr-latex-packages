# How to lay out complex tables

## Context and Problem Statement

A table in a thesis often needs more than rows and columns of equal width:
header cells that span several rows or columns, columns that share the remaining line width, and colored rows that guide the eye.
With plain `tabular`, each of these needs its own package and its own commands inside the rows.
How to set column widths, spanning cells, and row colors of a table?

## Considered Options

- `tabular` with [`tabularx`](https://ctan.org/pkg/tabularx), [`multirow`](https://ctan.org/pkg/multirow), and [`colortbl`](https://ctan.org/pkg/colortbl)
- [`tabularray`](https://ctan.org/pkg/tabularray)
- [`nicematrix`](https://ctan.org/pkg/nicematrix)

## Pros and Cons of the Options

### `tabular` with `tabularx`, `multirow`, and `colortbl`

- Good, because it is the classic approach: every LaTeX tutorial and most existing tables use it.
- Good, because `booktabs` rules work without any adaptation.
- Bad, because layout and content are mixed: `\multicolumn`, `\multirow`, and `\rowcolor` stand in the rows, so changing the layout means editing many rows.
- Bad, because the packages interact in fragile ways, e.g., a `\multirow` cell in a colored row is covered by the color of the next row.

### `tabularray`

- Good, because the layout is given once as key-value list in front of the content: `colspec` for the columns, `row{...}` for whole rows, and `cell{r}{c} = {r=2, c=3}` for spanning cells.
- Good, because `X` columns share the remaining width as in `tabularx`, and `longtblr` breaks a table across pages with the same keys.
- Good, because `\UseTblrLibrary{booktabs}` provides `\toprule`, `\midrule`, `\cmidrule`, and `\bottomrule` inside the table.
- Bad, because it compiles noticeably slower than `tabular`, as it measures every cell several times.
- Bad, because commands inside cells that are not robust may need to be protected or wrapped in braces.

### `nicematrix`

- Good, because `NiceTabular` keeps the `tabular` syntax and adds spanning cells (`\Block`), row colors, and rules drawn with PGF.
- Good, because it also typesets matrices with the same interface.
- Bad, because it needs two compilation runs to place the PGF nodes.
- Bad, because layout still stands partly in the rows (`\Block` in the cell where the span starts).
