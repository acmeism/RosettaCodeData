' ============================================
' https://rosettacode.org/wiki/Call_a_function
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
DEF FN add$(a$, b$)
    RETURN a$ + b$
END DEF

DEF FN ReturnHello$()
    RETURN "This is ReturnHello"
END DEF

[init]
    LET mySub$ = "[sub:subHello]"

[main]
    PRINT FN add$(5, RND(10) + 1)	' Function call with arguments
    PRINT FN ReturnHello$()			' Function call, no arguments
    GOSUB mySub$					' Dynamic subroutine call via label string
    GOSUB [sub:subHello]			' Direct subroutine call
END

[sub:subHello]
    PRINT "This is subHello"
RETURN
