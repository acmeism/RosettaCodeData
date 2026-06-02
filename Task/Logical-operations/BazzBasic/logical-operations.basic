' ============================================
' https://rosettacode.org/wiki/Logical_operations
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

DEF FN LogicalOps$(a$, b$)
    PRINT "AND: "; a$ AND b$
    PRINT "OR:  "; a$ OR b$
    PRINT "NOT: "; NOT a$
    PRINT "XOR: "; (a$ OR b$) AND NOT (a$ AND b$)
    RETURN ""
END DEF

[inits]
    LET foo$

[main]
	' BazzBasic excepts that value returned from function is used somehow.
	' PRINT, var$ or just dummy var$ like here
    foo$ = FN LogicalOps$(TRUE, FALSE)
END

' Output:
' AND: 0
' OR:  1
' NOT: 0
' XOR: 1
