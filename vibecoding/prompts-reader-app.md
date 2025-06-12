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

---

Great. For *syllables*, please compose the output as follows. Start with the `SyllableText` column of the first record. As you advance through the successive records, if the current record has the same `Token` value (ie, is part of the same word), join it to the output with a hyphen `-`; if it has a different `Token` value it is a new word: joint it to the output with a space. 
---

Excellent. Now let's tweak the syllables display. Let's highlight each syllable with one of three background colors depending on the value of the `MetricLength` of that syllable. If `MetricLength` is `long`, use a gray background; if is it `short`, use a visually distinguishable lighter gray background. If it is `anceps` use an orangeish "caution" color.
---
Beautiful! Now let's make each syllable in the syllables display clickable. When the user clicks on a syllable, display the foot-syllable reference. This is encoded in the final two period-separated pieces of the `Syllable` column's passage value. **Example**: if the value of the `Syllable` column is `urn:cts:greekLit:tlg0012.tlg001.hmtx:6.3.1.2`, then the passage value is the last colon-delimited component `6.3.1.2`; the last two period-separated pieces of that are `1.2` so we would display `1.2` to indicate foot `1`, syllable `2`.

---

Super. Now let's add the display for *feet*. The foot is identified by the third period-separated part of each record's `Syllable` column.  **Example**: if the value of the `Syllable` column is `urn:cts:greekLit:tlg0012.tlg001.hmtx:6.3.1.2`, the foot is identified by `1`. Please create a display that joins the `SyllableText` values using the same logic as for syllables: syllables in the same word are concatenated with hyphens, syllables belonging to new words are concatenated with a space. Instead of highlighting text by syllable value, however, I want to highlight each foot with a visually distinct pastel color. **Example**: if I had 6 records like this:

```
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1.1|μῆ|long|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1|1
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1.2|νιν|short|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1|1
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.1.3|ἄ|short|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.2|1
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.2.1|ει|long|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.2|1
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.2.2|δε|short|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.2|1
urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.2.3|θε|short|urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.3|1
```

the first three all belong to foot `1` of passage `1.1`; the next three all belong to foot `2` of passage `1.1`. The first three should be grouped together and colored one way, the seoncd three grouped together and colored differently.

I would also like to make each *foot* clickable. When a user clicks on a foot, I want to display two pieces of information: the identifying foot number, and whether the foot forms a *dactyl*  or a *spondee*. A foot forms a *dactyl* if it has three syllables, a *spondee* if it has two. In the example above, 6 rows document two feet. The first has ID `1`, and the second has ID `2`. Each of them has 3 syllables, so in this example, each syllable is a *dactyl*.

Please implement this and show the resulting HTML.

---

All the functionality is perfect! Now let's tweak the layout a little without in any way changing the functionality of the app. I'd like to start by placing the area for displaying details when the user clicks in a column to the right of the displayed lines. 
---
This is good, but two messages are lingering when it seems they should be hidden. In the right hand column, there is a separate blue box with the text "Details will appear here when an item is clicked." even after I click on an item and the details are correctly displayed. In the left hand column, the message "Loading data... Please wait" remains even after the data have been loaded. Could you check that?

---

Fixed! Great! Now some adjustments to arrangement and spacing. Please change the text "Display formats:"  labelling the 3 checkboxes to just "Display:", and move the label and check box to follow the button "Visualize" immediately, without any vertical break.

---
The user input box and three check boxes are displayed twice. Please fix that.
---

Thanks! There's one minor behavioral quirk. The app defaults to checking the box for "Words" and unchecking the others, but doesn't actually display anything until the user has changed one of the checkboxes (ie, the app seems to think that in their initial or default state all 3 boxes are unchecked even though "Words" is checked) Could you fix that?
---
Closer. App now correctly shows initial state and correctly responds to changes of checkboxes but does not react to change of the user-supplied passage reference. Please fix.

---

Perfect! Now I'd like to make the display of words interactive. Each word should be clickable.  When clicked, the app should display the passage component of the `Token` URN string. **Example**: if the user clicks on a word made up of syllables with the `Token` value `urn:cts:greekLit:tlg0012.tlg001.hmtx:1.1.3`, the app should display `1.1.3`.

---


u2225 "Parallel to"


