DECLARE FUNCTION countSubstring& (where AS STRING, what AS STRING)

PRINT "the three truths, th:", countSubstring&("the three truths", "th")
PRINT "ababababab, abab:", countSubstring&("ababababab", "abab")

FUNCTION countSubstring& (where AS STRING, what AS STRING)
    DIM c AS LONG, s AS LONG
    s = 1 - LEN(what)
    DO
        s = INSTR(s + LEN(what), where, what)
        IF 0 = s THEN EXIT DO
        c = c + 1
    LOOP
    countSubstring = c
END FUNCTION
