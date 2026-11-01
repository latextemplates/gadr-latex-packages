# How to show the writing progress of chapters

## Context and Problem Statement

While writing a thesis, authors and advisors want to see at a glance how far each chapter or section is written.
A small progress bar below the heading, removable for the final version, does that.
How to show the writing progress?

## Considered Options

- [`progress`](https://ctan.org/pkg/progress)
- [`progressbar`](https://ctan.org/pkg/progressbar)
- own macro drawing a bar with `\rule` or TikZ

## Pros and Cons of the Options

### `progress`

- Good, because `\progress{60}` also writes an HTML report listing all headings with their progress.
- Good, because the option `final` removes all bars and the report.
- Bad, because it redefines `\chapter`, `\section`, etc., which breaks with the appendix: it compares `\thechapter` (`A`) with a number and fails with "Missing number".
- Bad, because it draws the bar in the margin; placing it below the heading needs a redefinition of `\ProgressDocOutput`.
- Bad, because it is unmaintained since 2003.

### `progressbar`

- Good, because it only draws a bar (`\progressbar{0.6}`) and leaves the headings alone, so it works with KOMA-Script, `hyperref`, and appendices.
- Good, because width, height, colors, and ticks are configurable.
- Neutral, because it is placed by hand below the heading, and hiding all bars needs a small wrapper macro.
- Bad, because it does not write a progress report.
- Bad, because it loads TikZ.

### Own macro

- Good, because it needs no further package.
- Bad, because every template has to write and maintain the drawing code.
