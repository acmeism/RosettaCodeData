# syntax: GAWK -f FIND_WORDS_WHICH_FIRST_AND_LAST_THREE_LETTERS_ARE_EQUALS.AWK unixdict.txt
(length($0) >= 6 && substr($0,1,3) == substr($0,length($0)-2,3))
END {
    exit(0)
}
