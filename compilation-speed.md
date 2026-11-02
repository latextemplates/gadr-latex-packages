# How to speed up compilation

## Context and Problem Statement

A thesis with many packages, figures and listings takes seconds to minutes per LaTeX run, and `latexmk` runs it several times.
While writing, the author wants to see a change quickly.
How to shorten the time from saving a file to seeing the PDF?

The measurements below are from the English example thesis of [scientific-thesis-template](https://github.com/latextemplates/scientific-thesis-template) (63 pages with LuaLaTeX, 58 with pdfLaTeX), one run of the engine, TeX Live 2026 in the Island of TeX Docker image, warm file cache.

| Variant | Time per run | Notes |
| --- | --- | --- |
| LuaLaTeX | 7.6 s | 12.2 s on the first run of a session: `luaotfload` builds its font database |
| pdfLaTeX | 4.6 s | same document, `newtx` fonts instead of `fontspec` |
| pdfLaTeX, preamble precompiled with `mylatex` or `mylatexformat` | 3.4 s | format file of 14 MB; dumping it takes 1.6 s once |
| LuaLaTeX, preamble precompiled | fails | `mylatexformat`: the dump aborts with `pdf backend: already written content discarded`; `mylatex`: 101 errors while reading the preamble |

The thread [Speeding up LaTeX compilation](https://tex.stackexchange.com/q/8791/9075) collects most of the options below.

## Considered Options

- Precompiled preamble: [`mylatex`](https://ctan.org/pkg/mylatex) or [`mylatexformat`](https://ctan.org/pkg/mylatexformat), or a hand-made format file
- [tex-fast-recompile](https://github.com/user202729/tex-fast-recompile) (not on CTAN)
- Compile only a part of the document: `\includeonly`, [`subfiles`](https://ctan.org/pkg/subfiles)
- Draft modes: `-draftmode` of the engine and the `draft` class option
- Externalize TikZ pictures ([`pgf`](https://ctan.org/pkg/pgf), library `external`)
- Avoid heavy packages and raster images; cache images ([`graphicscache`](https://ctan.org/pkg/graphicscache))
- Less compression of the PDF while drafting
- Fewer and quieter runs: [`latexmk`](https://ctan.org/pkg/latexmk), `-interaction=batchmode`
- An unzipped copy of the engine's format file
- Another engine: pdfLaTeX instead of LuaLaTeX, or [Tectonic](https://tectonic-typesetting.github.io/)

## Pros and Cons of the Options

### Precompiled preamble: `mylatex` or `mylatexformat`

The preamble (everything before `\begin{document}`) is dumped into a format file once; every later run loads the format instead of reading the packages.
[`mylatex`](https://ctan.org/pkg/mylatex) (David Carlisle, in TeX Live; [maintained in `dpctex`](https://github.com/davidcarlisle/dpctex/tree/main/mylatex), last updated 2020 for the hook code of `\begin{document}`): `pdflatex -ini "&pdflatex" mylatex.ltx main` writes `mylatex.fmt`, then `pdflatex "&mylatex" main`.
`mylatexformat` (2011, derived from `mylatex`): `pdflatex -ini -jobname=main "&pdflatex" mylatexformat.ltx """main.tex"""`, then `pdflatex -fmt=main main.tex`; its `\csname endofdump\endcsname` ends the dumped part early.

- Good, because the packages are no longer parsed on every run: 4.6 s became 3.4 s for the example thesis with pdfLaTeX (26 % less), with either package.
- Good, because the document stays unchanged; the format is a build artifact next to the `.aux` files.
- Good, because `mylatex` reads the preamble again from a line containing only `% mylatex`: additions placed after that line take effect without a new dump (verified: a `\typeout` added there runs), which `mylatexformat` has no equivalent for.
- Bad, because it does not work with LuaLaTeX: Lua states and the fonts that `fontspec` loads cannot be dumped, and the dump of the example thesis aborts (`mylatexformat`: the PDF backend refuses; `mylatex`: 101 errors, since it reads the preamble line by line and stumbles over category code changes such as `fancyvrb`'s). Dumping only the first part of the preamble (`\csname endofdump\endcsname` before `fontspec`) produces a format, but a run with it fails on the first line with `attempt to index a nil value (global 'shellesc')`: every Lua module the dumped packages loaded is missing, and the rest cascades. Restoring them by hand per package in `\everyjob` is what [tex.sx 521482](https://tex.stackexchange.com/a/521482/9075) shows for a single package. The same holds for XeLaTeX in many cases.
- Bad, because a run with the format skips the dumped preamble of the `.tex` file: an edited line there is silently ignored (a `\typeout` or a new `\newcommand` added before `\begin{document}` never runs with `mylatexformat`, nor before the `% mylatex` line) until the format is dumped again, and the same holds for a package updated by TeX Live. `latexmk` sees the changed `.tex` file and reruns the engine, but has no rule that rebuilds the format, so the author has to do it by hand or write a custom rule.
- Bad, because the saving is a constant per run (the package loading), so it matters for short documents and fades for long ones; the body is typeset as before.
- Bad, because `mylatexformat` is from 2011 and unmaintained; `mylatex` is the one kept in step with the LaTeX kernel.

### tex-fast-recompile

A Python tool that starts the engine before the file is saved, lets it process the preamble, and continues with the body when the file changes.

- Good, because the PDF appears sooner after saving: the preamble time is spent while the author is still typing.
- Good, because it works with LuaLaTeX and `fontspec`: no format is dumped, the engine process just waits.
- Bad, because it is not on CTAN; it is [installed with `pip` from PyPI or from the repository](https://github.com/user202729/tex-fast-recompile#manual-installation-from-source-github) plus a `.sty` from its repository, so it is a tool of one author's machine, not of the template.
- Bad, because its `latexmk` emulation runs no `biber` ([issue 24](https://github.com/user202729/tex-fast-recompile/issues/24)) and no index tool, does not track changed included files, and may rerun too seldom for references, so it cannot replace the `latexmk` setup of the templates; it is for the edit loop of one file, with a real `latexmk` run before handing in.
- Bad, because the preamble must not read other files that change, and `tikz` externalization has no workaround.

### Compile only a part of the document

- Good, because `\includeonly{chapter2}` in the main file typesets one chapter with the page numbers and references of the others (from their `.aux` files), built into LaTeX.
- Good, because `subfiles` lets a chapter file compile on its own with the preamble of the main file: `latexmk "10 - introduction"` in the chapter directory, no edit of the main file. The templates use this; see [compiling-single-chapters](compiling-single-chapters.md).
- Bad, because cross-chapter references show as `??` and the bibliography is missing in a single chapter; the full document is still needed at the end.

### Draft modes

- Good, because `-draftmode` makes pdfTeX and LuaTeX skip writing the PDF and reading the images; `latexmk` can use it for all but the last run (`$pdflatex = 'lualatex -draftmode %O %S'` is not the default).
- Good, because the `draft` class option replaces images by frames and marks overfull lines, which the templates offer as a comment.
- Bad, because no PDF appears in draft mode, so it only speeds up the intermediate runs; and `draft` changes the output, which has to be switched off again for the final version.

### Externalize TikZ pictures

- Good, because each `tikzpicture` is compiled once into its own PDF and included as an image afterwards (`\usetikzlibrary{external}`, `\tikzexternalize`); a document with many diagrams gains the most.
- Good, because `mode=list and make` lets `make -j` build the pictures in parallel.
- Bad, because it needs `--shell-escape` and a job name per picture; pictures that use macros defined later or `\ref` need care, and `tex-fast-recompile` does not work with it.

### Avoid heavy packages and raster images; cache images

- Good, because `todonotes` loads `tikz`, which the thread names as a "performance Trojan horse": a document without TikZ loses seconds of package loading. The templates offer `pdfcomment` as the lighter alternative; see [todo-package](todo-package.md).
- Good, because vector graphics (PDF) are included faster than large PNG or JPEG files, and `graphicscache` reduces every image once and includes the small copy afterwards; the templates use it, see [image-compression](image-compression.md).
- Bad, because it is a design choice per document, not a switch.

### Less compression of the PDF while drafting

- Good, because `\pdfcompresslevel=0` and `\pdfobjcompresslevel=0` (pdfTeX; `\pdfvariable compresslevel` with LuaTeX) save the time spent on zlib, which can be a third of a run for image-heavy documents; XeLaTeX has `-output-driver='xdvipdfmx -z3'`.
- Bad, because the PDF grows by an order of magnitude, so the lines have to be removed for the final version.
- Bad, because the level is frozen once the first PDF object is written, which `hyperref` and other packages do in the preamble: set after the packages or at `\begin{document}`, the lines have no effect at all; before `\documentclass` they work. For the example thesis (0.5 MB of PDF) the run takes 7.7 s with and without compression, so there is nothing to gain unless the document carries many large images.

### Fewer and quieter runs

- Good, because `latexmk` reruns the engine, `biber` and `makeglossaries` only when their inputs changed; a hand-written "run three times" script wastes runs.
- Good, because `-interaction=batchmode` (or `-quiet` of `latexmk`) saves the terminal output, which is measurable on slow terminals.
- Bad, because `latexmk` still has to run the engine at least once per change; this option limits waste, it does not make a run faster.

### An unzipped copy of the engine's format file

TeX Live stores `lualatex.fmt` and `pdflatex.fmt` compressed; the engine inflates them at every start.
`gunzip < "$(kpsewhich -engine=luahbtex lualatex.fmt)" > lualatexunzipped.fmt` once, then `lualatex '&lualatexunzipped' main.tex` ([tex.sx 708544](https://tex.stackexchange.com/a/708544/9075)).

- Good, because it costs nothing in the document and works with every engine and package.
- Bad, because it relies on an implementation detail of the engines, the copy has to be redone after a TeX Live update, and the saving is a fixed fraction of a second per run, which disappears in a real document: 7.7 s against 7.6 s for the example thesis (the answer measures 0.13 s on a one-line file).
- Bad, because `latexmk` and editors have to be told about the custom format name.

### Another engine

On the bare IEEE paper of the comparison (3 pages, `bibtex`), a full build with `latexmk` (engine, `bibtex`, reruns), warm caches:

| Engine and build tool | Full build | One engine run |
| --- | --- | --- |
| pdfLaTeX + `latexmk` | 0.59 s | 0.17 s |
| XeLaTeX + `latexmk` | 0.83 s | 0.29 s |
| LuaLaTeX + `latexmk` | 1.10 s | 0.42 s |
| Tectonic 0.17 (XeTeX engine, own build loop) | 0.45 s | (4 passes inside) |

- Good, because pdfLaTeX is faster than LuaLaTeX for the same document (4.6 s against 7.6 s for the thesis): no Lua font loader, Type 1 fonts.
- Good, because Tectonic needs no `latexmk`: one command runs the engine and `bibtex` as often as needed, and with its own file lookup the full build is faster than `latexmk` with pdfLaTeX, and almost twice as fast as with XeLaTeX.
- Bad, because the saving is a fraction of a second per build: the body of a long document costs the same in every engine (XeLaTeX needs 4.9 s for the thesis, pdfLaTeX 4.6 s).
- Bad, because Tectonic is not TeX Live: it downloads its own package bundle (97 s on the first run here), so `Texlivefile`, the CI setup and `latexmk` do not apply, `--shell-escape` (`minted`, `gitver`) is off unless `-Z shell-escape` is given, and it stops at every LaTeX error that `latexmk` would run through. The example thesis did not compile with it: `microtype` needs `expansion=false` and no `\DisableLigatures` under XeTeX, and then an option clash of `xcolor` with the bundle's package versions stopped the run.
- Bad, because the templates chose LuaLaTeX for correct ligatures and OpenType fonts (ADR-0010 and ADR-0013 of the generator), so switching the engine trades typography for speed; and XeTeX, the engine behind Tectonic, is maintained but no longer developed.
