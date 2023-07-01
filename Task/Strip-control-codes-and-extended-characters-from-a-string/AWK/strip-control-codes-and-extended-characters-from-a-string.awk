# syntax: GAWK -f STRIP_CONTROL_CODES_AND_EXTENDED_CHARACTERS.AWK
BEGIN {
    s = "ab\xA2\x09z" # a b cent tab z
    printf("original string: %s (length %d)\n",s,length(s))
    gsub(/[\x00-\x1F\x7F]/,"",s); printf("control characters stripped: %s (length %d)\n",s,length(s))
    gsub(/[\x80-\xFF]/,"",s); printf("control and extended stripped: %s (length %d)\n",s,length(s))
    exit(0)
}
