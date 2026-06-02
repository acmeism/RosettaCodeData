' ============================================
' https://rosettacode.org/wiki/Array_concatenation
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' BazzBasic arrays accept both numeric and string keys, so "concatenation"
' has two flavors:
'   1. Numeric-indexed (classic): append, offsetting the second array's
'      keys by the length of the first.
'   2. Associative (string keys): JOIN is the idiomatic merge -- but note
'      src2$ keys overwrite src1$ on collision, so it's merge, not concat.

[inits]
    DIM a$, b$, c$
    DIM p$, q$, merged$

    ' Numeric-indexed arrays
    a$(0) = 1 : a$(1) = 2 : a$(2) = 3
    b$(0) = 4 : b$(1) = 5 : b$(2) = 6

    ' Associative arrays
    p$("name") = "Alice"
    p$("age")  = 30
    q$("city") = "Helsinki"
    q$("age")  = 31                ' will overwrite p$("age") on JOIN

    LET aLen$ = LEN(a$())
    LET bLen$ = LEN(b$())

[concat_numeric]
    FOR i$ = 0 TO aLen$ - 1
        c$(i$) = a$(i$)
    NEXT
    FOR i$ = 0 TO bLen$ - 1
        c$(i$ + aLen$) = b$(i$)
    NEXT

    PRINT "Numeric concat:"
    FOR i$ = 0 TO LEN(c$()) - 1
        PRINT c$(i$); " ";
    NEXT
    PRINT ""

[merge_associative]
    ' JOIN is the idiomatic associative-array merge.
    ' Matching keys from src2$ overwrite src1$ at the same level.
    JOIN merged$, p$, q$
    PRINT "Associative merge:"
    PRINT "  name = "; merged$("name")
    PRINT "  age  = "; merged$("age")
    PRINT "  city = "; merged$("city")
END

' Output:
' Numeric concat:
' 1 2 3 4 5 6
' Associative merge:
'   name = Alice
'   age  = 31
'   city = Helsinki
