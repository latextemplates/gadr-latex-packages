# How to typeset quotation marks

## Context and Problem Statement

Quotation marks differ by language (English "…", German „…", French « … »),
they nest, and they should not be hard-coded glyphs. How should quotations be
typeset?

## Considered Options

- hard-coded glyphs (`` ``...'' ``)
- [csquotes](https://ctan.org/pkg/csquotes)
- [textcmds](https://ctan.org/pkg/textcmds) (`\qq`)

## Pros and Cons of the Options

### hard-coded glyphs

- Good, because it needs no package.
- Bad, because it is wrong for any language whose marks differ from English, and nesting must be tracked by hand.
- Bad, because switching the document language means editing every quote.

### csquotes

- Good, because `\enquote{...}` picks the right marks from the active babel/polyglossia language and switches nested marks automatically.
- Good, because it integrates with biblatex for quoted citations.
- Bad, because it is a heavier dependency and some languages need a little configuration.

### textcmds

- Good, because `\qq{...}` is a lightweight alternative when the full csquotes machinery is not needed.
- Bad, because it offers less language integration than csquotes.
