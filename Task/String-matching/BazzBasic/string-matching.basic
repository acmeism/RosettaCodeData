' ============================================
' https://rosettacode.org/wiki/String_matching
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
[inits]
    LET s1$      = "Hello World Hello"
    LET s2$      = "Hello"
    LET pos$
    LET offset$
    LET slice$

[main]
    ' --- Starts with ---
    IF LEFT(s1$, LEN(s2$)) = s2$ THEN
        PRINT "Starts with '"; s2$; "': YES"
    ELSE
        PRINT "Starts with '"; s2$; "': NO"
    ENDIF

    ' --- Ends with ---
    IF RIGHT(s1$, LEN(s2$)) = s2$ THEN
        PRINT "Ends with '";   s2$; "': YES"
    ELSE
        PRINT "Ends with '";   s2$; "': NO"
    ENDIF

    ' --- Contains (all occurrences with positions) ---
    pos$    = INSTR(s1$, s2$)
    offset$ = 0
    slice$  = s1$

    IF pos$ = 0 THEN
        PRINT "Contains '"; s2$; "': NO"
    ELSE
        PRINT "Contains '"; s2$; "': YES"
        WHILE pos$ > 0
            PRINT "  Found at position: "; pos$ + offset$
            offset$ = offset$ + pos$ + LEN(s2$) - 1
            slice$  = MID(slice$, pos$ + LEN(s2$))
            pos$    = INSTR(slice$, s2$)
        WEND
    ENDIF
END

' Output:
' Starts with 'Hello': YES
' Ends with 'Hello': YES
' Contains 'Hello': YES
'   Found at position: 1
'   Found at position: 13
