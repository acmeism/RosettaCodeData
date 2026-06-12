# syntax: GAWK -f IMPLICIT_TYPE_CONVERSION.AWK
BEGIN {
    n = 1     # number
    s = "1"   # string
    a = n ""  # number coerced to string
    b = s + 0 # string coerced to number
    print(n,s,a,b)
    print(("19" 91) + 4) # string and number concatenation
    c = "10e1"
    print(c,c+0)
    exit(0)
}
