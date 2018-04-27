# How to mark TODOs

## Context and Problem Statement

When creating a document, TODOs have to be marked.
How to mark TODO in LaTeX documents?

## Considered Options

* [pdfcomment](https://ctan.org/pkg/pdfcomment)
* [pdfmarginpar](https://ctan.org/pkg/pdfmarginpar)

## Pros and Cons of the Option

### pdfcomment

Needs some configuration:

```
\newcommand{\commentontext}[2]{\colorbox{yellow!60}{#1}\pdfcomment[color={0.234 0.867 0.211},hoffset=-6pt,voffset=10pt,opacity=0.5]{#2}}
\newcommand{\commentatside}[1]{\pdfcomment[color={0.045 0.278 0.643},icon=Note]{#1}}
```

- Good, because uses PDF features
- Good, because highliting of words is not supported

### pdfmarginpar

- Good, because uses PDF features
- Bad, because development stopped.
  Reasons were: 
  a) acrobat reader does not allow editing comments made by pdfcomment
  b) ideas were incorporated at pdfcomment
- Bad, because highliting of words is not supported
- Bad, because uses GPL as license
