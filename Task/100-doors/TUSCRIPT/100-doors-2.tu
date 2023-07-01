    PRINT "Open doors are:"

    LET I = 1
10  IF I = 100 THEN END
    rem funcion SQR
    LET B = I*I
    rem funcion MODULO
    LET A = I - (I / B) * B
    IF A < 11 THEN PRINT B
    LET I = I + 1
    GOTO 10
