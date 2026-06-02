' ============================================
' https://rosettacode.org/wiki/Scope/Function_names_and_labels
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

' Functions are visible as soon as they are entered
DEF FN MyFunction$(param$)      ' auto-declares 'param$ for MyFunction$
    LET MyLocalVar$ = "Hello"   ' Just for local use
    PRINT param$
    RETURN MyLocalVar$
END DEF


' Labels are important part to structure your code, even when there is no need to jump around
' They bring clarity
[inits]
    LET varA$ = "[sub:jumpMe]"      ' Variables not visible to functions by default
    LET CONST_A# = "[sub:jumpMe]"   ' Constants are visible everywhere in program


[main]
    PRINT "Inside [main]"
    PRINT "Calling MyFunction with param 'Foo'"
    PRINT FN MyFunction$("Foo")

    GOSUB varA$ ' CONST_A# would work too here
END

[sub:jumpMe]
    PRINT "Inside " ; varA$         ' Variables visible here, inside of main program
RETURN

' Output:
' Inside [main]
' Calling MyFunction with param 'Foo'
' Foo
' Hello
' Inside [sub:jumpMe]
