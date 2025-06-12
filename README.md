# homericlanguage



## Source for scansion

Scansion of the *Iliad* is based on the openly available data provided here:

https://hypotactic.com/use-the-source/

> I have not yet found information on the site to credit the author properly.


The 24 CSV files are organized by book.  Each has a header line with these column labels:

`Line, Text, Length, Word, Foot, Half-line`

The data can actually include as many as 10 comma-delimited columns, however. Here is an example:

`37,"τοξ’,",long,3,3,hemi1,Chryses,newpara,speech,Chryses`


## Data preparation

1. Tested CSV structure of raw files in `source-IliadAllCSV/raw`. Manually corrected lines with invalid delimited-text format in `source-IliadAllCSV/cleaner`.
2. Ran the script `scripts/cexify.jl` to reformat 24 sources files in `source-IliadAllCSV/cleaner` to a single file using CTS URNs to identify passages in `scansion.cex`  
3. Ran the script `scripts/expandreff.jl` to expand data references in `scansion.cex` and wrote results so `scansion-expanded.cex`