#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
#
# Requires lualatex (TeX Live), pdftoppm (poppler), and plantuml (with Java and Graphviz).
# Without a local TeX Live, set LUALATEX to run it in the TeX Live Docker image, e.g.:
#   LUALATEX='docker run --rm -v "$PWD:/workdir" -w /workdir registry.gitlab.com/islandoftex/images/texlive:latest lualatex' ./regenerate.sh
set -euo pipefail
cd "$(dirname "$0")"
LUALATEX=${LUALATEX:-lualatex}

for tex in *.tex; do
  name=${tex%.tex}
  # two runs: some packages need a second run for the final layout
  eval "$LUALATEX -interaction=nonstopmode \"$tex\"" > /dev/null
  eval "$LUALATEX -interaction=nonstopmode \"$tex\"" > /dev/null
  pdftoppm -r 110 -png -singlefile "$name.pdf" "$name"
  rm -f "$name.aux" "$name.log" "$name.pdf" "$name"-*.mp
done

plantuml -tpng ./*.puml
