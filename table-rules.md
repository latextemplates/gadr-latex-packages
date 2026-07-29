# How to draw table rules

## Context and Problem Statement

Default LaTeX table rules (`\hline`, double lines, vertical rules) look cramped
and dated. How should horizontal rules in tables be drawn?

## Considered Options

* default `\hline` / `\cline`
* [booktabs](https://ctan.org/pkg/booktabs)
* [tabularray](https://ctan.org/pkg/tabularray)

## Pros and Cons of the Options

### default `\hline`

- Good, because it is built in.
- Bad, because rules touch the text with no padding, double rules look heavy, and the common vertical-rule style is typographically poor.

### booktabs

- Good, because `\toprule`/`\midrule`/`\bottomrule` add correct spacing and weight for clean, professional tables.
- Good, because it encodes the "no vertical rules" convention that most style guides recommend.
- Bad, because it deliberately does not support vertical rules — a constraint if a house style demands them.

### tabularray

- Good, because it is a modern all-in-one table package with rules, spanning and per-cell styling in one interface.
- Bad, because it is a large, newer dependency — more than is needed when only good rules are wanted.
