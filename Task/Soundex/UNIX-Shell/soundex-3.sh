soundex2() {
    local -u word=${1//[^[:alpha:]]/}

    # 1. Save the first letter. Remove all occurrences of 'h' and 'w' except first letter.
    local first=${word:0:1}
    word=${word:1}
    word=$first${word//[HW]/}

    # 2. Replace all consonants (include the first letter) with digits as in [2.] above.
    local consonants=$(IFS=; echo "${!value[*]}")
    local tmp letter
    local -i i
    for ((i=0; i < ${#word}; i++)); do
        letter=${word:i:1}
        if [[ $consonants == *$letter* ]]; then
            tmp+=${value[$letter]}
        else
            tmp+=$letter
        fi
    done
    word=$tmp

    # 3. Replace all adjacent same digits with one digit.
    local char
    tmp=${word:0:1}
    local previous=${word:0:1}
    for ((i=1; i < ${#word}; i++)); do
        char=${word:i:1}
        [[ $char != [[:digit:]] || $char != $previous ]] && tmp+=$char
        previous=$char
    done
    word=$tmp

    # 4. Remove all occurrences of a, e, i, o, u, y except first letter.
    tmp=${word:1}
    word=${word:0:1}${tmp//[AEIOUY]/}

    # 5. If first symbol is a digit replace it with letter saved on step 1.
    [[ $word == [[:digit:]]* ]] && word=$first${word:1}

    # 6. right pad with zeros
    word+="000"
    echo "${word:0:4}"
}
