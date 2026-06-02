' ============================================
' https://rosettacode.org/wiki/Factorial
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' Provides recursive and iterative at same run
DEF FN FactorialRecursive$(n$)
    IF n$ <= 1 THEN RETURN 1
    RETURN n$ * FN FactorialRecursive$(n$ - 1)
END DEF

DEF FN FactorialIterative$(n$)
    LET result$ = 1
    FOR i$ = 2 TO n$
        result$ = result$ * i$
    NEXT
    RETURN result$
END DEF

[main]
    INPUT "Enter a number: ", n$

    IF n$ < 0 THEN
        PRINT "Negative numbers not supported."
        END
    END IF

    PRINT n$; "! = "; FN FactorialRecursive$(n$); " (recursive)"
    PRINT n$; "! = "; FN FactorialIterative$(n$); " (iterative)"
END

' Output:
' Enter a number: 50
' 50! = 3.0414093201713376E+64 (recursive)
' 50! = 3.0414093201713376E+64 (iterative)
