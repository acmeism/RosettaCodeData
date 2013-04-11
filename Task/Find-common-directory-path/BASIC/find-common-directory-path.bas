DECLARE FUNCTION commonPath$ (paths() AS STRING, pathSep AS STRING)

DATA "/home/user2", "/home/user1/tmp/covert/operator", "/home/user1/tmp/coven/members"

DIM x(0 TO 2) AS STRING, n AS INTEGER
FOR n = 0 TO 2
    READ x(n)
NEXT

PRINT "Common path is '"; commonPath$(x(), "/"); "'"

FUNCTION commonPath$ (paths() AS STRING, pathSep AS STRING)
    DIM tmpint1 AS INTEGER, tmpint2 AS INTEGER, tmpstr1 AS STRING, tmpstr2 AS STRING
    DIM L0 AS INTEGER, L1 AS INTEGER, lowerbound AS INTEGER, upperbound AS INTEGER
    lowerbound = LBOUND(paths): upperbound = UBOUND(paths)

    IF (lowerbound) = upperbound THEN       'Some quick error checking...
        commonPath$ = paths(lowerbound)
    ELSEIF lowerbound > upperbound THEN     'How in the...?
        commonPath$ = ""
    ELSE
        tmpstr1 = paths(lowerbound)

        FOR L0 = (lowerbound + 1) TO upperbound 'Find common strings.
            tmpstr2 = paths(L0)
            tmpint1 = LEN(tmpstr1)
            tmpint2 = LEN(tmpstr2)
            IF tmpint1 > tmpint2 THEN tmpint1 = tmpint2
            FOR L1 = 1 TO tmpint1
                IF MID$(tmpstr1, L1, 1) <> MID$(tmpstr2, L1, 1) THEN
                    tmpint1 = L1 - 1
                    EXIT FOR
                END IF
            NEXT
            tmpstr1 = LEFT$(tmpstr1, tmpint1)
        NEXT

        IF RIGHT$(tmpstr1, 1) <> pathSep THEN
            FOR L1 = tmpint1 TO 2 STEP -1
                IF (pathSep) = MID$(tmpstr1, L1, 1) THEN
                    tmpstr1 = LEFT$(tmpstr1, L1 - 1)
                    EXIT FOR
                END IF
            NEXT
            IF LEN(tmpstr1) = tmpint1 THEN tmpstr1 = ""
        ELSEIF tmpint1 > 1 THEN
            tmpstr1 = LEFT$(tmpstr1, tmpint1 - 1)
        END IF

        commonPath$ = tmpstr1
    END IF
END FUNCTION
