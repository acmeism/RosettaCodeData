' ============================================
' https://rosettacode.org/wiki/Strip_a_set_of_characters_from_a_string
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

DEF FN Stripper$(orig$, outs$)
    FOR i$ = 1 TO LEN(outs$)
        orig$ = REPLACE(orig$, MID(outs$, i$, 1), "")
    NEXT i$
    RETURN orig$
END DEF

[inits]
    LET text$ = "She was a soul stripper. She took my heart!"
    LET outs$ = "aei"

[output]
    CLS
    PRINT "Original: "; text$
    PRINT "Stripped: "; FN Stripper$(text$, outs$)
END

' Output:
' Original: She was a soul stripper. She took my heart!
' Stripped: Sh ws  soul strppr. Sh took my hrt!
