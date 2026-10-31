# How to avoid lines running into the margin

## Context and Problem Statement

TeX leaves a line overfull (running into the margin) when it finds no acceptable break, for instance with long inline code or URLs.
Fixing each case by hand (`\-`, `\linebreak`, rewording) takes time and has to be redone after every change of the text.
How to avoid overfull lines?

## Considered Options

- fix by hand
- set `\emergencystretch` globally
- [`linebreaker`](https://ctan.org/pkg/linebreaker) (LuaLaTeX only)

## Pros and Cons of the Options

### Fix by hand

- Good, because the author decides each break.
- Bad, because it has to be repeated after every text change.

### Set `\emergencystretch` globally

- Good, because it works with every engine.
- Bad, because one value is either too small for the hard cases or loosens paragraphs that do not need it.

### `linebreaker`

- Good, because it raises `\tolerance` and `\emergencystretch` only for paragraphs that would otherwise be overfull, step by step until they fit.
- Bad, because the re-broken paragraph can have visibly wide interword spaces.
- Bad, because it needs LuaLaTeX.
