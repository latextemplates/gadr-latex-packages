#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
# Requires lualatex (TeX Live), pdftoppm (poppler), and convert (ImageMagick).
set -euo pipefail
cd "$(dirname "$0")"
for tex in *.tex; do
  name=${tex%.tex}
  lualatex -interaction=nonstopmode "$tex" > /dev/null
  pdftoppm -r 150 -png -singlefile "$name.pdf" "$name-page"
  convert "$name-page.png" -trim -bordercolor white -border 12 "$name.png"
  rm "$name-page.png"
  find . -maxdepth 1 -name "$name.*" ! -name "*.tex" ! -name "*.png" -delete
done
