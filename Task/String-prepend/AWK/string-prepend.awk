# syntax: GAWK -f STRING_PREPEND.AWK
BEGIN {
    s = "bar"
    s = "foo" s
    print(s)
    exit(0)
}
