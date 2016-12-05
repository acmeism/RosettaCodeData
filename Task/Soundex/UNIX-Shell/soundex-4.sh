soundex3() {
    local -u word=${1//[^[:alpha:]]/}

    # 1. Save the first letter. Remove all occurrences of 'h' and 'w' except first letter.
    local first=${word:0:1}
    word=$first$( tr -d "HW" <<< "${word:1}" )

    # 2. Replace all consonants (include the first letter) with digits as in [2.] above.
    # 3. Replace all adjacent same digits with one digit.
    local consonants=$( IFS=; echo "${!value[*]}" )
    local values=$( IFS=; echo "${value[*]}" )
    word=$( tr -s "$consonants" "$values" <<< "$word" )

    # 4. Remove all occurrences of a, e, i, o, u, y except first letter.
    # 5. If first symbol is a digit replace it with letter saved on step 1.
    word=$first$( tr -d "AEIOUY" <<< "${word:1}" )

    # 6. right pad with zeros
    word+="000"
    echo "${word:0:4}"
}
