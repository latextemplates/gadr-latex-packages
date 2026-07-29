# Contributing to gadr-latex-packages

We welcome contributions to this repository and encourage you to create a fork, clone, **create a new branch** (such as `fix-for-issue-121`), **work on that new branch — not on the default branch**, and create a pull request.
Be sure to create a **separate branch** for each improvement you implement.
Take a look at GitHub's [help documentation](https://docs.github.com/en/pull-requests) for a detailed explanation and at the [Feature Branch Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) for the idea behind this kind of development.

Alternatively, you can just use the edit button of a single file in the web browser.

This repository collects **problem-space ADRs** ([GADR](https://adr.github.io/gadr/), in [MADR](https://adr.github.io/madr/) format) that record *why* a LaTeX package was chosen for a problem: *Context and Problem Statement* → *Considered Options* → *Pros and Cons*, one file per problem.
Add a new decision as a new file, and keep it in sync with the showcased packages in [latex-snippets](https://github.com/latextemplates/latex-snippets).

## This repository is not generated

Most LaTeX templates of the [latextemplates](https://github.com/latextemplates) organization are **generated** from the micro-templates of the [LaTeX Template Generator](https://github.com/latextemplates/generator-latex-template) — see [How the templates are generated](https://github.com/latextemplates/generator-latex-template/blob/main/CONTRIBUTING.md#how-the-templates-are-generated).
This repository here is **standalone**: improvements are contributed directly, right here.

If your improvement concerns one of the generated templates (`acm-enhanced`, `ieee-enhanced`, `lncs-enhanced`, `scientific-thesis-template`, `uni-stuttgart-dissertation-template`, `markdown-latex-quickstart`), please open your pull request at [generator-latex-template](https://github.com/latextemplates/generator-latex-template) instead — changes made in those repositories are overwritten with the next regeneration.

## Rights

By contributing, you agree that your contribution is made available under [CC0 1.0](LICENSE).

## Create a pull request

Create a pull request on GitHub.
For text inspirations, consider [How to write the perfect pull request](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/).

You can add the prefix `[WIP]` to indicate that the pull request is not yet complete, but you want to discuss something or inform about the current state of affairs.
