#!/usr/bin/env bash
# Regenerates the PNG of every MWE in this directory.
#
# Requires lualatex (TeX Live), pdftoppm (poppler), and plantuml (with Java and Graphviz).
# The Mermaid MWEs additionally need the Mermaid CLI (mmdc) and a local lualatex; without mmdc they are skipped.
# Without a local TeX Live, set LUALATEX to run it in the TeX Live Docker image, e.g.:
#   LUALATEX='docker run --rm -v "$PWD:/workdir" -w /workdir registry.gitlab.com/islandoftex/images/texlive:latest lualatex' ./regenerate.sh
set -euo pipefail
cd "$(dirname "$0")"
LUALATEX=${LUALATEX:-lualatex}

# tikz-uml is not part of TeX Live: fetch it temporarily
fetched_tikzuml=false
if ! kpsewhich tikz-uml.sty > /dev/null 2>&1 && [ ! -f tikz-uml.sty ]; then
  tmp=$(mktemp -d)
  git clone --quiet --depth 1 https://plmlab.math.cnrs.fr/tikzuml/tikzuml.git "$tmp"
  cp "$tmp/tikz-uml.sty" .
  rm -rf "$tmp"
  fetched_tikzuml=true
fi

# The ltMermaid MWEs need the Mermaid CLI and --shell-escape; ltMermaid is part of TeX Live 2026, older TeX Live versions get it temporarily
fetched_ltmermaid=false
if command -v mmdc > /dev/null && ! kpsewhich ltmermaid.sty > /dev/null 2>&1 && [ ! -f ltmermaid.sty ]; then
  curl -sSfL -o ltmermaid.sty https://raw.githubusercontent.com/ryoya9826/ltMermaid/main/ltmermaid.sty
  fetched_ltmermaid=true
fi

for tex in *.tex; do
  name=${tex%.tex}
  if [[ "$name" == *--ltmermaid ]]; then
    if ! command -v mmdc > /dev/null; then
      echo "Skipping $tex: the Mermaid CLI (mmdc) is not installed"
      continue
    fi
    # mmdc must be available to lualatex, thus a local lualatex is used
    lualatex -shell-escape -interaction=nonstopmode "$tex" > /dev/null
    lualatex -shell-escape -interaction=nonstopmode "$tex" > /dev/null
    pdftoppm -r 110 -png -singlefile "$name.pdf" "$name"
    rm -rf "$name.aux" "$name.log" "$name.pdf" mermaid
    continue
  fi
  # two runs: some packages need a second run for the final layout
  eval "$LUALATEX -interaction=nonstopmode \"$tex\"" > /dev/null
  eval "$LUALATEX -interaction=nonstopmode \"$tex\"" > /dev/null
  pdftoppm -r 110 -png -singlefile "$name.pdf" "$name"
  rm -f "$name.aux" "$name.log" "$name.pdf" "$name"-*.mp
done

plantuml -tpng ./*.puml

if [ "$fetched_tikzuml" = true ]; then
  rm tikz-uml.sty
fi
if [ "$fetched_ltmermaid" = true ]; then
  rm ltmermaid.sty
fi
