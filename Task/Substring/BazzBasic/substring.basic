' ============================================
' https://rosettacode.org/wiki/Substring
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
[inits]
    LET s$   = "Hello, World!"
    LET n$   = 8        ' start position
    LET m$   = 5        ' length
    LET pos$

[main]
    PRINT "Source string: "; s$
    PRINT ""

    ' Starting from n characters in, of m length
    PRINT "From n="; n$; " length m="; m$; ":  "; MID(s$, n$, m$)

    ' Starting from n characters in, to end of string
    PRINT "From n="; n$; " to end:          "; MID(s$, n$)

    ' Whole string minus last character
    PRINT "Without last char:        "; LEFT(s$, LEN(s$) - 1)

    ' From known character 'W', of m length
    pos$ = INSTR(s$, "W")
    PRINT "From char 'W' length m="; m$; ": "; MID(s$, pos$, m$)

    ' From known substring "World", of m length
    pos$ = INSTR(s$, "World")
    PRINT "From substr 'World' m="; m$; ":  "; MID(s$, pos$, m$)
END

' Output:
' Source string: Hello, World!
'
' From n=8 length m=5:  World
' From n=8 to end:          World!
' Without last char:        Hello, World
' From char 'W' length m=5: World
' From substr 'World' m=5:  World
