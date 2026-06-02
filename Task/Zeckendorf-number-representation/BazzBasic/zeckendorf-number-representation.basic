' ============================================
' https://rosettacode.org/wiki/Zeckendorf_number_representation
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' Every positive integer has a unique representation as a sum
' of non-consecutive Fibonacci numbers (Zeckendorf's theorem).
' Greedy algorithm: repeatedly subtract the largest Fibonacci
' number that fits, recording 1 or 0 for each position.

LET MAX# = 20

[inits]
    DIM fibs$
    LET fib_count$ = 0
    LET n$, remaining$, i$, result$
    LET a$, b$, c$

[main]
    GOSUB [sub:build_fibs]
    FOR n$ = 1 TO MAX#
        GOSUB [sub:zeckendorf]
    NEXT
END

[sub:build_fibs]
    ' Build Fibonacci sequence: 1, 2, 3, 5, 8, 13, ... up to MAX#
    a$ = 1
    b$ = 2
    fib_count$ = 0
    fibs$(fib_count$) = a$
    fib_count$+= 1
    WHILE b$ <= MAX#
        fibs$(fib_count$) = b$
        fib_count$+= 1
        c$ = a$ + b$
        a$ = b$
        b$ = c$
    WEND
RETURN

[sub:zeckendorf]
    ' Greedy decomposition of n$ into Fibonacci bits
    remaining$ = n$
    result$ = ""
    FOR i$ = fib_count$ - 1 TO 0 STEP -1
        IF fibs$(i$) <= remaining$ THEN
            result$ = result$ + "1"
            remaining$ = remaining$ - fibs$(i$)
        ELSE
            result$ = result$ + "0"
        END IF
    NEXT
    ' Strip leading zeros
    WHILE LEFT(result$, 1) = "0" AND LEN(result$) > 1
        result$ = MID(result$, 2)
    WEND
    PRINT n$; " = "; result$
RETURN

' Output:
' 1 = 1
' 2 = 10
' 3 = 100
' 4 = 101
' 5 = 1000
' 6 = 1001
' 7 = 1010
' 8 = 10000
' 9 = 10001
' 10 = 10010
' 11 = 10100
' 12 = 10101
' 13 = 100000
' 14 = 100001
' 15 = 100010
' 16 = 100100
' 17 = 100101
' 18 = 101000
' 19 = 101001
' 20 = 101010
