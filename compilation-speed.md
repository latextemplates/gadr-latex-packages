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
| pdfLaTeX, preamble precompiled with `mylatexformat` | 3.4 s | format file of 14 MB; dumping it takes 1.6 s once |
| LuaLaTeX, preamble precompiled with `mylatexformat` | fails | the dump aborts with `pdf backend: already written content discarded` |

The thread [Speeding up LaTeX compilation](https://tex.stackexchange.com/q/8791/9075) collects most of the options below.

## Considered Options

- Precompiled preamble: [`mylatexformat`](https://ctan.org/pkg/mylatexformat), or a hand-made format file
- [tex-fast-recompile](https://github.com/user202729/tex-fast-recompile) (not on CTAN)
- Compile only a part of the document: `\includeonly`, [`subfiles`](https://ctan.org/pkg/subfiles)
- Draft modes: `-draftmode` of the engine and the `draft` class option
- Externalize TikZ pictures ([`pgf`](https://ctan.org/pkg/pgf), library `external`)
- Avoid heavy packages and raster images; cache images ([`graphicscache`](https://ctan.org/pkg/graphicscache))
- Less compression of the PDF while drafting
- Fewer and quieter runs: [`latexmk`](https://ctan.org/pkg/latexmk), `-interaction=batchmode`
- Another engine: pdfLaTeX instead of LuaLaTeX, or [Tectonic](https://tectonic-typesetting.github.io/)

## Pros and Cons of the Options

### Precompiled preamble: `mylatexformat`

The preamble (everything before `\begin{document}`, or before `\csname endofdump\endcsname`) is dumped into a format file once: `pdflatex -ini -jobname=main "&pdflatex" mylatexformat.ltx """main.tex"""`.
Every later run loads the format instead of reading the packages: `pdflatex -fmt=main main.tex`.

- Good, because the packages are no longer parsed on every run: 4.6 s became 3.4 s for the example thesis with pdfLaTeX (26 % less).
- Good, because the document stays unchanged; the format is a build artifact next to the `.aux` files.
- Bad, because it does not work with LuaLaTeX: Lua states and the fonts that `fontspec` loads cannot be dumped, and the dump of the example thesis aborts. The same holds for XeLaTeX in many cases ([tex.sx 521482](https://tex.stackexchange.com/a/521482/9075) shows the hand work needed per package).
- Bad, because a run with the format skips the preamble of the `.tex` file altogether: an edited preamble is silently ignored (a `\typeout` or a new `\newcommand` added before `\begin{document}` never runs) until the format is dumped again, and the same holds for a package updated by TeX Live. `latexmk` sees the changed `.tex` file and reruns the engine, but has no rule that rebuilds the format, so the author has to do it by hand or write a custom rule.
- Bad, because the saving is a constant per run (the package loading), so it matters for short documents and fades for long ones; the body is typeset as before.
- Bad, because the package is from 2011; it still works, but nobody maintains it.

### tex-fast-recompile

A Python tool that starts the engine before the file is saved, lets it process the preamble, and continues with the body when the file changes.

- Good, because the PDF appears sooner after saving: the preamble time is spent while the author is still typing.
- Good, because it works with LuaLaTeX and `fontspec`: no format is dumped, the engine process just waits.
- Bad, because it is not on CTAN; it is installed with `pip` plus a `.sty` from its repository, so it is a tool of one author's machine, not of the template.
- Bad, because its `latexmk` emulation runs no `biber` and no index tool, does not track changed included files, and may rerun too seldom for references, so it cannot replace the `latexmk` setup of the templates; it is for the edit loop of one file, with a real `latexmk` run before handing in.
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

### Fewer and quieter runs

- Good, because `latexmk` reruns the engine, `biber` and `makeglossaries` only when their inputs changed; a hand-written "run three times" script wastes runs.
- Good, because `-interaction=batchmode` (or `-quiet` of `latexmk`) saves the terminal output, which is measurable on slow terminals.
- Bad, because `latexmk` still has to run the engine at least once per change; this option limits waste, it does not make a run faster.

### Another engine

- Good, because pdfLaTeX is faster than LuaLaTeX for the same document (4.6 s against 7.6 s here): no Lua font loader, Type 1 fonts.
- Good, because Tectonic bundles XeTeX with its own file lookup and is reported faster than XeLaTeX.
- Bad, because the templates chose LuaLaTeX for correct ligatures and OpenType fonts (ADR-0010 and ADR-0013 of the generator), so switching the engine trades typography for speed; and Tectonic is not TeX Live, so `Texlivefile`, `latexmk` and the CI setup do not apply.
