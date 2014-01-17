CLS

'header row
PRINT "     ";
FOR n = 1 TO 12
    'do it this way for alignment purposes
    o$ = "    "
    MID$(o$, LEN(o$) - LEN(STR$(n)) + 1) = STR$(n)
    PRINT o$;
NEXT
PRINT : PRINT "    "; STRING$(49, "-");

FOR n = 1 TO 12
    PRINT
    IF n < 10 THEN PRINT " ";
    PRINT n; "|";   'row labels
    FOR m = 1 TO n - 1
        PRINT "    ";
    NEXT
    FOR m = n TO 12
        'alignment again
        o$ = "    "
        MID$(o$, LEN(o$) - LEN(STR$(m * n)) + 1) = STR$(m * n)
        PRINT o$;
    NEXT
NEXT
