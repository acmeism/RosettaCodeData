' ============================================
' https://rosettacode.org/wiki/Split_a_character_string_based_on_change_of_character
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
[inits]
    LET s$      = "gHHH5YY++///\\" ' Extra \ at the end to escape the escape
    LET result$ = ""
    LET cur$
    LET nxt$

[main]
    FOR i$ = 1 TO LEN(s$) - 1
        cur$ = MID(s$, i$, 1)
        nxt$ = MID(s$, i$ + 1, 1)
        IF cur$ <> nxt$ THEN
            result$ = result$ + cur$ + ", "
        ELSE
            result$ = result$ + cur$
        ENDIF
    NEXT

    ' Last character always appended without trailing comma
    result$ = result$ + RIGHT(s$, 1)

[output]
    PRINT "Original: "; s$
    PRINT "Splitted:  "; result$
END

' Output:
' Original: gHHH5YY++///\
' Splitted:  g, HHH, 5, YY, ++, ///, \
