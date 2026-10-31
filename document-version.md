# How to show the document version

## Context and Problem Statement

A PDF handed to a reviewer has to say which state of the sources it was built from, so remarks can be matched to a commit.
How to put the version from git into the document?

## Considered Options

- [`gitver`](https://ctan.org/pkg/gitver)
- [`gitinfo2`](https://ctan.org/pkg/gitinfo2)
- [`gitinfo-lua`](https://ctan.org/pkg/gitinfo-lua)
- [`gitfile-info`](https://ctan.org/pkg/gitfile-info)
- [`vc`](https://ctan.org/pkg/vc)

## Pros and Cons of the Options

### `gitver`

- Good, because `\gitVer` (the commit, `-dirty` when there are uncommitted changes) and `\versionBox` (commit and build time) come from one `git describe` call at build time: no hooks, no scripts, no extra files.
- Good, because it works with pdfLaTeX and LuaLaTeX alike, and on Overleaf (no git) it prints "CLSI" instead of failing.
- Good, because the options `nopdfinfo` and `noheader` keep it from touching the PDF metadata and the page headers.
- Bad, because it needs `--shell-escape` and git on the machine.
- Bad, because it only knows the commit, not the author, date or branch.

### `gitinfo2`

- Good, because it offers the full set of fields (commit, author, date, branch, tags) and a `\gitMark` for the footer.
- Good, because it needs no shell escape: the data is read from a file.
- Bad, because that file is written by git hooks (`post-commit`, `post-checkout`, ...) which every author has to install; without them the data is stale or missing.
- Bad, because it treats the whole repository as one: the version is that of the last commit, not of the file at hand.

### `gitinfo-lua`

- Good, because it reads git directly from Lua, with no hooks and no shell escape beyond what LuaTeX allows.
- Good, because it offers commits, authors, dates and tags, even for single files.
- Bad, because it is LuaLaTeX only.

### `gitfile-info`

- Good, because it gives the version and date of each input file, not only of the repository.
- Bad, because it needs Python and git hooks to be installed by every author.

### `vc`

- Good, because it supports git, Subversion and Bazaar through one interface.
- Bad, because the version is written by a shell script that has to be run before each build (via `\write18` or a Makefile), and the git script needs a Unix shell.
- Bad, because being general, it needs more setup than a git-only package.
