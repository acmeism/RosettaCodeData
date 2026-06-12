# syntax: GAWK -f NUMERIC_SEPARATOR_SYNTAX.AWK
# converted from ALGOL 68
BEGIN {
# AWK lacks numeric separators but can be simulated using white space.
    a = 1 234 567
    b = 3  "."  1 4159 26 5 359
    print(a,b)
    exit(0)
}
