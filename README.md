# Homeric language

> *Work in progress: not ready for release.*



## Datasets

For each of the *Iliad*s in the Homer Multitext project archive, we create:

- a corpus of citable tokens
- a corpus of citable syllables, defined phonetically

We map the corpus of phonetic syllables to a corpus of metrical syllables, and coordinate those with metrical scansion provided by `hypotactic.com` (see below).

## Vibe-coded apps


Although not yet in release status, the following apps are already usable:

- `apps/metricreader.html`: read an *Iliad* text with full metrical analysis
- `apps/metricsearch.html`: search  an *Iliad* text with optional metrical constraints


There are also vibe-coded user's guides for each app:

- `apps/guide-viewer.md`: user's guide for metrically aware reader
- `apps/guide-search.md`: user's guide for metrically aware search app

## Source for scansion

Scansion of the *Iliad* is based on the openly available data provided at https://hypotactic.com/use-the-source/

> *I have not yet found information on `hypotactic.com` indicating how to credit the author properly*.


`hypotactic.com` has 24 CSV files organized by book.  Each has a header line with these column labels:

`Line, Text, Length, Word, Foot, Half-line`

The data can actually include as many as 10 comma-delimited columns, however. Here is an example:

`37,"τοξ’,",long,3,3,hemi1,Chryses,newpara,speech,Chryses`


### Formatting and sanitizing scansion data

1. Tested CSV structure of raw files in `source-IliadAllCSV/raw`. Worked on a copy in `source-IliadAllCSV/cleaner`to correct lines with invalid delimited-text format.
2. Ran the script `scripts/cexify.jl` to reformat 24 sources files in `source-IliadAllCSV/cleaner` to a single file using CTS URNs to identify passages; wrote output to `scansion.cex`  
3. Ran the script `scripts/expandreff.jl` to expand data references in `scansion.cex` and wrote results to `scansion-expanded.cex`