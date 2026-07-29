# How to place margin notes

## Context and Problem Statement

Short annotations, remarks and pointers often read best in the margin, kept
visually separate from the running text. How should margin notes be placed?

## Considered Options

* built-in `\marginpar`
* [marginnote](https://ctan.org/pkg/marginnote)
* [mindflow](https://ctan.org/pkg/mindflow)

## Pros and Cons of the Options

### `\marginpar`

- Good, because it is built into LaTeX.
- Bad, because it fails inside floats, footnotes and some environments, and offers no styling.

### marginnote

- Good, because `\marginnote` works in many places where `\marginpar` fails.
- Bad, because it is deliberately minimal — no built-in visual style beyond placement.

### mindflow

- Good, because it presents margin notes and annotations as a styled, visually distinct stream alongside the text.
- Bad, because it is a newer, less widely known package.
