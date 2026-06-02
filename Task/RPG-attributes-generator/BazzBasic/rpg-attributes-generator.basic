' ============================================
' https://rosettacode.org/wiki/RPG_attributes_generator
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' Attributes: Strength, Dexterity, Constitution,
'             Intelligence, Wisdom, Charisma
'
' Rules:
'   - Total of all attributes must be >= 75
'   - At least two attributes must be >= 15

' Roll 4d6, drop the lowest die, return sum of top 3
DEF FN RollStat$()
    LET r1$ = RND(6) + 1
    LET r2$ = RND(6) + 1
    LET r3$ = RND(6) + 1
    LET r4$ = RND(6) + 1
    RETURN r1$ + r2$ + r3$ + r4$ - MIN(MIN(r1$, r2$), MIN(r3$, r4$))
END DEF

[inits]
	LET MIN_TOTAL# = 75
	LET MIN_TWO#   = 15

    DIM attributes$
        attributes$("str") = 0
        attributes$("dex") = 0
        attributes$("con") = 0
        attributes$("int") = 0
        attributes$("wis") = 0
        attributes$("cha") = 0
    LET stat$      = 0
    LET total$     = 0
    LET highCount$ = 0
    LET passed$    = FALSE

[main]
    WHILE passed$ = FALSE
        stat$ = FN RollStat$() : attributes$("str") = stat$
        stat$ = FN RollStat$() : attributes$("dex") = stat$
        stat$ = FN RollStat$() : attributes$("con") = stat$
        stat$ = FN RollStat$() : attributes$("int") = stat$
        stat$ = FN RollStat$() : attributes$("wis") = stat$
        stat$ = FN RollStat$() : attributes$("cha") = stat$

        total$ = attributes$("str") + attributes$("dex") + attributes$("con") + attributes$("int") + attributes$("wis") + attributes$("cha")

        highCount$ = 0
        IF attributes$("str") >= MIN_TWO# THEN highCount$+=1
        IF attributes$("dex") >= MIN_TWO# THEN highCount$+=1
        IF attributes$("con") >= MIN_TWO# THEN highCount$+=1
        IF attributes$("int") >= MIN_TWO# THEN highCount$+=1
        IF attributes$("wis") >= MIN_TWO# THEN highCount$+=1
        IF attributes$("cha") >= MIN_TWO# THEN highCount$+=1

        IF total$ >= MIN_TOTAL# AND highCount$ >= 2 THEN passed$ = TRUE
    WEND

    PRINT "Attribute    Score"
    PRINT "------------------"
    PRINT "Strength     " + STR(attributes$("str"))
    PRINT "Dexterity    " + STR(attributes$("dex"))
    PRINT "Constitution " + STR(attributes$("con"))
    PRINT "Intelligence " + STR(attributes$("int"))
    PRINT "Wisdom       " + STR(attributes$("wis"))
    PRINT "Charisma     " + STR(attributes$("cha"))
    PRINT "------------------"
    PRINT "Total        " + STR(total$)
END

' Expected output (example - varies each run):
' Attribute    Score
' ------------------
' Strength     13
' Dexterity    15
' Constitution 12
' Intelligence 11
' Wisdom       15
' Charisma     10
' ------------------
' Total        76
