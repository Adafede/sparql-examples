#!/usr/bin/env bash
set -euo pipefail

# Fix generated URLs
find examples/ -name "*.md" -exec sed -i '' 's|/pages/adafede/sparql-examples/|/sparql-examples/|g' {} +

# Convert md to qmd with proper fenced blocks
find examples/ -name "*.md" | while read -r f; do
  qmd="${f%.md}.qmd"
  sed 's/^```mermaid$/```{mermaid}/; s/^```sparql$/```sparql/' "$f" > "$qmd"
  rm "$f"
done

# Fix remaining .md references to .qmd
find examples/ -name "*.qmd" -exec sed -i '' 's/\.md)/.qmd)/g; s/\.md#/.qmd#/g' {} +
