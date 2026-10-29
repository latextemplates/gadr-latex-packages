# How to typeset quotation marks

## Context and Problem Statement

Quotation marks differ by language (English "…", German „…", French « … »),
they nest, and they should not be hardcoded glyphs. How should quotations be
typeset?

## Considered Options

- hardcoded glyphs (`` ``...'' ``)
- [csquotes](https://ctan.org/pkg/csquotes)
- csquotes with `\MakeOuterQuote{"}`: plain `"text"` becomes `\enquote{text}`
- [textcmds](https://ctan.org/pkg/textcmds) (`\qq`)

## Pros and Cons of the Options

### hardcoded glyphs

- Good, because it needs no package.
- Bad, because it is wrong for any language whose marks differ from English, and nesting must be tracked by hand.
- Bad, because switching the document language means editing every quote.

### csquotes

- Good, because `\enquote{...}` picks the right marks from the active babel/polyglossia language and switches nested marks automatically.
- Good, because it integrates with biblatex for quoted citations.
- Bad, because it is a heavier dependency and some languages need a little configuration.

### csquotes with `\MakeOuterQuote{"}`

- Good, because the source stays readable: `"text"` instead of `\enquote{text}`, and the marks still follow the language.
- Good, because text pasted from elsewhere with plain quotes is typeset correctly without editing.
- Bad, because the quote character is then unavailable for babel shorthands such as `"=` (hyphenation at a dash) and `"a` (umlauts); choose one use of `"`.
- Bad, because an unbalanced quote silently swallows text until the next one.

### textcmds

- Good, because `\qq{...}` is a lightweight alternative when the full csquotes machinery is not needed.
- Bad, because it offers less language integration than csquotes.
