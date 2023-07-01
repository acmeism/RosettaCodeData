DECLARE SUB player (what AS STRING)

'this determines the length of the notes
'lower number = longer duration
CONST noteLen = 16

DIM tones(62) AS STRING

FOR n% = 0 TO 62
    READ tones(n%)
NEXT n%

'set up the playing system
PLAY "t255o4l" + LTRIM$(STR$(noteLen))

LINE INPUT "String to convert to Morse code: "; x$

FOR n% = 1 TO LEN(x$)
    c$ = UCASE$(MID$(x$, n%, 1))
    PLAY "p" + LTRIM$(STR$(noteLen / 2)) + "."
    SELECT CASE UCASE$(c$)
        CASE " "
            'since each char is effectively wrapped with 6 p's, we only need to add 1:
            PLAY "p" + LTRIM$(STR$(noteLen))
            PRINT "  ";
        CASE "!" TO "_"
            PRINT tones(ASC(c$) - 33); " ";
            player tones(ASC(c$) - 33)
        CASE ELSE
            PRINT "# ";
            player "#"
    END SELECT
    PLAY "p" + LTRIM$(STR$(noteLen / 2)) + "."
NEXT n%
PRINT

'all the Morse codes in ASCII order, from "!" to "_"
DATA "-.-.--", ".-..-.", "#", "...-..-", "#", ".-...", ".----.", "-.--."
DATA "-.--.-", "#", ".-.-.", "--..--", "-....-", ".-.-.-", "-..-.", "-----"
DATA ".----", "..---", "...--", "....-", ".....", "-....", "--...", "---.."
DATA "----.", "---...", "-.-.-.", "#", "-...-", "#", "..--..", ".--.-.", ".-"
DATA "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-"
DATA ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-"
DATA "...-", ".--", "-..-", "-.--", "--..", "#", "#", "#", "#", "..--.-"

SUB player (what AS STRING)
    FOR i% = 1 TO LEN(what)
        z$ = MID$(what, i%, 1)
        SELECT CASE z$
            CASE "."
                o$ = "g"
            CASE "-"
                o$ = "g" + LTRIM$(STR$(noteLen / 2)) + "."
            CASE ELSE
                o$ = "<<<<c>>>>"
        END SELECT
        PLAY o$
        PLAY "p" + LTRIM$(STR$(noteLen))
    NEXT i%
END SUB
