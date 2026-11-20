#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
# Requires lualatex and pdflatex (TeX Live), pdftoppm (poppler), and convert (ImageMagick).
set -euo pipefail
cd "$(dirname "$0")"
for tex in *.tex; do
  name=${tex%.tex}
  engine=lualatex
  # three runs: nicematrix computes the width of X columns from the .aux file of the previous run
  for run in 1 2 3; do
    $engine -interaction=nonstopmode "$tex" > /dev/null
  done
  # One image per page: a list of TODOs can end up on a page of its own (<name>-2.png)
  pdftoppm -r 150 -png "$name.pdf" "$name-page"
  i=1
  for page in "$name"-page-*.png; do
    out="$name.png"
    [ "$i" -gt 1 ] && out="$name-$i.png"
    convert "$page" -trim -bordercolor white -border 12 "$out"
    rm "$page"
    i=$((i + 1))
  done
  find . -maxdepth 1 -name "$name.*" ! -name "*.tex" ! -name "*.png" -delete
done
