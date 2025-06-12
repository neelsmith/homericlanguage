I want to create a single-page web app using HTML and Javascript to visualize data about the metrical scansion of the Iliad. The data I want to use are available as a delimited-text file from this URL:

https://raw.githubusercontent.com/neelsmith/homericlanguage/refs/heads/main/scansion-expanded.cex


The first line is a pipe-delimited header with these column names:

`Passage|Syllable|SyllableText|MetricLength|Token|Half-line`

This is followed by pipe-delimited lines of data with each line recording data about one syllable of the *Iliad*. Please read the data lines into an Array of string values. The structure of each line is:

the columns `Passage`, `Syllable` and `Token` are string values identifying text pieces uing CTS URN notation; the column `SyllableText` is a string with the text content of that syllable; `MetricLength` is one of three values: `long`, `short`, or `anceps`. `Half-line` is an integer that should always be either `1` or `2`.

First the app should construct a simplified corpus to search on. Do this by constructing a searchable string for each unique passage reference. This is easy because the data are guaranteed to be in document order. For each unique value of the `Passage` column we will create a searchable string from the contents of the `SyllableText` column. Starting with the `SyllableText` of the first record for a `Passage` value, as you advance through each successive record, if the value of the `Token` column is the same as the preceding record, add the `SyllableText` directly to the string to display. If its `Token` column has a different value, then it begins a new word. First add a space to the output string, then add the value of the `SyllableText` column. In this way you can pair a single text string with the `Passage` identifier. This string will be fully accented polytonic Greek. We want to keep be able to look this value up from its `Passage` identifier. Then create the simplified searchable version by stripping out all accents and breathings from the text string.

The app should let the user enter a string to search for. Find all passages containing that string and note its `Passage` identifier. Use that value to retrieve the fully accented version.

Create a pageable list of results. 

Please implement this in an HTML page.

---
Great! Add a menu for search type with three option: "contains", "begins with", "ends with". 