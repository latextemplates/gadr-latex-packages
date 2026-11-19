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
  # A list of TODOs can end up on a page of its own: stack all pages
  pdftoppm -r 150 -png "$name.pdf" "$name-page"
  convert "$name"-page-*.png -trim -bordercolor white -border 12 -append "$name.png"
  rm -f "$name"-page-*.png
  find . -maxdepth 1 -name "$name.*" ! -name "*.tex" ! -name "*.png" -delete
done
