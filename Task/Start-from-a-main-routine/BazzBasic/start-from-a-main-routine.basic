' Start from a main routine (BazzBasic solution)
' Rosetta Code: https://rosettacode.org/wiki/Start_from_a_main_routine
'
' BazzBasic programs execute top-to-bottom. There is no required main()
' entry point. However, the [inits] / [main] label convention provides
' a clear structural equivalent: declarations first, logic second.

[inits]
    LET myVar$    = "foo"
    LET otherVar$ = "bar"

[main]
    PRINT myVar$
    GOSUB [sub:doSomething]
END

[sub:doSomething]
    PRINT "doSomething"
RETURN
