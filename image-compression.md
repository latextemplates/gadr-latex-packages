# How to shrink images in the PDF

## Context and Problem Statement

Photos and screenshots are embedded in the PDF as they are. A document with many high-resolution images grows to tens of megabytes, which upload limits and e-mail reject.
How to shrink the images in the PDF?

## Considered Options

- [`graphicscache`](https://ctan.org/pkg/graphicscache)
- downsample the image files before including them (ImageMagick, Ghostscript)
- post-process the finished PDF with Ghostscript (`-dPDFSETTINGS=/ebook`)
- `\pdfcompresslevel` and `\pdfobjcompresslevel`

## Pros and Cons of the Options

### `graphicscache`

- Good, because the sources stay untouched: each `\includegraphics` is re-encoded once by Ghostscript and the result is cached, so later runs cost nothing.
- Good, because it is lossless with `compress=flat` and downsamples only above a resolution limit (300 dpi by default).
- Bad, because it needs shell escape, an external `pdflatex` and Ghostscript on the machine.
- Bad, because `compress=flat` is broken as shipped: it passes the filter name "FlatEncode" to Ghostscript, which expects `FlateEncode`; a one-line redefinition after loading fixes it ([xqms/graphicscache#30](https://github.com/xqms/graphicscache/issues/30)).
- Bad, because it parses the `\includegraphics` options itself and rejects the `alt` key of graphicx, which the markdown package sets ([xqms/graphicscache#29](https://github.com/xqms/graphicscache/issues/29)).

### downsample the image files before including them

- Good, because it needs nothing in the document.
- Bad, because the author has to repeat it for every new image and keeps two copies of each.

### post-process the finished PDF with Ghostscript

- Good, because one command shrinks everything, including vector graphics.
- Bad, because it is an extra step after every build, and the output loses PDF metadata and hyperlinks easily.

### `\pdfcompresslevel` and `\pdfobjcompresslevel`

- Good, because it is built into pdfTeX and LuaTeX.
- Bad, because it compresses only the content streams, not the already compressed images, so it gains nothing for photos.
