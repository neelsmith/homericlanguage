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

Great! Add a menu for search type with three option: "contains", "begins with", "ends with".  In searching, if the user chooses "begins with" only match lines beginning with the user-supplied string. Similarly, only give lines ending with the user supplied string if the user choosed "ends with". No change in behavior if the user chooses "contains" which should be the default

---

The next feature I'd like to add is an option to include metrical constraints. If the user chooses this option, she should be able to enter a string with the pattern `FOOT.SYLLABLE`. This corresponds to the final part of the `Syllable` column in each data record. **Example**: 
if a record has a `Syllable` value `urn:cts:greekLit:tlg0012.tlg001.hmtx:3.5.1.2`, then the foot is `1` and the syllable is `2`: this would match a user request for `1.2`.

If the search mode is `ends with`, then nothing changes but if the search mode is `contains`, the app should only return results that are completely contained in the syllables beginning from the designated one to the end of the line. **Example**: the user searches for a string `μηνιν` with a  metrical constraint of `5.1`. A raw string search gets a result pointing to `urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1`; this resolves to a fully accented string that begins with the string `μῆνιν`. We find in the data records for `urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1` that this is represented by two records:

```
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1.1|μῆ|long|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1|1
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1.2|νιν|short|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1|1
```

But we see that the foot-syllable references are `1.1` and `1.2` and are not included in the text beginning from `5.1`: we have to exclude this result.


If the search mode is `starts with` then the matching syllable must begin exactly at the requested foot-sylable position.

Plesae implement this.