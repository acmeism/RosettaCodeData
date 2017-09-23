DECLARE FUNCTION half% (a AS INTEGER)
DECLARE FUNCTION doub% (a AS INTEGER)
DECLARE FUNCTION isEven% (a AS INTEGER)

DIM x AS INTEGER, y AS INTEGER, outP AS INTEGER

x = 17
y = 34

DO
    PRINT x,
    IF NOT (isEven(x)) THEN
        outP = outP + y
        PRINT y
    ELSE
        PRINT
    END IF
    IF x < 2 THEN EXIT DO
    x = half(x)
    y = doub(y)
LOOP

PRINT " =", outP

FUNCTION doub% (a AS INTEGER)
    doub% = a * 2
END FUNCTION

FUNCTION half% (a AS INTEGER)
    half% = a \ 2
END FUNCTION

FUNCTION isEven% (a AS INTEGER)
    isEven% = (a MOD 2) - 1
END FUNCTION
