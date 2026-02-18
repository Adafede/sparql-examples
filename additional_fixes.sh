#!/usr/bin/env bash
set -euo pipefail

# Cross-platform sed -i
sedi() {
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Fix generated URLs
find examples/ -name "*.md" | while read -r f; do
  sedi 's|/pages/adafede/sparql-examples/|/sparql-examples/|g' "$f"
done

# Convert md to qmd with proper fenced blocks
find examples/ -name "*.md" | while read -r f; do
  qmd="${f%.md}.qmd"
  sed 's/^```mermaid$/```{mermaid}/; s/^```sparql$/```sparql/' "$f" > "$qmd"
  rm "$f"
done

# Fix remaining .md references to .qmd
find examples/ -name "*.qmd" | while read -r f; do
  sedi 's/\.md)/.qmd)/g; s/\.md#/.qmd#/g' "$f"
done