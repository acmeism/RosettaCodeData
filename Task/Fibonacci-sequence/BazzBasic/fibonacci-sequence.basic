' ============================================
' https://rosettacode.org/wiki/Fibonacci_sequence
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

DEF FN FibRecursive$(n$)
    IF n$ <= 1 THEN RETURN n$
    RETURN FN FibRecursive$(n$ - 1) + FN FibRecursive$(n$ - 2)
END DEF

DEF FN FibIterative$(n$)
    IF n$ <= 1 THEN RETURN n$
    LET a$ = 0
    LET b$ = 1
    FOR i$ = 2 TO n$
        LET temp$ = a$ + b$
        a$ = b$
        b$ = temp$
    NEXT
    RETURN b$
END DEF

DEF FN FibBinet$(n$)
    LET sqrt5$ = SQR(5)
    RETURN CINT((POW((1 + sqrt5$) / 2, n$) - POW((1 - sqrt5$) / 2, n$)) / sqrt5$)
END DEF

[main]
    INPUT "Enter n: ", n$

    IF n$ < 0 THEN
        PRINT "Negative numbers not supported."
        END
    END IF

    PRINT "Fibonacci("; n$; ")"
    PRINT " Recursive: "; FN FibRecursive$(n$)
    PRINT " Iterative: "; FN FibIterative$(n$)
    PRINT " Binet:     "; FN FibBinet$(n$)
END

' Output:
' Enter n: 6
' Fibonacci(6)
 ' Recursive: 8
 ' Iterative: 8
 ' Binet:     8
