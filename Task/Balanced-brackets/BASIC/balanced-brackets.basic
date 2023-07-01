DECLARE FUNCTION checkBrackets% (brackets AS STRING)
DECLARE FUNCTION generator$ (length AS INTEGER)

RANDOMIZE TIMER

DO
    x$ = generator$ (10)
    PRINT x$,
    IF checkBrackets(x$) THEN
        PRINT "OK"
    ELSE
        PRINT "NOT OK"
    END IF
LOOP WHILE LEN(x$)

FUNCTION checkBrackets% (brackets AS STRING)
    'returns -1 (TRUE) if everything's ok, 0 (FALSE) if not
    DIM L0 AS INTEGER, sum AS INTEGER

    FOR L0 = 1 TO LEN(brackets)
        SELECT CASE MID$(brackets, L0, 1)
            CASE "["
                sum = sum + 1
            CASE "]"
                sum = sum - 1
        END SELECT
        IF sum < 0 THEN
            checkBrackets% = 0
            EXIT FUNCTION
        END IF
    NEXT

    IF 0 = sum THEN
        checkBrackets% = -1
    ELSE
        checkBrackets% = 0
    END IF
END FUNCTION

FUNCTION generator$ (length AS INTEGER)
    z = INT(RND * length)
    IF z < 1 THEN generator$ = "": EXIT FUNCTION
    REDIM x(z * 2) AS STRING
    FOR i = 0 TO z STEP 2
        x(i) = "["
        x(i + 1) = "]"
    NEXT
    FOR i = 1 TO UBOUND(x)
        z = INT(RND * 2)
        IF z THEN SWAP x(i), x(i - 1)
    NEXT
    xx$ = ""
    FOR i = 0 TO UBOUND(x)
        xx$ = xx$ + x(i)
    NEXT
    generator$ = xx$
END FUNCTION
