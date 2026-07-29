# How to typeset numbers and units

## Context and Problem Statement

Physical quantities need a consistent number format, a thin space before the
unit, upright unit symbols, digit grouping, and columns that align on the
decimal marker. How should numbers and units be typeset?

## Considered Options

* manual math mode (`$3.5\,\mathrm{kg}$`)
* [siunitx](https://ctan.org/pkg/siunitx)
* [units](https://ctan.org/pkg/units) / SIunits (older, superseded)

## Pros and Cons of the Options

### manual math mode

- Good, because it needs no package.
- Bad, because spacing, upright units and digit grouping are done by hand and drift out of consistency across a document.
- Bad, because table columns cannot align on the decimal marker.

### siunitx

- Good, because `\qty{3.5}{\kg}`, `\num{...}` and `\si{...}` give consistent spacing, digit grouping, uncertainties and range formatting.
- Good, because the `S` column type aligns numbers on the decimal marker in tables.
- Bad, because it is a large package with noticeable compile overhead.
- Bad, because the v2→v3 API change (`\SI` → `\qty`) means older examples need updating.

### units / SIunits

- Bad, because these older packages are superseded by siunitx and no longer recommended.
