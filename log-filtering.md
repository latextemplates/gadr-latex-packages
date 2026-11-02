# How to find the relevant messages in a LaTeX log

## Context and Problem Statement

A LaTeX run writes thousands of lines: every loaded file, font, and page, with the warnings in between.
The log of the thesis template (58 pages, LuaLaTeX) has 4365 lines; the warnings in it that call for a change in the source fit on one screen.
How to see these messages without reading the whole log, and without hiding anything a tool or a reviewer needs?

## Considered Options

- read the log or the terminal output
- `-interaction=batchmode` or `latexmk -silent`
- [`texfot`](https://ctan.org/pkg/texfot)
- [`texlogsieve`](https://ctan.org/pkg/texlogsieve)
- [`texloganalyser`](https://ctan.org/pkg/texloganalyser)
- the [`silence`](https://ctan.org/pkg/silence) package
- the log parser of the editor (TeXstudio, LaTeX Workshop, Overleaf)

## Pros and Cons of the Options

Measured on the thesis template (`main-english.tex`, LuaLaTeX, TeX Live 2026):

| Option | Lines shown | What is left |
| -- | -- | -- |
| log file | 4365 | everything |
| `texfot lualatex main-english.tex` | 97 | warnings and errors, in the order of the run |
| `texlogsieve < main-english.log` | 169 | warnings grouped by file and page, then a summary |

### Read the log or the terminal output

- Good, because nothing is hidden and every tool reads the same file.
- Bad, because the relevant lines are between thousands of file and font lines, and TeX wraps lines at 79 characters, so a message or a file name is often cut in two.

### `-interaction=batchmode` or `latexmk -silent`

- Good, because the terminal stays quiet and the run never stops for input; the log file is complete regardless.
- Bad, because it only moves the problem: the log file still has to be read.

### `texfot`

- Good, because it is one Perl script (public domain, Karl Berry, in TeX Live) that wraps the engine call: `texfot lualatex main.tex` prints only the lines that probably deserve a change in the source, 97 instead of 4365 here.
- Good, because it works with every engine and format and keeps the order of the run.
- Bad, because it reads the terminal output, not the log: it has to run the engine itself, so it does not fit into a `latexmk` setup except as `-pdflatex="texfot lualatex %O %S"`.
- Bad, because a wrapped message is cut after 79 characters and a repeated warning (hyperref printed "Token not allowed in a PDF string" eleven times) is repeated.

### `texlogsieve`

- Good, because it reads the log file (or a pipe) after the run, so it fits any build setup: `latexmk main.tex; texlogsieve main.log`, in a Makefile target, or in a CI step summary.
- Good, because it unwraps the 79-character lines, keeps multi-line messages together, groups them by file and page, collapses repetitions, and ends with a summary of undefined references, citations, and bad boxes.
- Good, because it is configurable without touching the document: `--silence-package`, `--silence-string`, `--minlevel`, and a `texlogsieverc` file in the project.
- Bad, because the grouped report is longer than texfot's (169 lines here) and starts with `INFO` lines of packages (Lua module registrations, `new hooks used!!`), which need a `texlogsieverc` to go away.
- Bad, because its log parser can trip over an unusual line (a parsing error near line 3885 of this log, after which the rest is skipped).
- Bad, because it is LaTeX only (no ConTeXt or plain TeX) and GPL, which matters only when it is shipped with something.

### `texloganalyser`

- Good, because it is a small Perl script in TeX Live that answers one question at a time (bad boxes, fonts, end of the log) through flags.
- Bad, because it does not filter the warnings themselves; it selects categories, so it answers "how many bad boxes" rather than "what do I have to fix".

### The `silence` package

- Good, because a warning filtered with `\WarningFilter{hyperref}{Token not allowed}` disappears from the terminal, the log, and every tool, without any tool in the loop.
- Good, because the filtered messages can be saved to a file (`save` option) for later reference.
- Bad, because it hides the message at the source: the editor's log parser, the CI job, `latexmk`, and a reviewer all see a clean log, including the one warning that was not meant to be filtered. A filter is written once and keeps hiding after the document changed.
- Bad, because it filters by the start of the message text, so a filter for one package's warning silences all of that package's warnings that start the same way.
- Bad, because it patches the LaTeX kernel's message commands (`\PackageWarning` and friends); the package is from 2012 (version 1.5b, maintainer change in 2012), and the kernel has changed its message commands since, so it is untested with current packages.

### The log parser of the editor

- Good, because TeXstudio, VS Code with LaTeX Workshop, and Overleaf parse the log and show warnings and errors with a link to the source line, which no command-line tool does.
- Bad, because each parser has its own rules and gaps (wrapped file names, multi-line messages), and the view is gone on the command line and in CI.

## Decision Outcome

Do not filter at the source: `silence` hides messages from every reader at once.
Filter when reading: `texlogsieve` on the log file after the run, since it fits `latexmk`, a Makefile target (`make log`), and a CI step summary, and its project-level `texlogsieverc` records which messages are known noise.
`texfot` is the lighter choice for an interactive run outside `latexmk`.
A warning that is known noise is silenced in the tool's configuration, where it is visible, not in the document.

References: [scientific-thesis-template#68](https://github.com/latextemplates/scientific-thesis-template/issues/68), [scientific-thesis-template#23](https://github.com/latextemplates/scientific-thesis-template/issues/23).
