' ============================================
' https://rosettacode.org/wiki/Sierpinski_triangle
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

[inits]
    LET ORDER# = 4

    DIM row$

    LET numRows$ = 1
    LET r$, c$
    LET line$
    LET wkv$
[main]
    FOR r$ = 1 TO ORDER#
        numRows$ = numRows$ * 2
    NEXT
    row$(0) = 1
    FOR r$ = 0 TO numRows$ - 1
        ' REPEAT is a fancy way to create indents
        line$ = REPEAT(" ", numRows$ - 1 - r$)
        FOR c$ = 0 TO r$
            IF row$(c$) = 1 THEN
                line$ = line$ + "*"
            ELSE
                line$ = line$ + " "
            END IF
            IF c$ < r$ THEN
                line$ = line$ + " "
            END IF
        NEXT
        PRINT line$
        row$(r$ + 1) = 1
        FOR c$ = r$ TO 1 STEP -1
            row$(c$) = MOD(row$(c$ - 1) + row$(c$), 2)
        NEXT
    NEXT
    LET wkv$ = WAITKEY()
END
