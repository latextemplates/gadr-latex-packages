# How to control hyphenation

## Context and Problem Statement

Bad line breaks and overfull boxes often come down to hyphenation: TeX's
automatic hyphenation, exceptions for specific words, and micro-typographic
tuning. How should hyphenation be controlled?

## Considered Options

- automatic hyphenation + manual `\-` / `\hyphenation{}`
- [microtype](https://ctan.org/pkg/microtype)
- babel / language hyphenation patterns

## Pros and Cons of the Options

### `\-` and `\hyphenation{}`

- Good, because they are built in and give exact control: a discretionary break with `\-`, or global exceptions with `\hyphenation{...}`.
- Bad, because they are manual — they fix individual words, not overall quality.

### microtype

- Good, because character protrusion and font expansion improve spacing so much that far fewer hyphenation and overfull-box problems remain.
- Good, because it needs almost no configuration.
- Bad, because the full feature set depends on the engine (pdfTeX best; some features limited elsewhere).

### babel language patterns

- Good, because loading the correct document language selects the right hyphenation patterns — essential for non-English text.
- Bad, because it is a prerequisite for correct hyphenation, not a quality tuner on its own.
