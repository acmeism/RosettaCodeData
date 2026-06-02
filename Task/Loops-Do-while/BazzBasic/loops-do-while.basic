' ============================================
' https://rosettacode.org/wiki/Loops/Do-while
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' BazzBasic has no DO keyword, but a do-while loop is emulated
' with WHILE TRUE and a conditional exit at the end of the body.
' This guarantees the loop body executes at least once.

[inits]
    LET value$ = 0

[main]
    WHILE TRUE
        value$+= 1
        PRINT value$
        IF MOD(value$, 6) = 0 THEN GOTO [done]
    WEND

[done]
END

' Output:
' 1
' 2
' 3
' 4
' 5
' 6
