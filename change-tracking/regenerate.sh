#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
# Requires lualatex and pdflatex (TeX Live), pdftoppm (poppler), and convert (ImageMagick).
set -euo pipefail
cd "$(dirname "$0")"
for tex in *.tex; do
  name=${tex%.tex}
  engine=lualatex
  [ "$name" = pdfmarginpar ] && engine=pdflatex # pdfmarginpar needs pdfTeX's \pdfannot
  $engine -interaction=nonstopmode "$tex" > /dev/null
  $engine -interaction=nonstopmode "$tex" > /dev/null
  pdftoppm -r 150 -png -singlefile "$name.pdf" "$name"
  convert "$name.png" -trim -bordercolor white -border 12 "$name.png"
  rm -f "$name.aux" "$name.log" "$name.out" "$name.pdf" "$name.loc" "$name.soc"
done
