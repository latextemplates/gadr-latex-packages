# Conventions for this repository

This repository holds problem-space ADRs ([GADR](https://adr.github.io/gadr/)) in [MADR](https://adr.github.io/madr/) format: one file per problem, *Context and Problem Statement* → *Considered Options* → *Pros and Cons of the Options*.
It records **why** a package fits a problem; the decision which package the latextemplates use lives in the [decision records of the template generator](https://github.com/latextemplates/generator-latex-template/tree/main/docs/decisions), which link the GADR here.

## Writing

- Package, class and tool names are code: `` `biblatex` ``, `` `biber` ``, `` `IEEEtran` ``. This holds in prose, in headings and in links (`` [`siunitx`](https://ctan.org/pkg/siunitx) ``).
  Reason: vale spell-checks prose, and code spans are skipped. Real words that the dictionary lacks (Turabian, Ghostscript, PSTricks, ...) go into `.vale/styles/config/vocabularies/Docs/accept.txt`; a package name never does, it gets backticks instead. A term there is also case-enforced by vale, so file names that contain it (`biblatex-apa.tex`) have to be code too.
- Each option in *Considered Options* links its CTAN page; a tool that is not on CTAN links its home page and says so.
- One sentence per line.
- Pros and cons start with "Good, because" or "Bad, because" and name the concrete command, option or limitation.
- An image alt text describes the output ("Output in APA style"), not the package.

## Example renders

An ADR that compares visible output has a directory of the same name (e.g. `citation-styles/`) with one minimal `.tex` per option, the rendered `.png`, and a `regenerate.sh` that rebuilds every PNG (LaTeX, `pdftoppm`, `convert`).
Keep the examples minimal and identical except for the option under comparison, so the renders differ only in what the ADR discusses.
Each option section shows its image and links its source: `![Output in APA style](citation-styles/biblatex-apa.png)` followed by `Source: [`biblatex-apa.tex`](citation-styles/biblatex-apa.tex)`.

## Checks

CI runs markdownlint, textlint, typos and vale on every Markdown file; run them locally before pushing where possible.
Content changes go through a branch and a pull request; direct pushes to `main` are for CI configuration only.
