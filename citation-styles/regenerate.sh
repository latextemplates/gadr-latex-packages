#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
# Requires lualatex and biber (TeX Live), pdftoppm (poppler), and convert (ImageMagick).
set -euo pipefail
cd "$(dirname "$0")"
for tex in *.tex; do
  name=${tex%.tex}
  lualatex -interaction=nonstopmode "$tex" > /dev/null
  biber "$name" > /dev/null
  lualatex -interaction=nonstopmode "$tex" > /dev/null
  pdftoppm -r 150 -png -singlefile "$name.pdf" "$name"
  convert "$name.png" -trim -bordercolor white -border 12 "$name.png"
  rm -f "$name".{aux,log,out,pdf,bbl,bcf,blg,run.xml}
done
