DIM i AS INTEGER

PRINT COMMAND$

PRINT "This program is named "; COMMAND$(0)
i = 1
DO WHILE(LEN(COMMAND$(i)))
    PRINT "The argument "; i; " is "; COMMAND$(i)
    i = i + 1
LOOP

FOR i = 0 TO __FB_ARGC__ - 1
        PRINT "arg "; i; " = '"; *__FB_ARGV__[i]; "'"
NEXT i
