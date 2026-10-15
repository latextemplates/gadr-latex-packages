# How to draw UML diagrams

## Context and Problem Statement

Theses and papers contain UML diagrams: class diagrams, sequence diagrams,
component diagrams. They should be written as text next to the LaTeX source
(diffable, no image files to keep in sync) and use the fonts of the document.
Ideally, they compile without extra tools and without `--shell-escape`, so that
the template works out of the box locally, in Docker, on Overleaf, and in CI.
How should UML diagrams be drawn?

## Considered Options

- [PlantUML](https://plantuml.com/) via the [plantuml](https://ctan.org/pkg/plantuml) package
- [MetaUML](https://ctan.org/pkg/metauml) (MetaPost)
- [pst-uml](https://ctan.org/pkg/pst-uml) (PSTricks)
- [pgf-umlcd](https://ctan.org/pkg/pgf-umlcd) and [pgf-umlsd](https://ctan.org/pkg/pgf-umlsd) (TikZ)
- [tikz-uml](https://perso.ensta-paris.fr/~kielbasi/tikzuml/) (TikZ, not part of TeX Live)
- [uml](https://ctan.org/pkg/uml) (PSTricks)
- drawing with an external tool (e.g., draw.io) and including the PDF

## Comparison

The minimal working examples (MWEs) are the diagrams of the examples of the [plantuml package](https://github.com/koppor/plantuml).
Each diagram is rebuilt with every package that supports the diagram type.
Sources and images are in [uml-diagrams/](uml-diagrams/).
All LaTeX sources were compiled with LuaLaTeX of TeX Live 2026 *without* `--shell-escape`; the PlantUML images were rendered by PlantUML 1.2026.8.

| MWE | PlantUML (reference) | MetaUML | pgf-umlcd / pgf-umlsd | pst-uml |
| -- | -- | -- | -- | -- |
| Sequence | ![](uml-diagrams/sequence--plantuml.png) | not supported | ![](uml-diagrams/sequence--pgf-umlsd.png) | not supported |
| Class relations | ![](uml-diagrams/class-relations--plantuml.png) | ![](uml-diagrams/class-relations--metauml.png) | ![](uml-diagrams/class-relations--pgf-umlcd.png) | ![](uml-diagrams/class-relations--pst-uml.png) |
| Class visibility | ![](uml-diagrams/class-visibility--plantuml.png) | ![](uml-diagrams/class-visibility--metauml.png) | ![](uml-diagrams/class-visibility--pgf-umlcd.png) | ![](uml-diagrams/class-visibility--pst-uml.png) |
| Components | ![](uml-diagrams/component--plantuml.png) | ![](uml-diagrams/component--metauml.png) | not supported | not supported |

| | LuaLaTeX | pdfLaTeX |
| -- | -- | -- |
| PlantUML | `--shell-escape`, Java, PlantUML | `--shell-escape`, Java, PlantUML |
| MetaUML | built in ([luamplib](https://ctan.org/pkg/luamplib)) | `--shell-escape` ([gmp](https://ctan.org/pkg/gmp)) |
| pgf-umlcd / pgf-umlsd | works | works |
| pst-uml | built in ([luapstricks](https://ctan.org/pkg/luapstricks)) | `--shell-escape` ([auto-pst-pdf](https://ctan.org/pkg/auto-pst-pdf)) |

## Customization

### Sans-serif font

All packages can typeset the diagrams in a sans-serif font:

| MetaUML | pgf-umlcd / pgf-umlsd | pst-uml |
| -- | -- | -- |
| ![](uml-diagrams/class-relations--sans--metauml.png) | ![](uml-diagrams/class-relations--sans--pgf-umlcd.png) ![](uml-diagrams/sequence--sans--pgf-umlsd.png) | ![](uml-diagrams/class-relations--sans--pst-uml.png) |
| `\mplibtextextlabel{enable}` lets TeX typeset all MetaUML labels in the current font; `\sffamily` before `mplibcode` switches to sans serif. Without it, MetaUML uses Times (`metauml_defaultFont`). | `\begin{tikzpicture}[font=\sffamily]`; `\sffamily` before `sequencediagram` | `\renewcommand{\familydefault}{\sfdefault}`, because `\umlClass` resets the class name to `\normalfont`; the members stay in typewriter font. |

### Hiding the members of a class

- MetaUML: `EClass.Car(iClassNameOnly)("Car")()();` (or `ClassName.Car("Car");`). MetaUML still draws the lines of the (empty) compartments; redefining `Class_paintSkin` omits them (see [class-relations--sans--metauml.tex](uml-diagrams/class-relations--sans--metauml.tex)). A small empty space below the name remains.
- pgf-umlcd: an empty `class` environment still shows the empty compartments.
- pst-uml: `\umlClass{Car}{}` shows the name only.

## Pros and Cons of the Options

### PlantUML

- Good, because the diagrams are written in a compact text notation and laid out automatically.
- Good, because it supports all diagram types of UML (and more, e.g., mind maps).
- Bad, because it needs Java, PlantUML (and Graphviz for some diagrams), and `--shell-escape`.
- Bad, because neither the Docker image of TeX Live nor Overleaf ship PlantUML.

### MetaUML

- Good, because LuaLaTeX runs MetaPost itself ([luamplib](https://ctan.org/pkg/luamplib), `\begin{mplibcode}`): no external tool, no `--shell-escape`.
- Good, because the result is closest to PlantUML: correct UML arrow heads (triangle, diamonds) and labels on the lines.
- Good, because with `\mplibtextextlabel{enable}` the labels are typeset by TeX in the font of the document.
- Good, because it supports class, package, component (with provided and required interfaces), use case, activity, and state diagrams.
- Neutral, because the layout is given by relations between the objects (e.g., `leftToRight(90)(A, B)`: 90 PostScript points between the boxes), not by coordinates.
- Neutral, because hiding the members of a class (`iClassNameOnly`) leaves the compartment lines unless `Class_paintSkin` is redefined.
- Bad, because it does not support sequence diagrams.
- Bad, because with pdfLaTeX it needs [gmp](https://ctan.org/pkg/gmp) and `--shell-escape` (without it, `gmp` shows a placeholder).
- Bad, because MetaPost syntax is unfamiliar to most LaTeX users (e.g., `c1` is the array element `c[1]` and cannot be used as name).

### pgf-umlcd and pgf-umlsd

- Good, because they are pure TikZ: they work with every engine, without `--shell-escape`.
- Good, because pgf-umlsd is the only package here that draws sequence diagrams.
- Neutral, because the default colors (yellow boxes, red lines) need to be changed for a plain look.
- Bad, because pgf-umlcd places association names at the ends of the lines (role names), not in the middle.
- Bad, because the boxes are placed by coordinates and have a fixed default width, so boxes overlap unless widths are set (e.g., `text width=1.6cm`).
- Bad, because pgf-umlcd does not support component diagrams.

### pst-uml

- Good, because LuaLaTeX runs PSTricks itself since [luapstricks](https://ctan.org/pkg/luapstricks) (TeX Live 2022): no `--shell-escape`. XeLaTeX supports PSTricks natively.
- Good, because the UML arrow heads (inheritance, aggregation, composition) are available as icons on the connections (`\ncputicon{umlCompos}`).
- Neutral, because the boxes are placed by coordinates (`\rput`) and connected via [pst-node](https://ctan.org/pkg/pst-node) (`\rnode`, `\ncline`).
- Bad, because it supports only class, use case, and state diagrams; no sequence and component diagrams.
- Bad, because the documentation is in French and the package (version 0.83) is no longer developed.
- Bad, because pdfLaTeX cannot run PSTricks: it needs a workaround (see below) and `--shell-escape`.

#### Running PSTricks with pdfLaTeX: pst-pdf versus pdftricks

Both run `latex`, `dvips`, and `ps2pdf` on the PSTricks pictures and include the resulting PDF.

- [pst-pdf](https://ctan.org/pkg/pst-pdf) with [auto-pst-pdf](https://ctan.org/pkg/auto-pst-pdf): Good, because `auto-pst-pdf` runs the extra steps automatically (with `--shell-escape`); it is the common way.
- [pdftricks](https://ctan.org/pkg/pdftricks): Bad, because it needs the pictures in special environments and offers nothing beyond `pst-pdf`.
- Both are not needed with LuaLaTeX (luapstricks) or XeLaTeX.

### tikz-uml

- Good, because it is pure TikZ and covers class, use case, state, component, and sequence diagrams.
- Bad, because it is not part of TeX Live; it has to be added, e.g., as git submodule (which Overleaf does not fetch).

### uml

- Bad, because it is based on PSTricks (same engine restrictions as pst-uml) and no longer developed.
- Not tested.

### External tool

- Good, because any diagram type and layout is possible.
- Bad, because the diagram is a binary file that is not diffable and easily gets out of sync with the text.
- Bad, because the fonts of the diagram differ from the document.

## More Information

The MWE sources compile with `lualatex <file>.tex`; the PlantUML sources with `plantuml -tpng <file>.puml`.
The images are rendered with `pdftoppm -r 110 -png -singlefile`.
