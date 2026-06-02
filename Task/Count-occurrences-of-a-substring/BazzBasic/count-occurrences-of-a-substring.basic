' ============================================
' https://rosettacode.org/wiki/Count_occurrences_of_a_substring
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

DEF FN CountOccurrences$(haystack$, needle$)
    LET count$ = 0
    LET pos$   = 1
    LET nlen$  = LEN(needle$)
    LET found$ = INSTR(pos$, haystack$, needle$)
    WHILE found$ > 0
        count$+= 1
        pos$   = found$ + nlen$
        found$ = INSTR(pos$, haystack$, needle$)
    WEND
    RETURN count$
END DEF

[main]
    PRINT FN CountOccurrences$("the cat sat on the mat", "the")  ' 2
    PRINT FN CountOccurrences$("aaaaa", "aa")                    ' 2  (non-overlapping)
    PRINT FN CountOccurrences$("aaaa",  "aaa")                   ' 1  (non-overlapping)
    PRINT FN CountOccurrences$("hello world", "xyz")             ' 0
END

' Output:
' 2
' 2
' 1
' 0
