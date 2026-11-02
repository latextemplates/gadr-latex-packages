# How to number the pages of a thesis

## Context and Problem Statement

A thesis has a front matter (title page, abstract, table of contents, lists of figures and tables) before the first chapter, and often an appendix after the last one.
Books number the front matter with roman numerals and restart with arabic 1 at the first chapter; ISO 7144 ("Documentation — Presentation of theses and similar documents") numbers all pages consecutively with arabic numerals.
Universities prescribe one or the other in their examination or doctoral regulations.
How to number the pages of a thesis?

## Considered Options

- Continuous arabic numbers from the title page on (ISO 7144)
- Roman numerals for the front matter, arabic numbers from 1 for the main matter
- Unnumbered front matter, arabic numbers from 1 for the main matter

All three need no package: the LaTeX kernel provides `\pagenumbering{arabic}`, `\pagenumbering{roman}` and `\pagestyle{empty}`; the book classes (`book`, `scrbook`, `memoir`) provide `\frontmatter` and `\mainmatter`, which switch the numbering and the chapter numbering together.

## Pros and Cons of the Options

### Continuous arabic numbers from the title page on

`\pagenumbering{arabic}` at the start; the title page counts as page 1 and shows no number.

- Good, because ISO 7144 prescribes it for theses, and so do doctoral regulations that follow it (for example the University of Stuttgart).
- Good, because the page number of the PDF viewer equals the printed number, so "go to page 42" and a page reference agree.
- Good, because every page has a unique number, so `\pageref` and `hyperref` need no `plainpages=false` and `pdfpagelabels` workaround.
- Good, because the sum of the pages is the page count.
- Bad, because readers used to books expect roman numerals before the first chapter.
- Bad, because the `titlepage` environment of the standard classes resets the page counter to 1 for one-sided documents, so the page after the title page is numbered 1, too, unless the counter is set by hand.

### Roman numerals for the front matter, arabic numbers from 1 for the main matter

`\frontmatter` before the title page and `\mainmatter` before the first chapter; `\backmatter` before the bibliography and index.

- Good, because this is the convention of printed books (Springer, Wiley) and of many thesis guidelines in the English-speaking world.
- Good, because the front matter can change its length (a longer preface, an added list) without shifting the page numbers of the main matter, which matters when the main matter is referred to before the front matter is final.
- Good, because `\frontmatter` also turns off the chapter numbers, so the abstract and the preface appear in the table of contents without a number.
- Bad, because page numbers are not unique: page 3 exists twice. `hyperref` needs `plainpages=false` and `pdfpagelabels` (both default now) to build correct links, and older `hyperref` versions issued "destination with the same identifier".
- Bad, because the page number of the PDF viewer differs from the printed one by the length of the front matter.
- Bad, because ISO 7144 and regulations following it reject it.

### Unnumbered front matter, arabic numbers from 1 for the main matter

`\pagestyle{empty}` for the front matter, then `\pagestyle{headings}` and `\setcounter{page}{1}` (or `\mainmatter`) at the first chapter.

- Good, because a short front matter (title page, declaration, one-page abstract) needs no numbers that nobody refers to.
- Bad, because the table of contents cannot list the front matter with a page number.
- Bad, because the numbers are not unique and differ from the PDF viewer, as in the previous option.
- Bad, because a long front matter (tables of contents, figures, tables, abbreviations) is hard to navigate on paper.
