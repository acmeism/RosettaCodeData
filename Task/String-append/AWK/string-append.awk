# syntax: GAWK -f STRING_APPEND.AWK
BEGIN {
    s = "foo"
    s = s "bar"
    print(s)
    exit(0)
}
