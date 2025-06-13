## User's Guide: Metrically Aware Text Search for the *Iliad*

This application allows you to search for text strings within a text of the *Iliad* and apply metrical constraints to refine your search.

### Basic Text Search

*   **Search for text:** Enter the Greek text you want to find.
    *   The search is case-insensitive.
    *   Accents and breathings are ignored for matching purposes, so you can type simplified Greek (e.g., "μηνιν" instead of "μῆνιν").
    *   If you don't specify any metrical constraints (see below), this will search for your text anywhere within each line of the *Iliad*.

### Using Metrical Constraints

You can limit your search by metrical position within the line by choosing a search mode, and entering a foot/syllable constraint in the form `foot.passage`. For example, `5.1` refers to foot 5, syllable 1. If the penultimate syllabe is a dactyl, this is the beginning of the zippity-doo-dah line ending (sometimes referred to among classicists as the "bucolic diaeresis").

*   **Search Mode:** This dropdown menu defines how the "Foot-syllable Constraint" is applied:
    *   **Contains (anywhere):** (Default if no constraint is actively used) Finds lines where your search text appears anywhere. The "Constrain to foot.syllable" field is ignored in this mode.
    *   **Starts from constraint:** Finds lines where your search text *begins exactly at* the specified foot and syllable.
        *   *Requires* a "Constrain to foot.syllable" value.
    *   **Ends at constraint:** Finds lines where your search text *ends exactly at* the specified foot and syllable.
        *   *Requires* a "Constrain to foot.syllable" value.
    *   **Follows constraint:** Finds lines where your search text occurs *at or after* the specified foot and syllable. If no constraint is given, it behaves like "Contains (anywhere)" starting from the beginning of the line.
    *   **Precedes constraint:** Finds lines where your search text *ends at or before* the specified foot and syllable. If no constraint is given, it behaves like "Contains (anywhere)" but finds the last occurrence that ends by the end of the line.

*   **Constrain to foot.syllable:**
    *   Enter a metrical position in the format `F.S` (e.g., `1.1`, `2.3`, `6.1`).
        *   `F` is the foot number (typically 1 through 6 in a hexameter line).
        *   `S` is the syllable number within that foot (typically 1, 2, or 3).
    *   This field is *required* if you select "Starts from constraint" or "Ends at constraint". It's optional for "Follows constraint" and "Precedes constraint" (if left blank for these, they search relative to the start/end of the line).

**4. Performing a Search**

*   Enter your search text.
*   Optionally, select a "Search Mode" and enter a "Foot.syllable Constraint".
*   Click the "Search" button or press Enter in any of the input fields.

**5. Viewing Results**

*   **Matching Lines:** Lines from the *Iliad* that match your criteria will be displayed.
*   **Format:** Each result shows:
    *   The **Book.Line reference** (e.g., `1.123`) in silver.
    *   The full line displayed in a **syllabified format**.
        *   Syllables of the same word are connected by hyphens (`-`).
        *   Spaces separate different words.
        *   The caesura/diaeresis (break between the first and second half-line) is marked with a larger `∥` symbol.
*   **Highlighting:** Syllables that form your matched search text will be highlighted in yellow. This helps you see exactly what part of the line matched your query and constraints.
*   **Pagination:** If there are many results, they will be split into pages. Use the "Previous" and "Next" buttons to navigate. The current page and total pages are displayed.

**6. Inspecting Syllables**

*   **Clickable Syllables:** In the results display, each individual syllable block is clickable.
*   **Details Panel:** When you click on a syllable, details about it will appear in the panel on the right-hand side of the screen:
    *   **Syllable:** The text of the clicked syllable.
    *   **Foot-syllable:** The `Foot.Syllable` identifier of that specific syllable (e.g., `3.2` for the 2nd syllable of the 3rd foot).
    *   **Length:** The metrical length of the syllable (Long, Short, or Anceps).

**7. Tips for Searching**

*   **Start Simple:** Begin with a "Contains (anywhere)" search without constraints to see general occurrences.
*   **Refine with Constraints:** If you want to find a word or phrase at a specific metrical position (e.g., at the beginning of the third foot), use "Starts from constraint" and `3.1`.
*   **Partial Syllables:** The search can match queries that are prefixes of syllable sequences. For example, searching for "λευκωλενο" will match and highlight "λευκ-ώλ-εν-ος" because "λευκωλενο" is a prefix of the simplified form of that sequence. The highlighting will cover all syllables that contribute to forming your query.
