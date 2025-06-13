
# User's Guide: Visualize scansion of the *Iliad*

This app allows you to view detailed metrical scansion for specific lines or ranges of lines from an *Iliad*.


## Requesting a Passage

*   **Passage Input:** In the input field labeled "Passage (e.g., 1.1 or 1.1-1.5):", enter the reference for the passage you wish to visualize.
    *   **Single Line:** To view a single line, use the format `BOOK.LINE` (e.g., `1.1` for Book 1, Line 1; `24.720` for Book 24, Line 720).
    *   **Range of Lines:** To view a range of lines, use the format `BOOK1.LINE1-BOOK2.LINE2` (e.g., `1.1-1.5` to view lines 1 through 5 of Book 1). The lines will be displayed in order.
*   **Visualize:** After entering your passage reference, click the "Visualize" button or press the Enter key.

**3. Choosing Display Formats**

Below the passage input, you'll find checkboxes to select which formats you want to see for the requested lines:

*   **Words:** Displays the line with syllables grouped into words, as they appear in the text.
*   **Syllables:** Displays the line with:
    *   Syllables of the same word connected by hyphens (`-`).
    *   Spaces separating different words.
    *   Each syllable block colored according to its metrical length:
        *   **Gray:** Long syllable
        *   **Light Gray:** Short syllable
        *   **Orangeish:** Anceps syllable (can be long or short)
    *   A larger `∥` symbol marks the main caesura or diaeresis (the division between the first and second half-lines).
*   **Feet:** Displays the line broken into its metrical feet.
    *   Each foot is a distinct colored block (using a cycle of pastel colors for visual separation).
    *   Syllables within each foot are concatenated (hyphens within words, spaces between words that span across a foot boundary but are part of the same metrical foot).
    *   A `|` symbol separates the feet.

You can select one or more display formats. The visualizations will appear for each line in your requested passage.

**4. Viewing Results**

*   The selected metrical formats for each line in your query will appear in the main display area below the controls.
*   If you requested a range, each line will be shown sequentially with its chosen visualizations.

**5. Interactive Details (Clickable Elements)**

The display is interactive! Click on different elements to get more specific information, which will appear in the panel on the right-hand side of the screen.

*   **Clicking a Word (in the "Words" display):**
    *   Displays: `Word token: [reference]` (e.g., `1.1.3` which is the unique identifier for that word occurrence in the line).
*   **Clicking a Syllable (in the "Syllables" display):**
    *   Displays: `Syllable: [text] | Foot-syllable: [F.S] | Length: [metric]` (e.g., `Syllable: νιν | Foot-syllable: 1.2 | Length: Short`).
*   **Clicking a Foot (in the "Feet" display):**
    *   Displays: `Foot: [number], [type]` (e.g., `Foot: 1, Dactyl` or `Foot: 5, Spondee`). The type will be Dactyl (three syllables) or Spondee (two syllables).

**6. Status Messages**

*   The area below the display format checkboxes will show status messages, such as "Data loaded successfully," "Displaying X line(s)," or any error messages if a passage is not found or entered incorrectly.
