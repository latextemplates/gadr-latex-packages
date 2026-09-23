# How to split a table cell diagonally

## Context and Problem Statement

A corner cell sometimes needs to label both its row and its column at once,
split by a diagonal line. How to draw a diagonally divided header cell?

## Considered Options

- [diagbox](https://ctan.org/pkg/diagbox)
- slashbox (obsolete)
- manual TikZ

## Pros and Cons of the Options

### diagbox

- Good, because `\diagbox{row}{col}` draws the diagonal and places both labels, measuring the cell automatically.
- Good, because it is the maintained successor to slashbox.
- Bad, because very tall multi-line entries can still need manual width hints.

### slashbox

- Bad, because it is obsolete and unmaintained; diagbox replaces it.

### manual TikZ

- Good, because it gives full control for unusual splits.
- Bad, because it is a lot of code for what diagbox does in one macro.
