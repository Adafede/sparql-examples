# SPARQL examples

A personal collection of SPARQL query examples curated by Adriano Rutz, primarily targeting [QLever Wikidata](https://qlever.dev/api/wikidata), [Wikidata Query Service](https://query.wikidata.org/sparql), and the [Wikidata Scholarly endpoint](https://query-scholarly.wikidata.org/sparql).

Browse the rendered examples with client-side search, keyword filtering, and Mermaid query diagrams at **<https://adafede.github.io/sparql-examples/>**.

## Organization

Queries are stored one per Turtle (`.ttl`) file inside [`examples/`](./examples/) using SHACL, RDFS, and Schema.org annotations:

* [`examples/Chemicals/`](./examples/Chemicals/) — chemical structures, classes, identifiers, SMILES, InChIKeys, physicochemical properties, stereoisomers, and isotopes
* [`examples/Maintenance/`](./examples/Maintenance/) — data-quality, orphan-entity, and statement-completeness queries
* [`examples/Omics/`](./examples/Omics/) — metabolomics and omics dataset queries
* [`examples/Scholarly/`](./examples/Scholarly/) — scholarly literature (`Articles/`) and researcher (`Authors/`) queries
* [`examples/Taxa/`](./examples/Taxa/) — biological taxonomy, name-to-QID lookup, and distribution maps
* [`examples/Varia/`](./examples/Varia/) — miscellaneous Wikidata queries

## Example format

Each `.ttl` file describes a `sh:SPARQLExecutable` with its query text, target endpoint(s), keywords, creator, and license:

```turtle
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix ex: <https://adafede.github.io/sparql-examples/examples/Taxa/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix schema: <https://schema.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .

ex:wd_taxa_name_to_qid a sh:SPARQLExecutable , sh:SPARQLSelectExecutable ;
    rdfs:comment "Taxon name to QID."@en ;
    sh:prefixes _:sparql_examples_prefixes ;
    sh:select """
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
#title: Taxon name to QID
SELECT ?taxon ?taxon_name WHERE {
    VALUES ?taxon_name { "Gentiana lutea" }
    ?taxon wdt:P225 ?taxon_name .
}
""" ;
    schema:target <https://qlever.dev/api/wikidata> ;
    dcterms:license <https://creativecommons.org/publicdomain/zero/1.0/> ;
    schema:keywords "taxa" ;
    dc:creator "Adriano Rutz" .
```

## Quality assurance & artifact generation

Validation and static-page Markdown/RQ/Turtle generation use [SIB SPARQL Examples Utils](https://github.com/sib-swiss/sparql-examples-utils):

```bash
wget -O sparql-examples-utils.jar "https://github.com/sib-swiss/sparql-examples-utils/releases/download/v2.0.24/sparql-examples-utils-2.0.24-uber.jar"

# Validate syntax, SHACL constraints, prefixes, and SERVICE annotations
java -Xss8m -jar sparql-examples-utils.jar test --input-directory=examples/

# Generate Markdown pages (with Mermaid diagrams), .rq files, and concatenated all.ttl
java -Xss8m -jar sparql-examples-utils.jar convert -i examples/ -m
java -Xss8m -jar sparql-examples-utils.jar convert -i examples/ -r
java -Xss8m -jar sparql-examples-utils.jar convert -i examples/ -p all -f ttl > all.ttl
```

## Local GitHub Pages preview

```bash
docker build -t sparql-examples .
docker run --rm -v "$PWD":/srv/jekyll sparql-examples bundler exec jekyll build --watch &
python3 -m http.server 8792 --directory _site
```

Then open `http://localhost:8792/` in a browser.

## License & acknowledgements

* All SPARQL example queries under `examples/` are dedicated to the public domain under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/).
* Surrounding template, layout, and workflow code is licensed under the [MIT License](./LICENSE.md).

This repository is based on the [SIB SPARQL Examples Template](https://github.com/sib-swiss/sparql-examples-template) and [SIB SPARQL Examples Utils](https://github.com/sib-swiss/sparql-examples-utils) developed by the [SIB Swiss Institute of Bioinformatics](https://www.sib.swiss/) (Bolleman *et al.*, *GigaScience*, 2025, DOI: [`10.1093/gigascience/giaf045`](https://doi.org/10.1093/gigascience/giaf045)).
