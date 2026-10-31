# How to compile parts of a document

## Context and Problem Statement

A long document (thesis, book) is split into one file per chapter.
Compiling the whole document takes minutes, while the author works on one chapter and wants to see only that.
How to compile a single chapter with the preamble of the document?

## Considered Options

- [subfiles](https://ctan.org/pkg/subfiles)
- `\includeonly` in the main file
- [standalone](https://ctan.org/pkg/standalone)
- [docmute](https://ctan.org/pkg/docmute)

## Pros and Cons of the Options

### subfiles

- Good, because a chapter file compiles on its own: `\documentclass[../main]{subfiles}` loads the preamble of the main file, and `\begin{document}`/`\end{document}` wrap the chapter.
- Good, because the main file includes the chapter as before: `\subfile` works like `\input`, `\subfileinclude` like `\include`.
- Good, because it works with any engine and any class; no preamble has to be duplicated.
- Bad, because three boilerplate lines in every chapter file name the main file; a project with several main files has to pick one.
- Bad, because the chapter is read through the import path of the [import](https://ctan.org/pkg/import) package, which confuses packages that resolve file names themselves (e.g., minted prepends the path once more), and a chapter compiled in its directory finds the files of the main directory only with `TEXINPUTS` or `\subfix`.
- Bad, because a chapter compiled alone shows `??` for references to other chapters and prints no bibliography unless the chapter calls `\printbibliography` itself.

### `\includeonly`

- Good, because it is built into LaTeX: `\includeonly{chapter2}` in the main file compiles only that chapter, and the `.aux` files of the others keep their page numbers and references.
- Good, because the chapter files stay untouched.
- Bad, because the main file has to be edited for every switch (or a second main file kept), and the front matter and the table of contents are still built every time.
- Bad, because the chapters have to be included with `\include`, which starts every chapter on a new page and allows no nesting.

### standalone

- Good, because a file with `\documentclass{standalone}` compiles alone and is included unchanged into the main document.
- Good, because it is made for figures and tables: the output is cropped to the content.
- Bad, because the preamble of the standalone file is its own: the packages and settings of the main document have to be repeated (or put into a shared file), so the chapter does not look as in the document.
- Bad, because it is meant for figures and TikZ pictures, not for running text with page breaks.

### docmute

- Good, because `\usepackage{docmute}` in the main file makes `\input` ignore the preamble of the input file, so a chapter with a full preamble compiles alone and is included as is.
- Bad, because every chapter carries its own full preamble, which drifts from the main one.
- Bad, because the package has not been updated since 2012.
