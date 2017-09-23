DECLARE SUB addVal (value AS INTEGER)
DECLARE FUNCTION findMax% ()

REDIM SHARED vals(0) AS INTEGER
DIM SHARED valCount AS INTEGER
DIM x AS INTEGER, y AS INTEGER

valCount = -1

'''''begin test run
RANDOMIZE TIMER
FOR x = 1 TO 10
    y = INT(RND * 100)
    addVal y
    PRINT y; " ";
NEXT
PRINT ": "; findMax
'''''end test run

SUB addVal (value AS INTEGER)
    DIM tmp AS INTEGER
    IF valCount > -1 THEN
        'this is needed for BASICs that don't support REDIM PRESERVE
        REDIM v2(valCount) AS INTEGER
        FOR tmp = 0 TO valCount
            v2(tmp) = vals(tmp)
        NEXT
    END IF
    valCount = valCount + 1
    REDIM vals(valCount)
    IF valCount > 0 THEN
        'also needed for BASICs that don't support REDIM PRESERVE
        FOR tmp = 0 TO valCount - 1
            vals(tmp) = v2(tmp)
        NEXT
    END IF
    vals(valCount) = value
END SUB

FUNCTION findMax%
    DIM tmp1 AS INTEGER, tmp2 AS INTEGER
    FOR tmp1 = 0 TO valCount
        IF vals(tmp1) > tmp2 THEN tmp2 = vals(tmp1)
    NEXT
    findMax = tmp2
END FUNCTION
