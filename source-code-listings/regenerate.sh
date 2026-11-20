#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
# Requires lualatex (TeX Live 2026 with xlistings and code-link; minted needs Python), pdftoppm (poppler), and convert (ImageMagick).
set -euo pipefail
cd "$(dirname "$0")"
for tex in *.tex; do
  name=${tex%.tex}
  lualatex -shell-escape -interaction=nonstopmode "$tex" > /dev/null
  lualatex -shell-escape -interaction=nonstopmode "$tex" > /dev/null
  pdftoppm -r 150 -png -singlefile "$name.pdf" "$name"
  convert "$name.png" -trim -bordercolor white -border 12 "$name.png"
done
find . -maxdepth 1 \( -name '*.aux' -o -name '*.log' -o -name '*.out' -o -name '*.pdf' \) -delete
find . -maxdepth 1 -name '_minted*' -exec rm -r {} +
