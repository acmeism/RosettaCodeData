WHILE ("" = INKEY$)
    PRINT Octal$(n)
    n = n + 1
WEND
END
FUNCTION Octal$(what)
    outp$ = ""
    w = what
    WHILE ABS(w) > 0
        o = w AND 7
        w = INT(w / 8)
        outp$ = STR$(o) + outp$
    WEND
    Octal$ = outp$
END FUNCTION
