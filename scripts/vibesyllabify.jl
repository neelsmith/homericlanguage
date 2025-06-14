using Unicode

# --- Helper Functions and Data Structures ---

# Function to get the base character (stripping diacritics)
function get_base_char(char::Char)
    nfd_str = Unicode.normalize(string(char), :NFD) # string(char) is safe
    if isempty(nfd_str)
        # This could happen if 'char' is a standalone combining mark that normalizes weirdly,
        # or an invalid char. Fallback to original char.
        return char
    end
    # Return the first character of the NFD string.
    # firstindex(nfd_str) correctly gets the starting byte index of the first Char.
    return nfd_str[firstindex(nfd_str)]
end

# Basic Character Sets (using base characters)
const BASE_VOWELS = Set(['α', 'ε', 'η', 'ι', 'ο', 'υ', 'ω'])
const BASE_CONSONANTS = Set(['β', 'γ', 'δ', 'ζ', 'θ', 'κ', 'λ', 'μ', 'ν', 'ξ', 'π', 'ρ', 'σ', 'τ', 'φ', 'χ', 'ψ'])

# Vowels/Diphthongs with Diacritics (full forms)
const IOTA_SUBSCRIPTS_CHARS = Set([
    'ᾳ', 'ᾴ', 'ᾲ', 'ᾷ', 'ᾀ', 'ᾁ', 'ᾂ', 'ᾃ', 'ᾄ', 'ᾅ', 'ᾆ', 'ᾇ',
    'ῃ', 'ῄ', 'ῂ', 'ῇ', 'ᾐ', 'ᾑ', 'ᾒ', 'ᾓ', 'ᾔ', 'ᾕ', 'ᾖ', 'ᾗ',
    'ῳ', 'ῴ', 'ῲ', 'ῷ', 'ᾠ', 'ᾡ', 'ᾢ', 'ᾣ', 'ᾤ', 'ᾥ', 'ᾦ', 'ᾧ'
])

const DIPHTHONG_BASE_PAIRS = Set([
    "αι", "ει", "οι", "υι", # ending in ι
    "αυ", "ευ", "ηυ", "ου"  # ending in υ
])

# For checking if a character (Char) is a vowel or consonant
is_vowel_char(char::Char) = get_base_char(char) in BASE_VOWELS
is_consonant_char(char::Char) = get_base_char(char) in BASE_CONSONANTS

# For checking linguistic units (String)
function is_vowel_unit(unit_str::String) # Renamed 'unit' to 'unit_str' for clarity
    if isempty(unit_str) return false end
    
    unit_chars = collect(unit_str) # Convert string to Vector{Char} for safe indexing

    # Check iota subscript (single character precomposed)
    if length(unit_chars) == 1 && unit_chars[1] in IOTA_SUBSCRIPTS_CHARS
        return true
    end
    # Check simple vowel (single character)
    if length(unit_chars) == 1 && is_vowel_char(unit_chars[1])
        return true
    end
    # Check diphthong (two characters)
    if length(unit_chars) == 2
        base_u1 = get_base_char(unit_chars[1])
        base_u2 = get_base_char(unit_chars[2])
        return string(base_u1, base_u2) in DIPHTHONG_BASE_PAIRS
    end
    return false
end

function is_consonant_unit(unit_str::String) # Renamed 'unit' to 'unit_str'
    if isempty(unit_str) return false end
    unit_chars = collect(unit_str) # Convert string to Vector{Char}
    return length(unit_chars) == 1 && is_consonant_char(unit_chars[1])
end


# --- Valid Initial Consonant Clusters ---
const VALID_INITIAL_CLUSTERS = Set([
    "β", "γ", "δ", "ζ", "θ", "κ", "λ", "μ", "ν", "π", "ρ", "σ", "τ", "φ", "χ",
    "βδ", "βλ", "βρ", "γλ", "γν", "γρ", "δμ", "δν", "δρ", "θλ", "θν", "θρ",
    "κλ", "κμ", "κν", "κρ", "κτ", "μν", "πλ", "πν", "πρ", "πτ",
    "σβ", "σγ", "σδ", "σκ", "σλ", "σμ", "σν", "σπ", "στ", "σσ", "σφ", "σχ",
    "τλ", "τμ", "τν", "τρ", "φθ", "φλ", "φν", "φρ", "χθ", "χλ", "χν", "χρ",
    "βδλ", "σθλ", "στλ", "σκλ", "σκν", "σκρ", "σμπ", "στρ", "σπλ", "σφρ", "σχλ", "φθρ"
])

function is_valid_initial_cluster(consonant_units::Vector{String})
    if isempty(consonant_units)
        return true 
    end
    # Each 'unit_str' in consonant_units is a string representing a single consonant (e.g., "κ", "σ").
    # get_base_char needs a Char. unit_str[firstindex(unit_str)] safely gets the Char.
    base_char_string = join([string(get_base_char(unit_str[firstindex(unit_str)])) for unit_str in consonant_units])
    return base_char_string in VALID_INITIAL_CLUSTERS
end


# --- Main Syllabification Function ---

function syllabify_greek(word::String)::Vector{String}
    if isempty(word)
        return String[]
    end

    word_nfc = Unicode.normalize(word, :NFC)
    word_nfc = replace(word_nfc, 'ς' => 'σ') 

    linguistic_units = Vector{String}()
    chars = collect(word_nfc) # Safe: chars is now Vector{Char}
    char_idx = 1
    while char_idx <= length(chars)
        char1 = chars[char_idx]
        current_unit_str = string(char1)

        if char1 == 'ξ'
            push!(linguistic_units, "κ")
            push!(linguistic_units, "σ")
            char_idx += 1
            continue
        elseif char1 == 'ψ'
            push!(linguistic_units, "π")
            push!(linguistic_units, "σ")
            char_idx += 1
            continue
        end

        if char_idx < length(chars)
            char2 = chars[char_idx+1]
            potential_diphthong_str = string(char1, char2)
            if is_vowel_unit(potential_diphthong_str)
                current_unit_str = potential_diphthong_str
                char_idx += 1 
            end
        end
        push!(linguistic_units, current_unit_str)
        char_idx += 1
    end

    if isempty(linguistic_units)
        return String[]
    end

    syllables = Vector{String}()
    current_syllable_parts = Vector{String}()
    lu_idx = 1 # Index for linguistic_units

    while lu_idx <= length(linguistic_units)
        current_lu = linguistic_units[lu_idx]
        push!(current_syllable_parts, current_lu)

        if is_vowel_unit(current_lu)
            # Found the nucleus. Look at following consonants.
            # Don't increment lu_idx yet, it's part of current syllable formation logic
            
            following_consonants_buffer = Vector{String}()
            # Start looking from the unit *after* the current vowel nucleus
            cons_buffer_idx = lu_idx + 1 
            while cons_buffer_idx <= length(linguistic_units) && is_consonant_unit(linguistic_units[cons_buffer_idx])
                push!(following_consonants_buffer, linguistic_units[cons_buffer_idx])
                cons_buffer_idx += 1
            end

            num_cons_to_keep_in_current = 0
            # If cons_buffer_idx points past the end, all buffered consonants belong to current syllable
            # OR if the unit at cons_buffer_idx is NOT a vowel (i.e. end of word or error in logic)
            is_next_unit_vowel = (cons_buffer_idx <= length(linguistic_units) && is_vowel_unit(linguistic_units[cons_buffer_idx]))

            if !is_next_unit_vowel # End of word, or next unit is not a vowel (shouldn't happen if word structure is V C V)
                num_cons_to_keep_in_current = length(following_consonants_buffer)
            else # Next unit is a vowel, so we need to split following_consonants_buffer
                can_start_next_syllable_count = 0
                # Iterate from longest possible onset for the next syllable
                for count_for_next_onset in length(following_consonants_buffer):-1:0 
                    if count_for_next_onset == 0 # Vowel | Vowel, no consonants to test for next onset
                         break 
                    end
                    # Candidate onset is the last 'count_for_next_onset' consonants from the buffer
                    onset_candidate_units = following_consonants_buffer[ (length(following_consonants_buffer) - count_for_next_onset + 1) : end ]
                    if is_valid_initial_cluster(onset_candidate_units)
                        can_start_next_syllable_count = count_for_next_onset
                        break 
                    end
                end
                num_cons_to_keep_in_current = length(following_consonants_buffer) - can_start_next_syllable_count
            end
            
            # Add consonants belonging to current syllable's coda
            for i in 1:num_cons_to_keep_in_current
                push!(current_syllable_parts, following_consonants_buffer[i])
            end
            
            push!(syllables, join(current_syllable_parts))
            current_syllable_parts = Vector{String}() 

            lu_idx += (1 + num_cons_to_keep_in_current) # Advance past vowel nucleus + coda consonants
            
        else # Consonant, part of onset. Continue to find nucleus.
            lu_idx += 1
        end
    end
    
    if !isempty(current_syllable_parts) # Remaining parts (e.g. word ends in consonant(s) not forming a full syllable with vowel)
        if isempty(syllables)
             push!(syllables, join(current_syllable_parts))
        else 
             syllables[end] = syllables[end] * join(current_syllable_parts)
        end
    end

    return syllables
end

# --- Examples ---
function run_syllabify_examples()
    words = [
        "λόγος", "ἀνήρ", "πάσχω", "ἔργον", "ἄστυ", "πατρός", "τέκνον",
        "ἄλλος", "ἔνδον", "κάρτα", "ἄνθρωπος", "ἐχθρός", "αἰσχρός",
        "τάξις", "ὄψις", "ἁρπάζω", "βασιλεύς", "στρατηγός", "οἶκος",
        "τοῦ", "τῇ", "αὐτός", "ἐξουσία", "πρᾶξις", "εἰμί", "σύν", "ἐκ",
        "προσφέρω" # The problematic one
    ]

    println("Expected outputs (approximate for some complex cases):")
    println("λόγος -> λό-γος")
    println("ἀνήρ -> ἀ-νήρ")
    println("πάσχω -> πά-σχω")
    println("ἔργον -> ἔ-ργον")
    println("ἄστυ -> ἄ-στυ")
    println("πατρός -> πα-τρός")
    println("τέκνον -> τέ-κνον")
    println("ἄλλος -> ἄλ-λος")
    println("ἔνδον -> ἔν-δον")
    println("κάρτα -> κάρ-τα")
    println("ἄνθρωπος -> ἄν-θρω-πος")
    println("ἐχθρός -> ἐχ-θρός")
    println("αἰσχρός -> αἰσ-χρός")
    println("τάξις -> τάκ-σις") # From τα-κσ-ις
    println("ὄψις -> ὄπ-σις")   # From ο-πσ-ις
    println("ἁρπάζω -> ἁρ-πά-ζω")
    println("βασιλεύς -> βα-σι-λεύς")
    println("στρατηγός -> στρα-τη-γός")
    println("οἶκος -> οἶ-κος")
    println("τοῦ -> τοῦ")
    println("τῇ -> τῇ")
    println("αὐτός -> αὐ-τός")
    println("ἐξουσία -> ἐ-ξου-σί-α (or ἐκ-σου-σί-α)") # current ξ decomp -> ἐκ-σου-σί-α
    println("πρᾶξις -> πρᾶκ-σις")
    println("εἰμί -> εἰ-μί")
    println("σύν -> σύν")
    println("ἐκ -> ἐκ")
    println("προσφέρω -> προσ-φέ-ρω")
    println("-"^20)


    for word in words
        syll = syllabify_greek(word)
        println("Word: $word -> Syllables: $(join(syll, "-"))")
    end

    println("\nTesting compound/edge cases:")
    println("Word: ἐκβαίνω -> Syllables: $(join(syllabify_greek("ἐκβαίνω"), "-"))") # Expected: ἐκ-βαί-νω (if κβ not initial)
    println("Word: εἰσάγω -> Syllables: $(join(syllabify_greek("εἰσάγω"), "-"))")     # Expected: εἰσ-ά-γω
    
    # Test words with tricky consonant clusters or many consonants
    println("Word: ἐξέλκω -> Syllables: $(join(syllabify_greek("ἐξέλκω"), "-"))") # ἐξ-έλ-κω (from ἐκ-σέλ-κω)
    println("Word: κάλλιστος -> Syllables: $(join(syllabify_greek("κάλλιστος"), "-"))") # κάλ-λισ-τος
    println("Word: ἀγγέλλω -> Syllables: $(join(syllabify_greek("ἀγγέλλω"), "-"))") # ἀγ-γέλ-λω (γγ usually splits)
                                                                                  # My code might do ἀ-γγέλ-λω if γγ is valid initial (it's not)
                                                                                  # or ἄγ-γελ-λω depends on VALID_INITIAL_CLUSTERS
                                                                                  # Currently "γγ" is not in VALID_INITIAL_CLUSTERS.
                                                                                  # So it should be `ἄγ-γελ-λω`. Correct for ἀγγέλλω.

    # Test with just vowel, or vowel+consonant
    println("Word: ὦ -> Syllables: $(join(syllabify_greek("ὦ"), "-"))")
    println("Word: ἐν -> Syllables: $(join(syllabify_greek("ἐν"), "-"))")
    
end

# To run the examples:
run_syllabify_examples()