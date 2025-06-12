I want to create a single-page web app using HTML and Javascript to visualize data about the metrical scansion of the *Iliad*. The data I want to use are available as a delimited-text file from this URL:

https://raw.githubusercontent.com/neelsmith/homericlanguage/refs/heads/main/scansion-expanded.cex


The first line is a pipe-delimited header with these column names:

`Passage|Syllable|SyllableText|MetricLength|Token|Half-line`

This is followed by pipe-delimited lines of data with each line recording data about one syllable of the *Iliad*. Please read the data lines into an Array of string values. The structure of each line is:

the columns `Passage`, `Syllable` and `Token` are string values identifying text pieces uing CTS URN notation; the column `SyllableText` is a string with the text content of that syllable; `MetricLength` is one of three values: `long`, `short`, or `anceps`. `Half-line` is an integer that should always be either `1` or `2`.

The app should let users enter a passage reference either in the form `BOOK.LINE` or in the form `BOOK1.LINE1-BOOK2.LINE2` and use that value to find all matching records in the Array of data strings. References in the first form `BOOK.LINE` must match the fifth and final colon-delimited part of the `Passage` value. **Example**: if the `Passage` column has the value `urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1`, the final part is `1.1` and would match if the user entered `1.1` for the `BOOK.LINE` reference. References in the second form `BOOK1.LINE1-BOOK2.LINE2` identify a *range* of lines beginning with `BOOK1.LINE1` and ending with `BOOK2.LINE2` inclusively. The data records are guaranteed to be in document order so this is not difficult: we should match all records in the data array with passage references `BOOK1.LINE1` on through all data records matching `BOOK2.LINE2`. If either `BOOK1.LINE1` or `BOOK2.LINE2` does not appear in the data set, it is an error.

Next we will display the matching data records in up to 3 formats. The app should offer the user 3 checkboxes named named `words`, `syllables` and `feet` to determine which formats to incliude.

Each display will display a single *Iliad* line: that is, all records with the same value for `Passage`. Let's first implement and test the `words` display before we go further. We want to display the values of the `SyllableText` column. Concatenate them to form a single line like this: starting with the `SyllableText` of the first record for the line; as you advance through each successive record, if the value of the `Token` column is the same as the preceding record, add the `SyllableText` directly to the string to display. If its `Token` column has a different value, then it begins a new word. First add a space to the output string, then add the value of the `SyllableText` column


Please implement this in an HTML page.


Each

compose a function named `display` that we can reuse in this or other webapps. It should take four parameters: an array of data strings, and 3 boolean values . The function should create a 